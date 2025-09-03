# Regular Command Template

This template provides the standard structure for regular Claude command files. Use this template when creating commands that perform specific operations without complex flag-based routing.

**IMPORTANT**: This template follows all guidelines from `.claude/docs/agent-complex/claude-command-file-rules.md`.

## Template

```markdown
# Args: `<arg1>` `[arg2]`. v0.1.0. DESCRIPTION_PLACEHOLDER

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/COMMAND_NAME_PLACEHOLDER` in bash.

## Summary

[Provide a comprehensive summary of what this command does and its primary use cases]

## Usage

    /TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER <args>

## Arguments

- `<arg1>`: Description of first argument (REQUIRED)
  - Examples: value1, value2
  - Purpose: What this argument controls
- `[arg2]`: Description of second argument (OPTIONAL)
  - Examples: option1, option2
  - Purpose: What this optional argument controls

## Examples

    # Example 1: Basic usage
    /TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER arg1

    # Example 2: With optional parameters
    /TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER arg1 arg2

## What This Command Does

### 1. First Operation
- Description of what happens first
- Any validation or checks performed

### 2. Main Operation
- Core functionality description
- Key actions taken

### 3. Completion
- Final steps
- Output or results produced

## Script Integration

### Performance Optimization
This command can benefit from script-based execution for:
- Complex operations that benefit from parallelization
- File system operations
- API calls or external tool integration

Script location pattern: `../scripts/COMMAND_NAME_PLACEHOLDER_operation.sh`

## Implementation

    #!/bin/bash
    set -euo pipefail

    # Parse arguments
    if [ $# -lt 1 ]; then
        echo "❌ Error: Missing required arguments"
        echo "Usage: /TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER <args>"
        exit 1
    fi

    # Implementation goes here
    echo "Command implementation"

## Requirements

- List any dependencies or prerequisites
- Required tools or configurations
- Access permissions needed

## Error Handling

- **Missing Arguments**: Clear usage instructions
- **Invalid Input**: Validation and error messages
- **Operation Failures**: Recovery strategies

## Notes

- Important usage notes
- Best practices
- Performance considerations
```

## Usage Guidelines

### When to Use This Template
- For commands that perform a single, well-defined operation
- When the command doesn't require complex flag-based routing
- For utilities and helper commands

### Placeholder Replacements
The following placeholders should be replaced when using this template:

| Placeholder | Replace With | Example |
|------------|--------------|---------|
| `DESCRIPTION_PLACEHOLDER` | Command purpose | Deploy application to production environment |
| `COMMAND_NAME_PLACEHOLDER` | Command name | execute-deployment |
| `TOPIC_PLACEHOLDER` | Topic name | dev, git, tools, etc. |
| `<args>` | Actual arguments | `<branch-name>` `<commit-message>` |

### Best Practices
1. **Clear Documentation**: Provide comprehensive descriptions for each section
2. **Practical Examples**: Include real-world usage examples
3. **Error Handling**: Document common errors and solutions
4. **Script Integration**: Reference external scripts for complex operations
5. **Version Management**: Start at v1.0.0 for new commands

### Integration with update-command
The `update-command` command automatically uses this template when creating regular (non-meta) command files. The template is applied with automatic placeholder replacement.

## Related Documentation
- `.claude/docs/agent-complex/claude-command-file-rules.md` - Comprehensive guidelines for command file creation
- `.claude/docs/agent-complex/meta-command-template.md` - Template for meta-commands with flag-based routing
- `.claude/docs/agent-complex/claude-meta-command-file-rules.md` - Guidelines for meta-command development