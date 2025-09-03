# Nexus Integration Guide for Agent Complex Commands

## Overview

The agent-complex commands now support `nexus` as a type alongside `user` and `project`. This enables creation and management of nexus-specific agents, commands, scripts, and documentation that are synced from the engram-ops-nexus-module repository.

## Nexus Type Support

### What is Nexus?

Nexus represents organizational-level components that are shared across multiple projects and teams. These components are maintained in the engram-ops-nexus-module repository and synced to local projects using the `/sync:sync-nexus-ops` command.

### Path Conventions

When using `nexus` as the type, the following path conventions apply:

| Component | Source Path (in engram-ops-nexus-module) | Deployed Path | Example |
|-----------|-------------------------------------------|---------------|---------|
| **Agents** | `src/topics/{topic}/agents/{agent-name}.md` | `.claude/agents/nexus:{topic}:{agent-name}.md` | `src/topics/brand/agents/voice-guide.md` → `.claude/agents/nexus:brand:voice-guide.md` |
| **Commands** | `src/topics/{topic}/commands/{command-name}.md` | `.claude/commands/nexus/{topic}/{command-name}.md` | `src/topics/product/commands/roadmap-update.md` → `.claude/commands/nexus/product/roadmap-update.md` |
| **Scripts** | `src/topics/{topic}/scripts/{script-name}.*` | `.claude/scripts/nexus/{topic}/{script-name}.*` | `src/topics/customer-success/scripts/analyze-nps.sh` → `.claude/scripts/nexus/customer-success/analyze-nps.sh` |
| **Docs** | `src/topics/{topic}/docs/{doc-name}.md` | `.claude/docs/nexus/{topic}/{doc-name}.md` | `src/topics/mission/docs/core-values.md` → `.claude/docs/nexus/mission/core-values.md` |

**Important**: The sync process transforms the source paths by:
- **Agents**: Adding `nexus:{topic}:` prefix to the filename
- **Commands/Scripts/Docs**: Placing under `nexus/` namespace directory

## Updated Commands

All agent-complex commands now accept `nexus` as a valid type:

### 1. update-agent-complex

```bash
# Create a nexus agent complex
/agent-complex:update-agent-complex nexus:brand brand-consistency "Maintain brand voice and visual identity"
```

### 2. update-agent

```bash
# Create a nexus agent
/agent-complex:update-agent nexus:product feature-planner "Plan and prioritize product features"
# Deploys to: .claude/agents/nexus:product:feature-planner.md
```

### 3. update-command

```bash
# Create a nexus command
/agent-complex:update-command nexus:customer-success analyze-feedback "Analyze and categorize customer feedback"
# Creates: .claude/commands/nexus/customer-success/analyze-feedback.md
```

### 4. update-doc

```bash
# Create nexus documentation
/agent-complex:update-doc nexus:brand brand-guidelines "Brand voice, tone, and visual identity guidelines"
# Creates: .claude/docs/nexus/brand/brand-guidelines.md
```

### 5. process-qa

```bash
# Run QA on nexus components
/agent-complex:process-qa nexus "nexus organizational components quality check"
```

### 6. update-meta-command

```bash
# Create nexus meta-command
/agent-complex:update-meta-command nexus:go-to-market run-campaign-launch "Orchestrate go-to-market campaign launch"
# Creates: .claude/commands/nexus/go-to-market/run-campaign-launch.md
```

## Nexus Topics

Common nexus topics synced from engram-ops-nexus-module:

- **bizdev** - Business development resources and partnerships
- **brand** - Brand guidelines, voice, and visual identity
- **customer-success** - Customer success patterns and feedback analysis
- **executive** - Executive dashboards and strategic reports
- **go-to-market** - GTM strategies and campaign orchestration
- **mission** - Company mission, values, and culture
- **product** - Product management, roadmaps, and feature planning

## How Nexus Components Are Referenced

### In Agent Files

Nexus agents are referenced with the `nexus:` prefix:

```markdown
@agent-nexus:auth:login-handler
```

### In Command Files

Nexus commands are invoked with the `/nexus:` prefix:

```bash
/nexus:auth:setup-authentication
```

### In Documentation

Nexus documentation is referenced with full paths:

```markdown
See `.claude/docs/nexus/auth/authentication-patterns.md` for more details.
```

## Workflow Integration

### Syncing Nexus Content

1. **Initial Sync**: Run `/sync:sync-nexus-ops` to pull nexus content from the repository
2. **Regular Updates**: Periodically sync to get latest nexus updates
3. **Branch Support**: Sync from specific branches: `/sync:sync-nexus-ops --branch develop`

### Creating New Nexus Components

While nexus content is typically synced from the central repository, you can create local nexus components for testing:

1. Create the component using agent-complex commands with `nexus:` type
2. Test locally in your project
3. If approved, contribute back to engram-ops-nexus-module

### Best Practices

1. **Don't Modify Synced Content**: Nexus content synced from the repository should not be modified locally
2. **Use Topic Namespacing**: Always use appropriate topics (auth, database, etc.) for organization
3. **Follow Naming Conventions**: Use the `nexus:{topic}:{name}` pattern consistently
4. **Document Dependencies**: Clearly document any dependencies on nexus components

## Migration Guide

If you have existing components that should be nexus components:

1. Identify shared, organizational-level components
2. Move them to the engram-ops-nexus-module repository
3. Update references to use nexus naming conventions
4. Sync the content back to projects using `/sync:sync-nexus-ops`

## Troubleshooting

### Common Issues

1. **Nexus commands not found**: Ensure you've run `/sync:sync-nexus-ops` to sync nexus content
2. **Path conflicts**: Check that nexus paths don't conflict with existing project paths
3. **Permission errors**: Ensure you have write access to `.claude/` directories

### Validation

To validate nexus components are properly configured:

```bash
# Check nexus agents
ls -la .claude/agents/nexus:*

# Check nexus commands
ls -la .claude/commands/nexus/

# Run QA on nexus components
/agent-complex:process-qa nexus "validation check"
```

## Related Documentation

- `.nexus/README.md` - Nexus configuration overview
- `.claude/docs/agent-complex/claude-agent-file-rules.md` - Agent file standards
- `.claude/docs/agent-complex/claude-command-file-rules.md` - Command file standards
- `sync:sync-nexus-ops` command documentation - Syncing nexus content

## Version History

- **v1.0.0** - Initial nexus integration support
  - Added nexus type to all agent-complex commands
  - Implemented nexus path conventions
  - Updated scripts and documentation