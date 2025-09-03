# Meta-Command Template

This template provides the standard structure for meta-commands (orchestrator commands) that coordinate multiple operations through flag-based routing. Meta-commands use the `run-*` prefix naming convention.

**IMPORTANT**: This template follows all guidelines from `.claude/docs/agent-complex/claude-command-file-rules.md` and `.claude/docs/agent-complex/claude-meta-command-file-rules.md`.

## Template

```markdown
# Args: `<primary-arg>` `[optional-flags]`. v0.1.0. DESCRIPTION_PLACEHOLDER

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/COMMAND_NAME_PLACEHOLDER` in bash.

## Summary

[Provide a comprehensive summary of what this meta-command orchestrates]

## Usage

```bash
/TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER <args>
```

## Arguments

- `<arg1>`: Description of first argument (REQUIRED/OPTIONAL)
  - Examples: value1, value2
  - Purpose: What this argument controls

## Flag Reference Table

| Flag | Description | Triggers | Execution Mode | Dependencies |
|------|-------------|----------|----------------|--------------|
| `--example` | Example flag | `/example-command` | Serial | None |

## Examples

```bash
# Basic usage
/TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER arg1

# With flags
/TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER arg1 --example
```

## What This Command Does

### Meta-Command Orchestration

This meta-command follows the standard orchestration pattern (see `.claude/docs/agent-complex/claude-meta-command-file-rules.md`):

1. **Parse Arguments and Flags**
   - Validate required arguments
   - Process flag options
   - Determine execution path

2. **Execute Operations**
   - Route to appropriate commands based on flags
   - Coordinate multiple operations if needed
   - Handle dependencies between operations

3. **Provide Results**
   - Summarize operations performed
   - Report success/failure status
   - Suggest next steps

## Implementation

```bash
#!/bin/bash
set -euo pipefail

# Parse arguments
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER <args>"
    exit 1
fi

# Implementation goes here
echo "Meta-command implementation"
```

## Requirements

- List any dependencies or prerequisites

## Error Handling

- Document common errors and their solutions

## Notes

- Additional implementation notes
```

## Usage Guidelines

### When to Use This Template
- For commands that orchestrate multiple other commands
- When you need flag-based routing to different operations
- For workflow automation that combines several steps
- Commands that follow the `run-*` naming convention

### Placeholder Replacements
The following placeholders should be replaced when using this template:

| Placeholder | Replace With | Example |
|------------|--------------|---------|
| `DESCRIPTION_PLACEHOLDER` | Command purpose | Orchestrate complete deployment workflow with pre-checks and validation |
| `COMMAND_NAME_PLACEHOLDER` | Command name | run-deployment |
| `TOPIC_PLACEHOLDER` | Topic name | dev, git, tools, etc. |
| `<args>` | Actual arguments | `<project-name>` `[flags]` |

### Flag Table Guidelines

The Flag Reference Table is crucial for meta-commands. Each flag should include:

1. **Flag**: The exact flag syntax (e.g., `--deploy`, `--test`)
2. **Description**: Clear explanation of what the flag does
3. **Triggers**: Commands or operations triggered by this flag
4. **Execution Mode**: 
   - `Serial`: Operations run one after another
   - `Parallel`: Operations run simultaneously
   - `Mixed`: Combination of serial and parallel
5. **Dependencies**: Other flags that must be present

### Example Flag Table

```markdown
| Flag | Description | Triggers | Execution Mode | Dependencies |
|------|-------------|----------|----------------|--------------|
| `--setup` | Initialize environment | `/setup-database`, `/configure-env` | Serial | None |
| `--test` | Run test suite | `/run-unit-tests`, `/run-integration-tests` | Parallel | `--setup` |
| `--deploy` | Deploy application | `/build-app`, `/deploy-backend`, `/deploy-frontend` | Serial | `--test` |
| `--full` | Complete workflow | All of the above | Mixed | None |
```

### Best Practices

1. **Clear Flag Documentation**: Each flag should have a clear purpose
2. **Dependency Management**: Document flag dependencies explicitly
3. **Execution Modes**: Specify whether operations run in serial or parallel
4. **Error Handling**: Include validation for incompatible flag combinations
5. **Workflow Patterns**: Follow the 3-step orchestration pattern

### Standard Meta-Command Workflow

Meta-commands typically follow this pattern:

1. **Create Feature Branch** 
   - Establish development branch
   - Base branch usually `dev`

2. **Execute Operations**
   - Run commands based on flags
   - Can be commands, agents, or mixed

3. **Create Pull Request**
   - Finalize with PR creation
   - Target branch matches base branch

### Integration with update-command

The `update-command` command automatically uses this template when creating meta-commands (commands with `run-*` prefix). The template is applied with automatic placeholder replacement and includes the flag reference table structure.

## Related Documentation
- `.claude/docs/agent-complex/claude-command-file-rules.md` - Core guidelines for all command files
- `.claude/docs/agent-complex/claude-meta-command-file-rules.md` - Specific guidelines for meta-commands
- `.claude/docs/agent-complex/regular-command-template.md` - Template for standard commands