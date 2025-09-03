# Args: `<type:topic>` `<command-name>` `<description>`. v2.2.0. Create or update meta-command files following proper 3-step meta-command pattern from claude-meta-command-file-rules.md.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-meta-command` in bash.

## Summary

Creates or updates Claude meta-command files following the standard 3-step meta-command pattern from `.claude/docs/agent-complex/claude-meta-command-file-rules.md`. Supports topic-based organization for both user-level meta-commands (`~/.claude/commands/{topic}/`) and project-specific meta-commands (`.claude/commands/{topic}/`). The command generates specialized meta-command templates with the required `run-*` prefix, comprehensive flag tables for the generated commands, and proper workflow orchestration patterns. The generated templates include examples of flag-based operations that the meta-commands can implement.

## Command Execution

**CRITICAL**: This meta-command follows the standard 3-Step Meta-Command Pattern as required by claude-meta-command-file-rules.md:
1. Create Feature Branch from dev
2. Execute meta-command template generation  
3. Create Pull Request targeting dev

This ensures proper integration with the development pipeline and maintains consistency with all meta-command workflows.

## Usage

```bash
/agent-complex:update-meta-command <type:topic> <command-name> "<description>"
```

## Arguments

- `<type:topic>`: Meta-command type and topic combined (REQUIRED)
  - Format: `type:topic` where:
    - `type` is either `user`, `project`, or `nexus`
    - `topic` is the category (e.g., `dev`, `git`, `deployment`, `design`, `maintenance`, `auth`, `database`)
  - Examples: `user:dev`, `project:deployment`, `user:git`, `nexus:auth`
  - `user` meta-commands go to `~/.claude/commands/{topic}/`
  - `project` meta-commands go to `.claude/commands/{topic}/`
  - `nexus` meta-commands go to `.claude/commands/nexus/{topic}/`
- `<command-name>`: Name for the meta-command file (REQUIRED)
  - **MUST use `run-*` prefix** (enforced by meta-command naming convention)
  - Kebab-case format (lowercase with hyphens)
  - Should be descriptive of the workflow being orchestrated
  - Examples: `run-deploy-stack`, `run-design-dev`, `run-maintenance`, `run-setup-project`
  - Maximum 40 characters recommended
- `<description>`: Brief description of what this meta-command orchestrates (REQUIRED)
  - Should describe the high-level workflow coordination
  - Will be used in the command header and documentation
  - Focus on orchestration rather than specific implementation details

## Examples

```bash
# Basic meta-command creation
/agent-complex:update-meta-command user:dev run-deploy-stack "Orchestrate complete full-stack deployment workflow"
# Creates: ~/.claude/commands/dev/run-deploy-stack.md

# Git workflow meta-command
/agent-complex:update-meta-command user:git run-feature-branch "Orchestrate complete feature development cycle"
# Creates: ~/.claude/commands/git/run-feature-branch.md

# Design workflow meta-command
/agent-complex:update-meta-command project:design run-design-dev "Orchestrate design-to-development workflow"
# Creates: .claude/commands/design/run-design-dev.md

# Maintenance workflow meta-command
/agent-complex:update-meta-command user:maintenance run-system-health "Orchestrate comprehensive system health check and optimization"
# Creates: ~/.claude/commands/maintenance/run-system-health.md

# Deployment meta-command
/agent-complex:update-meta-command project:deployment run-deploy-staging "Orchestrate staging environment deployment and validation"
# Creates: .claude/commands/deployment/run-deploy-staging.md
```

## What This Command Does

### 1. Validate Arguments
- Validates type:topic format (e.g., user:dev, project:deployment)
- Validates type is either 'user' or 'project'
- Validates topic is provided (non-empty)
- **Validates meta-command name starts with `run-`** (meta-command naming convention)
- Validates command-name follows kebab-case format after the `run-` prefix

### 2. Generate Meta-Command Configuration
- Uses provided command-name directly (must include `run-` prefix)
- Generates meta-command template following 3-step pattern from claude-meta-command-file-rules.md
- Creates comprehensive flag tables with common meta-command operations
- Includes proper workflow orchestration patterns
- Determines appropriate file location based on type and topic

### 3. Create Meta-Command File
- Places meta-command in topic-based directory structure
- Follows 3-Step Meta-Command Pattern structure
- Includes comprehensive flag table for various operations
- Adds orchestration workflow with step-by-step execution
- Includes proper error handling and validation patterns

### 4. Directory Structure Management
- Creates necessary directories if they don't exist
- For user meta-commands: `~/.claude/commands/{topic}/`
- For project meta-commands: `.claude/commands/{topic}/`

## Meta-Command Structure Template

Generated meta-commands follow the standard 3-Step Meta-Command Pattern:

### Step 1: Feature Branch Creation
```bash
# Create feature branch for meta-command development
git checkout -b "feature/{topic}-{command-name}-$(date +%Y%m%d)"
```

### Step 2: Workflow Orchestration
- Flag-based operation selection
- Comprehensive workflow coordination
- Agent deployment and coordination
- Step-by-step execution with validation

### Step 3: Pull Request Creation
```bash
# Create PR for meta-command changes
/dev:create-pr "feat: implement {command-name} meta-command"
```

## Implementation

This command creates comprehensive meta-command templates that include:

1. **Standard 3-Step Pattern**: Follows meta-command development guidelines
2. **Flag Tables**: Comprehensive tables showing available operations
3. **Workflow Orchestration**: Step-by-step execution patterns
4. **Agent Integration**: Patterns for deploying and coordinating agents
5. **Error Handling**: Proper validation and error recovery
6. **Documentation**: Clear usage examples and best practices

## Directory Structure

### User Meta-Commands (Deployed Structure)
```
~/.claude/commands/
├── dev/
│   ├── run-deploy-stack.md
│   └── run-setup-project.md
├── git/
│   ├── run-feature-branch.md
│   └── run-release-cycle.md
└── maintenance/
    ├── run-system-health.md
    └── run-cleanup-workflow.md
```

### Project Meta-Commands (Deployed Structure)
```
.claude/commands/
├── deployment/
│   ├── run-deploy-staging.md
│   └── run-deploy-production.md
├── design/
│   ├── run-design-dev.md
│   └── run-design-review.md
└── testing/
    ├── run-test-suite.md
    └── run-e2e-testing.md
```

## Validation

The command validates:
- **Type**: Must be 'user' or 'project'
- **Topic**: Required, non-empty string
- **Command Name**: Must follow `run-*` prefix convention
- **Name Format**: Must be kebab-case after the `run-` prefix
- **Name Length**: Maximum 40 characters recommended

## Error Handling

- **Missing Arguments**: Clear usage instructions with format examples
- **Invalid Format**: Explains type:topic format with examples
- **Missing run- Prefix**: Enforces meta-command naming convention
- **Invalid Type**: Must be 'user' or 'project'
- **Invalid Topic**: Must be non-empty

## Notes

- **Meta-Command Naming**: All meta-commands MUST use the `run-*` prefix
- **3-Step Pattern**: Follows standard meta-command development pattern
- **Topic-Based Organization**: Maintains proper directory structure
- **Flag Tables**: Generated templates include comprehensive flag operations
- **Workflow Orchestration**: Templates provide step-by-step execution patterns
- **Guidelines Compliance**: Follows all patterns from claude-meta-command-file-rules.md
- **Template Quality**: Provides professional templates for meta-command development