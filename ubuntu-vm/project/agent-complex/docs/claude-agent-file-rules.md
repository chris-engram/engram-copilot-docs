# Claude Agents File Guidelines

This document outlines the standards and best practices for creating Claude agent files. These agents are specialized AI personalities that can be invoked via the Task tool to handle specific types of work with focused expertise.

> **🚨 MOST IMPORTANT RULE:** The frontmatter section at the top of your agent file MUST be properly formatted because **this metadata determines how Claude can discover and use your agent**. Without proper frontmatter, your agent won't be accessible!

## Table of Contents

- [Overview](#overview)
- [Agent Directory Structure](#agent-directory-structure)
  - [User Agents](#user-agents)
  - [Project Agents](#project-agents)
  - [Directory Organization](#directory-organization)
- [Agent File Structure](#agent-file-structure)
  - [1. Frontmatter Section](#1-frontmatter-section-critical)
  - [2. System Prompt Section](#2-system-prompt-section)
- [Agent Design Principles](#agent-design-principles)
  - [Focused Expertise](#focused-expertise)
  - [Clear Activation Triggers](#clear-activation-triggers)
  - [Structured Output](#structured-output)
- [Best Practices](#best-practices)
  - [Naming Conventions](#naming-conventions)
  - [Description Writing](#description-writing)
  - [Tool Selection](#tool-selection)
  - [Prompt Engineering](#prompt-engineering)
- [Agent Integration with Commands and Documentation](#agent-integration-with-commands-and-documentation)
  - [How Agents Use Commands and Docs](#how-agents-use-commands-and-docs)
  - [Including Command and Documentation References in Agent Files](#including-command-and-documentation-references-in-agent-files)
  - [Example: Agent Using Commands and Docs](#example-agent-using-commands-and-docs)
  - [Best Practices for Command and Documentation Integration](#best-practices-for-command-and-documentation-integration)
  - [Example Workflow with Commands](#example-workflow-with-commands)
- [Common Agent Patterns](#common-agent-patterns)
  - [Code Review Agents](#code-review-agents)
  - [Research Agents](#research-agents)
  - [Migration Agents](#migration-agents)
  - [Documentation Agents](#documentation-agents)
- [Testing and Validation](#testing-and-validation)
- [Example Agent Templates](#example-agent-templates)

## Overview

Claude agents are specialized configurations that enhance Claude's capabilities for specific tasks. When invoked through the Task tool, agents:

- Focus on a specific domain or type of work
- Apply specialized knowledge and methodologies
- Follow consistent patterns and formats
- Can access specific tools relevant to their purpose
- Maintain context and state during their execution

**Key Concepts:**
- **Agent**: A specialized AI configuration with focused expertise
- **Task Tool**: The mechanism for invoking agents (`Task` with `subagent_type` parameter)
- **Frontmatter**: YAML metadata that configures the agent
- **System Prompt**: The instructions that define the agent's behavior

## Agent Directory Structure

Claude agents are organized into three primary categories based on their scope and deployment:

### User Agents
- **Source Repository**: `engram-copilot-docs` (GitHub)
- **Location**: `ubuntu-vm/user/agents/` (flat) or `ubuntu-vm/user/{topic}/agents/` (topic-based)
- **Scope**: User-specific agents that enhance personal workflows
- **Examples**: 
  - `slack-release-summary.md` → `@agent-slack-release-summary` - Generates team-focused release summaries (flat)
  - `uiux-tester.md` → `@agent-uiux-tester` - Performs UI/UX testing workflows (flat)
  - `dev:release-notes-writer.md` → `@agent-dev:release-notes-writer` - Creates release notes from development changes (topic-based)
- **Characteristics**:
  - Personal productivity focused
  - User-specific configurations
  - Deployed with user-level sync commands (`sync-commands-with-remote`)
  - Accessible across all user projects
  - Topic-based agents are synced with `{topic}:{agent-name}.md` naming

### Project Agents  
- **Source Repository**: `engram-copilot-docs` (GitHub)
- **Location**: `ubuntu-vm/project/agents/` (flat) or `ubuntu-vm/project/agents/{topic}/` (topic-based)
- **Scope**: Project-specific agents for specialized workflows
- **Examples**:
  - `supabase:database-migrator.md` → `@agent-supabase:database-migrator` - Handles Supabase schema migrations (topic-based)
  - `cloudflare:worker-optimizer.md` → `@agent-cloudflare:worker-optimizer` - Optimizes Cloudflare Workers (topic-based)
  - `deployment-validator.md` → `@agent-deployment-validator` - General deployment validation (flat)
- **Characteristics**:
  - Project-specific logic and configurations
  - May depend on project infrastructure
  - Deployed with project-level sync commands (`sync-project-topic`)
  - Tailored to specific project needs
  - Topic-based agents provide better organization for complex projects

### Nexus Agents
- **Source Repository**: `engram-ops-nexus-module` (GitHub)
- **Source Location**: `src/topics/{topic}/agents/{agent-name}.md` (in repository)
- **Deployed Location**: `.claude/agents/` with `nexus:{topic}:{agent-name}.md` naming
- **Scope**: Organization-wide agents for shared organizational patterns
- **Examples**:
  - `nexus:brand:brand-voice.md` → `@agent-nexus:brand:brand-voice` - Maintains brand consistency
  - `nexus:customer-success:feedback-analyzer.md` → `@agent-nexus:customer-success:feedback-analyzer` - Analyzes customer feedback
  - `nexus:product:feature-planner.md` → `@agent-nexus:product:feature-planner` - Product feature planning
- **Characteristics**:
  - Organizational standards and patterns
  - Shared across multiple projects
  - Synced via `/sync:sync-nexus-ops` command
  - Maintained in central repository
  - Namespaced to avoid conflicts

### Directory Organization

#### Source Repositories:

**engram-copilot-docs repository:**
```
ubuntu-vm/
├── user/
│   ├── agents/              # User-level agents (personal productivity)
│   │   ├── slack-release-summary.md    # Flat agent
│   │   ├── uiux-tester.md              # Flat agent
│   │   ├── dev/                        # Topic-based agents
│   │   │   ├── release-notes-writer.md
│   │   │   └── issue-tracker.md
│   │   ├── git/                        # Topic-based agents
│   │   │   ├── pr-analyzer.md
│   │   │   └── commit-formatter.md
│   │   └── ...
│   └── scripts/             # Supporting scripts for user agents
│       └── slack-release-summary_intelligent-analyzer.sh
└── project/
    ├── agents/              # Project-level agents (project-specific)
    │   ├── deployment-validator.md         # Flat agent
    │   ├── supabase/                       # Topic-based agents
    │   │   ├── database-migrator.md
    │   │   └── edge-function-tester.md
    │   ├── cloudflare/                     # Topic-based agents
    │   │   ├── worker-optimizer.md
    │   │   └── kv-store-manager.md
    │   └── ...
    └── scripts/             # Supporting scripts for project agents
        └── project-specific-scripts.sh
```

**engram-ops-nexus-module repository:**
```
src/
└── topics/
    └── {topic}/                    # Any organizational topic
        ├── agents/
        │   └── {agent-name}.md     # Agent files
        ├── commands/
        │   └── {command-name}.md   # Command files
        ├── scripts/
        │   └── {script-name}.*     # Script files
        └── docs/
            └── {doc-name}.md       # Documentation files
```

Note: Source files use simple names but are deployed with nexus prefix
Available topics include: bizdev, brand, customer-success, executive, go-to-market, mission, product, and others as added

#### Deployed Structure (in local project):
```
.claude/
└── agents/              # All deployed agents mixed together
    ├── {agent-name}.md                        # Flat user agents (general topic)
    ├── {topic}:{agent-name}.md                # User/Project agents with topics
    └── nexus:{topic}:{agent-name}.md          # Nexus agents from engram-ops-nexus-module
```

Examples of deployed agents:
- `security-auditor.md` (flat user agent, general topic)
- `dev:release-notes-writer.md` (user agent from dev topic)
- `git:pr-analyzer.md` (user agent from git topic) 
- `supabase:database-migrator.md` (project agent from supabase topic)
- `cloudflare:worker-optimizer.md` (project agent from cloudflare topic)
- `nexus:brand:voice-guide.md` (nexus agent)
- `nexus:customer-success:feedback-analyzer.md` (nexus agent)
- `nexus:product:roadmap-planner.md` (nexus agent)

**💡 Choosing the Right Location:**
- Use `user/agents/{topic}/` for user-specific agents organized by topic (e.g., dev, git, slack)
- Use `user/agents/general/` for general-purpose user agents (backward compatibility)
- Use `project/agents/{topic}/` for project-specific agents organized by domain
- Use `project/agents/` (flat) for project agents that cross multiple domains
- Use `.claude/agents/nexus:{topic}:{name}.md` for organizational agents synced from nexus

**🔄 Agent Syncing:**

**User Agents** (from engram-copilot-docs via `sync-commands-with-remote`):
- Source: `ubuntu-vm/user/{topic}/agents/{agent-name}.md`
- Deployed: `.claude/agents/{topic}:{agent-name}.md`
- Examples:
  - `ubuntu-vm/user/dev/agents/release-notes-writer.md` → `.claude/agents/dev:release-notes-writer.md`
  - `ubuntu-vm/user/general/agents/security-auditor.md` → `.claude/agents/security-auditor.md`

**Project Agents** (from engram-copilot-docs via `sync-project-topic`):
- Source: `ubuntu-vm/project/{topic}/agents/{agent-name}.md`
- Deployed: `.claude/agents/{topic}:{agent-name}.md`
- Examples: 
  - `ubuntu-vm/project/supabase/agents/edge-function-master.md` → `.claude/agents/supabase:edge-function-master.md`
  - `ubuntu-vm/project/cloudflare/agents/worker-optimizer.md` → `.claude/agents/cloudflare:worker-optimizer.md`

**Nexus Agents** (from engram-ops-nexus-module via `/sync:sync-nexus-ops`):
- Source: `src/topics/{topic}/agents/{agent-name}.md` (in engram-ops-nexus-module)
- Deployed: `.claude/agents/nexus:{topic}:{agent-name}.md` (with nexus prefix added)
- Transformation: The sync process adds the `nexus:{topic}:` prefix to the filename
- Available Topics: bizdev, brand, customer-success, executive, go-to-market, mission, product

## Agent File Structure

Every Claude agent file consists of two main sections:

### 1. Frontmatter Section (CRITICAL)

The frontmatter section uses YAML format and MUST be enclosed between triple dashes (`---`). This section defines how the agent is discovered and invoked.

```yaml
---
name: agent-name
description: Brief comprehensive summary of agent's purpose and capabilities, including when to use it and what it accomplishes
tools: Tool1, Tool2, Tool3  # Optional: specific tools the agent can access
color: blue  # Optional: color for UI display (blue, green, red, yellow, etc.)
---
```

**Critical Frontmatter Fields:**

#### `name` (Required)
- **Format**: Lowercase with hyphens (kebab-case)
- **Examples**: `code-bug-reviewer`, `api-migration-assistant`, `security-auditor`
- **Rules**:
  - Must be unique across all agents
  - Should be descriptive but concise
  - No spaces or special characters except hyphens
  - Maximum 30 characters recommended

#### `description` (Required)
- **Purpose**: Tells Claude when and how to use this agent
- **Format**: Single-line string providing concise, comprehensive overview
- **Critical Principles**:
  1. **Holistic Overview**: The description must provide a balanced, comprehensive overview of ALL the agent's capabilities in a single line
  2. **Activation Conditions**: Must clearly specify the primary purpose and when to use the agent
  3. **Expected Outcomes**: Must describe what the agent accomplishes
- **Requirements**:
  1. Single line format (no multi-line YAML blocks)
  2. Comprehensive summary of agent's full scope
  3. Clear indication of when to use the agent
  4. Focus on capabilities and outcomes, not examples
- **Example Structure**:
```yaml
description: Brief comprehensive summary of agent's purpose and capabilities, including when to use it and what it accomplishes
```

#### `tools` (Optional)
- **Purpose**: Restrict or specify which tools the agent can access
- **Format**: Comma-separated list of tool names
- **Default**: If omitted, agent has access to all available tools (recommended default)
- **Example**: `tools: Grep, Read, Edit, MultiEdit, Write`
- **Best Practice**: Only specify tools when you need to restrict access for security or focus reasons
- **Use Cases**:
  - Security agents might exclude execution tools
  - Research agents might only need read/search tools
  - Migration agents need full file manipulation access
- **Note**: Most agents should omit this field to have full tool access

#### `color` (Optional)
- **Purpose**: Visual distinction in UI/logs
- **Options**: `blue`, `green`, `red`, `yellow`, `purple`, `orange`, `gray`
- **Default**: `gray` if not specified
- **Conventions**:
  - `blue`: General purpose agents
  - `green`: Success/validation agents
  - `red`: Critical/security agents
  - `yellow`: Warning/review agents

### 2. System Prompt Section

After the frontmatter, the rest of the file contains the system prompt that defines the agent's behavior, expertise, and approach.

**System Prompt Structure:**

1. **Role Definition** (First paragraph)
   - Who the agent is
   - Core expertise areas
   - Primary mission

2. **Responsibilities** (Numbered list)
   - Specific tasks the agent handles
   - Scope boundaries
   - Expected outcomes

3. **Methodology** (Detailed process)
   - Step-by-step approach
   - Decision criteria
   - Validation methods

4. **Output Format** (Structured template)
   - Consistent formatting
   - Required sections
   - Visual hierarchy

5. **Key Principles** (Guiding rules)
   - Quality standards
   - Behavioral guidelines
   - Edge case handling

**Example System Prompt Structure:**

```markdown
You are an expert [role] specializing in [expertise]. Your primary mission is to [mission statement].

Your core responsibilities:
1. **[Responsibility 1]**: [Detailed description]
2. **[Responsibility 2]**: [Detailed description]
3. **[Responsibility 3]**: [Detailed description]

Your methodology:
1. **[Phase 1]**: [What you do first]
2. **[Phase 2]**: [Next steps]
3. **[Phase 3]**: [Validation/completion]

When executing tasks, you will:
- [Specific behavior 1]
- [Specific behavior 2]
- [Specific behavior 3]

Your output format:
```
[Structured output template]
```

Key principles:
- [Principle 1]
- [Principle 2]
- [Principle 3]

Remember: [Closing reinforcement of mission]
```

## Agent Design Principles

### Focused Expertise

Each agent should:
- Have a single, clear purpose
- Excel at one type of task rather than being generalist
- Maintain deep knowledge in its domain
- Avoid scope creep

**Good Example**: `database-migration-agent` - Only handles database schema migrations
**Bad Example**: `general-helper-agent` - Too broad, unclear purpose

### Clear Activation Triggers

Agents must have:
- Explicit scenarios for activation
- Clear differentiation from other agents
- Unambiguous trigger conditions
- Example-driven descriptions

**Good Description Example**:
```yaml
description: Migrate database schemas between different versions or systems, handling MySQL to PostgreSQL conversions, version upgrades with data preservation, and migration risk analysis
```

### Structured Output

Agents should produce:
- Consistent formatting across invocations
- Clear section headers
- Actionable information
- Visual hierarchy for readability

## Best Practices

### Naming Conventions

1. **Use descriptive kebab-case names**
   -  `security-vulnerability-scanner`
   - L `secScan` or `security_scanner`

2. **Include the function, not the technology**
   -  `code-formatter`
   - L `prettier-wrapper`

3. **Avoid version numbers in names**
   -  `api-migrator`
   - L `api-migrator-v2`

### Description Writing

1. **Start with "Use this agent when..."**
   - Sets clear expectation
   - Helps with agent discovery
   - Improves Task tool accuracy

2. **Maintain holistic balance**
   - Cover ALL capabilities, not just recent updates
   - Avoid focusing on specific features at expense of others
   - Present comprehensive overview of agent's purpose

3. **Specify activation conditions clearly**
   - When should the primary agent invoke this?
   - What specific scenarios trigger its use?
   - What conditions must be met?

4. **Define expected outcomes**
   - What will be accomplished?
   - What deliverables will be provided?
   - What should the primary agent expect in the response?

5. **Include 2-3 concrete examples**
   - Real-world scenarios
   - Show edge cases
   - Demonstrate value

6. **Use structured example format**
   ```yaml
   <example>
   Context: [Set the scene]
   user: "[Actual user request]"
   assistant: "[How assistant should respond]"
   <commentary>
   [Why this agent is appropriate]
   </commentary>
   </example>
   ```

### Tool Selection

1. **Only include necessary tools**
   - Reduces token usage
   - Improves focus
   - Prevents misuse

2. **Common tool combinations**:
   - **Code Review**: `Read, Grep, Glob`
   - **Code Writing**: `Read, Write, Edit, MultiEdit`
   - **Research**: `WebSearch, WebFetch, Read`
   - **Migration**: Full file manipulation suite

3. **Exclude dangerous tools when appropriate**
   - Review agents shouldn't have `Write` access
   - Research agents don't need `Bash`

### Prompt Engineering

1. **Use clear role definitions**
   ```markdown
   You are an expert software architect specializing in microservices design and distributed systems.
   ```

2. **Provide structured methodologies**
   ```markdown
   Your review methodology:
   1. **Architecture Analysis**: Examine overall structure
   2. **Pattern Recognition**: Identify design patterns
   3. **Optimization Opportunities**: Suggest improvements
   ```

3. **Define explicit output formats**
   ```markdown
   Your output format:
   📊 ANALYSIS SUMMARY
   
   ━━━━━━━━━━━━━━━━━━
   Critical Issues: [count]
   Recommendations: [count]
   
   🔍 DETAILED FINDINGS
   [Structured findings]
   ```

## Agent Integration with Commands and Documentation

Agents can leverage Claude command files stored in `.claude/commands/` directories and reference documentation in `.claude/docs/` directories, making them highly composable and well-informed. This integration allows agents to call custom commands and access project-specific documentation.

### How Agents Use Commands and Docs

1. **Command Discovery**: Agents can access commands from:
   - `.claude/commands/` (project-specific commands)
   - `.claude/commands/` (user-wide commands)
   - `.claude/commands/{topic}/` (organized command topics)

2. **Documentation Access**: Agents can reference docs from:
   - `.claude/docs/` (project documentation)
   - `.claude/docs/` (user-wide documentation)
   - `.claude/docs/{topic}/` (topic-organized documentation)

3. **Command Invocation**: Agents execute commands using slash syntax:
   ```markdown
   /command-name [arguments]
   ```

4. **Seamless Integration**: Commands appear as modular building blocks that agents can compose into larger workflows, while documentation provides context and best practices.

### Including Command and Documentation References in Agent Files

It's best practice to include both a "Useful Commands" section and a "Related Documentation" section in your agent file:

**Important Path Considerations:**
1. **During Agent File Generation (Source Path)**: When creating the agent file, validate that documentation exists in the source directories:
   - User docs: `ubuntu-vm/user/{topic}/docs/`
   - Project docs: `ubuntu-vm/project/{topic}/docs/`
   
2. **During Agent Execution (Destination Path)**: When the agent runs, it will find the deployed docs at:
   - User docs: `.claude/docs/{topic}/`
   - Project docs: `<project-root>/.claude/docs/{topic}/`

```markdown
## Useful Commands

This agent may utilize the following commands during execution:

- `/sync-project-commands` - Sync project-specific command files
- `/execute-prompt` - Execute complex workflows with GitHub integration
- `/update-branch` - Update and sync git branches
- `/cleanup-pr` - Clean up completed pull requests

These commands are available if defined in your `.claude/commands/` directories.

## Related Documentation

This agent may reference the following documentation:

- `dev/typescript-style-guide.md` - TypeScript coding standards
- `git/pr-review-checklist.md` - Pull request review guidelines
- `security/api-security-guide.md` - API security best practices

These docs are available if defined in your `.claude/docs/` directories.
```

### Example: Agent Using Commands and Docs

```yaml
---
name: deployment-orchestrator
description: Orchestrate complex deployments across multiple services with automated rollbacks, health checks, and environment coordination
---

You are a deployment orchestration specialist...

## Useful Commands

During deployment workflows, you may use:

- `/deploy-edge-function` - Deploy Supabase edge functions
- `/validate-deployment` - Run deployment validation checks
- `/rollback-deployment` - Rollback to previous version if needed

When encountering deployment tasks, check if a relevant command exists before implementing from scratch.

## Related Documentation

Reference these docs for best practices and guidelines:

- `supabase/edge-function-best-practices.md` - Edge function deployment patterns
- `cloudflare/worker-deployment-guide.md` - Worker deployment procedures
- `general/deployment-checklist.md` - General deployment safety checks
```

### Best Practices for Command and Documentation Integration

1. **Document Available Commands**: List commands the agent is likely to use
2. **Reference Relevant Docs**: Include documentation that provides context and best practices
3. **Validate Documentation**: During agent file creation, verify docs exist in source paths
4. **Provide Usage Notes**: Document when and why the agent should reference each doc
5. **Prefer Commands Over Reimplementation**: If a command exists, use it
6. **Command Arguments**: Agents can pass arguments just like users
7. **Workflow Composition**: Combine multiple commands for complex tasks
8. **Fallback Logic**: Handle cases where commands might not be available
9. **Keep Docs Updated**: Ensure referenced documentation stays current with agent capabilities

### Example Workflow with Commands

```markdown
When performing a feature deployment:
1. First, I'll check the current branch: `/git-status`
2. Update the deployment branch: `/update-branch production`
3. Run pre-deployment checks: `/validate-deployment --env production`
4. Deploy the feature: `/deploy-feature --service api --env production`
5. Verify deployment: `/check-deployment-status`
```

## Common Agent Patterns

### Code Review Agents

**Purpose**: Analyze code for bugs, security issues, or quality problems

**Key Characteristics**:
- Read-only tool access
- Structured severity ratings
- Specific line number references
- Actionable recommendations

**Example Template**:
```yaml
---
name: code-bug-reviewer
description: Review recently written code for bugs, security vulnerabilities, logic errors, and potential runtime issues
tools: Read, Grep, Glob, LS
color: yellow
---

You are an expert software developer specializing in bug detection...
```

### Research Agents

**Purpose**: Gather information from various sources

**Key Characteristics**:
- Web search capabilities
- Information synthesis
- Source citation
- Fact verification

### Migration Agents

**Purpose**: Transform code or data between formats/systems

**Key Characteristics**:
- Full file manipulation access
- Validation steps
- Rollback strategies
- Progress tracking

### Documentation Agents

**Purpose**: Generate or update documentation

**Key Characteristics**:
- Markdown expertise
- Code analysis capabilities
- Consistent formatting
- Example generation

## Testing and Validation

### Pre-deployment Checklist

1. **Frontmatter Validation**
   - [ ] Valid YAML syntax
   - [ ] Required fields present
   - [ ] Name follows conventions
   - [ ] Description is single-line and comprehensive

2. **Prompt Testing**
   - [ ] Clear role definition
   - [ ] Structured methodology
   - [ ] Output format defined
   - [ ] Edge cases considered

3. **Tool Access Verification**
   - [ ] Minimal necessary tools
   - [ ] No security risks
   - [ ] Tools match purpose

### Testing Methodology

1. **Create test scenarios**
   ```bash
   # Test basic functionality
   Task(description="Test bug review", 
        prompt="Review this function for bugs: [code]",
        subagent_type="code-bug-reviewer")
   ```

2. **Verify output format**
   - Check structure consistency
   - Validate section presence
   - Ensure actionable content

3. **Test edge cases**
   - Empty inputs
   - Malformed requests
   - Tool failures

## Example Agent Templates

### Basic Code Review Agent

```yaml
---
name: code-quality-reviewer
description: Review code for quality, maintainability, and best practices, focusing on code structure, design patterns, and adherence to standards
color: blue
---

You are an expert software engineer specializing in code quality, maintainability, and best practices. Your primary mission is to ensure code meets high standards for long-term maintenance and team collaboration.

Your core responsibilities:
1. **Code Quality**: Assess readability, maintainability, and adherence to principles like DRY and SOLID
2. **Best Practices**: Verify implementation follows language-specific conventions and patterns
3. **Performance**: Identify potential optimizations without premature optimization
4. **Documentation**: Ensure code is self-documenting with appropriate comments

Your review methodology:
1. **Structure Analysis**: Examine overall organization and architecture
2. **Pattern Assessment**: Identify design patterns and anti-patterns
3. **Complexity Evaluation**: Measure cyclomatic complexity and suggest simplifications
4. **Maintainability Check**: Assess how easily others can understand and modify the code

Your output format:
```
📊 CODE QUALITY REPORT
━━━━━━━━━━━━━━━━━━━

Overall Score: [A-F]
Maintainability: [1-10]
Complexity: [Low/Medium/High]

✅ STRENGTHS
[What the code does well]

⚠️ AREAS FOR IMPROVEMENT
[Specific suggestions with examples]

📚 BEST PRACTICES
[Recommended patterns or refactoring]
```

Key principles:
- Focus on long-term maintainability over clever solutions
- Provide specific, actionable suggestions with code examples
- Balance critique with recognition of good practices
- Consider the project's context and constraints

Remember: You're helping developers write code that their future selves and teammates will thank them for.

## Useful Commands

During code review, I may utilize:
- `/lint-check` - Run linting and style checks
- `/test-coverage` - Analyze test coverage
- `/security-scan` - Perform security vulnerability scanning

These commands enhance my review capabilities if available in your environment.
```

### Specialized Migration Agent

```yaml
---
name: api-version-migrator
description: Migrate API implementations between different versions or frameworks, handling REST to GraphQL conversions, version upgrades, and framework migrations with compatibility preservation
tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS
color: green
---

You are an expert API architect specializing in version migrations and API evolution strategies. Your primary mission is to safely migrate APIs while maintaining backward compatibility and minimizing disruption.

[Rest of agent definition...]
```

## Summary

Creating effective Claude agents requires:
1. Clear, focused purpose
2. Properly formatted frontmatter
3. Well-structured system prompts
4. Appropriate tool selection
5. Comprehensive testing

By following these guidelines, you can create agents that enhance Claude's capabilities and provide specialized expertise for specific domains.