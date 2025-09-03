# Args: `<type>` `[description]`. v1.0.0. Validates that all references to agents, commands, docs and scripts refer to real entities that currently exist. Prevents fictional or future references in documentation and ensures deployment readiness.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/check-fictional-refs` in bash.

## Summary

**REFERENCE INTEGRITY VALIDATION**: Validates that all entity references in command files, agent files, and documentation point to real, existing entities. This command prevents deployment failures caused by references to non-existent agents, commands, scripts, or documentation files. We do not accept references to entities that will be created in the future or to entities that do not currently exist.

## Usage

```bash
/agent-complex:check-fictional-refs <type> [description]
```

## Arguments

- `<type>`: Type of validation to perform (REQUIRED)
  - Accepts: 'root', 'user', 'project', or 'all'
  - Purpose: Determines which files to scan for entity references
  - **'root'**: Focus on root-level commands and scripts
  - **'user'**: Focus on user-level commands, agents, and docs
  - **'project'**: Focus on project-level commands, agents, and docs
  - **'all'**: Scan entire repository for all entity references
- `[description]`: Context description for validation (OPTIONAL)
  - Default: "entity reference validation"
  - Examples: "pre-commit validation", "PR review check", "deployment readiness"
  - Purpose: Provides context for the validation being performed

## Examples

```bash
# Check root-level entity references
/agent-complex:check-fictional-refs root

# Check user-level entity references
/agent-complex:check-fictional-refs user "user command validation"

# Check project-level entity references
/agent-complex:check-fictional-refs project "project deployment check"

# Validate all entity references in the repository
/agent-complex:check-fictional-refs all "pre-commit validation"

# Full repository scan before deployment
/agent-complex:check-fictional-refs all "production deployment readiness"
```

## What This Command Does

### Entity Reference Validation

This command performs comprehensive validation of all references to ensure they point to real, existing entities:

1. **Agent References**
   - Pattern: `@agent-{topic}:{agent-name}` or `{topic}:{agent-name}`
   - Validates agent files exist in correct locations:
     - User agents: `ubuntu-vm/user/{topic}/agents/{agent-name}.md`
     - Project agents: `ubuntu-vm/project/{topic}/agents/{agent-name}.md`
   - Example: `@agent-dev:code-optimizer` requires `ubuntu-vm/user/dev/agents/code-optimizer.md`

2. **Command References**
   - Pattern: `/{topic}:{command-name}` or `/agent-complex:{command-name}`
   - Validates command files exist in correct locations:
     - Root commands: `ubuntu-vm/root/commands/{command-name}.md`
     - User commands: `ubuntu-vm/user/{topic}/commands/{command-name}.md`
     - Project commands: `ubuntu-vm/project/{topic}/commands/{command-name}.md`
   - Example: `/dev:execute-prompt` requires `ubuntu-vm/user/dev/commands/execute-prompt.md`

3. **Script References**
   - Pattern: `{path}/{script-name}_{operation}.sh`
   - Validates script files exist with correct naming:
     - Development: `../scripts/{script-name}_{operation}.sh`
     - User deployed: `~/.claude/scripts/{topic}/{script-name}_{operation}.sh`
     - Project deployed: `.claude/scripts/{topic}/{script-name}_{operation}.sh`
   - Performs reverse mapping from deployment to source paths

4. **Documentation References**
   - Pattern: `` `{path}/{doc-name}.md` `` (must use backticks)
   - Validates documentation files exist:
     - User docs: `ubuntu-vm/user/{topic}/docs/{doc-name}.md`
     - Project docs: `ubuntu-vm/project/{topic}/docs/{doc-name}.md`
   - Ensures no hyperlink format is used for internal references

### Reverse Path Mapping

The command performs intelligent reverse mapping from deployment paths to source paths:

**User-Level Mapping:**
```
~/.claude/commands/{topic}/*.md → ubuntu-vm/user/{topic}/commands/*.md
~/.claude/agents/{topic}:*.md → ubuntu-vm/user/{topic}/agents/*.md
~/.claude/docs/{topic}/*.md → ubuntu-vm/user/{topic}/docs/*.md
~/.claude/scripts/{topic}/*.sh → ubuntu-vm/user/{topic}/scripts/*.sh
```

**Project-Level Mapping:**
```
.claude/commands/{topic}/*.md → ubuntu-vm/project/{topic}/commands/*.md
.claude/agents/{topic}/*.md → ubuntu-vm/project/{topic}/agents/*.md
.claude/docs/{topic}/*.md → ubuntu-vm/project/{topic}/docs/*.md
.claude/scripts/{topic}/*.sh → ubuntu-vm/project/{topic}/scripts/*.sh
```

**Root-Level Mapping:**
```
/root/.claude/commands/*.md → ubuntu-vm/root/commands/*.md
/root/.claude/scripts/*.sh → ubuntu-vm/root/scripts/*.sh
/root/.claude/docs/*.md → ubuntu-vm/root/docs/*.md
```

### Validation Process

1. **Discovery Phase**
   - Scan files based on type parameter
   - Use git status to identify recently modified files
   - Recursively search for reference patterns

2. **Extraction Phase**
   - Extract all entity references using regex patterns
   - Capture reference context (file, line number)
   - Categorize references by type

3. **Resolution Phase**
   - Apply reverse path mapping rules
   - Resolve deployment paths to source paths
   - Handle topic-based organization

4. **Validation Phase**
   - Check file existence for each reference
   - Validate naming conventions
   - Verify format requirements (backticks for docs)

5. **Reporting Phase**
   - Generate detailed error reports with line numbers
   - Provide actionable fix suggestions
   - Summary statistics and recommendations

### Error Reporting Format

```
❌ FICTIONAL REFERENCE DETECTED
File: ubuntu-vm/user/dev/commands/execute-prompt.md
Line: 45
Issue: Reference to non-existent agent 'dev:code-optimizer'
Expected: Agent file should exist at ubuntu-vm/user/dev/agents/code-optimizer.md
Status: File not found
Suggestion: Create the agent file or update the reference to an existing agent

📋 VALIDATION SUMMARY
- Total files scanned: 156
- References validated: 1,247
- Fictional references found: 3
- Missing entities: 2 agents, 1 script
- Format violations: 1 hyperlink usage
Status: ❌ FAILED - Fix fictional references before deployment
```

## Implementation

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/check-fictional-refs` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**

**🔴 MANDATORY RULE: If your implementation exceeds 50 lines of bash code, you MUST use external scripts** 🔴

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

#!/bin/bash
set -euo pipefail

# Parse arguments
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required type argument"
    echo "Usage: /agent-complex:check-fictional-refs <type> [description]"
    echo "  type: 'root', 'user', 'project', or 'all'"
    echo "  description: Optional context for validation"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-entity reference validation}"

# Validate type argument
if [[ "$TYPE" != "root" && "$TYPE" != "user" && "$TYPE" != "project" && "$TYPE" != "all" ]]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'root', 'user', 'project', or 'all'"
    exit 1
fi

# Display validation context
echo "🔍 Validating entity references for real existence..."
echo "📋 Type: $TYPE"
echo "📝 Context: $DESCRIPTION"
echo "🎯 Goal: Ensure all references point to existing entities"
echo ""

# This command requires external script due to complex file scanning and validation
# Following the >50 lines rule from claude-command-file-rules.md
SCRIPT_PATHS=(
    "../scripts/check-fictional-refs_analyzer.sh"
    ".claude/scripts/agent-complex/check-fictional-refs_analyzer.sh"
)

SCRIPT_PATH=""
for path in "${SCRIPT_PATHS[@]}"; do
    expanded_path="${path/#\~/$HOME}"
    if [[ -f "$expanded_path" ]]; then
        SCRIPT_PATH="$expanded_path"
        break
    fi
done

if [[ -n "$SCRIPT_PATH" ]]; then
    echo "🚀 Using reference validator script: $SCRIPT_PATH"
    "$SCRIPT_PATH" "$TYPE" "$DESCRIPTION"
else
    echo "⚠️ Reference validator script not found. Using basic fallback..."
    echo "📋 Would validate entity references for type: $TYPE"
    echo "📝 Context: $DESCRIPTION"
    echo "📝 Script should be created at: ../scripts/check-fictional-refs_analyzer.sh"
    echo "⚠️ CRITICAL: Cannot validate entity references without analyzer script"
    exit 1
fi
```

### Script Architecture

This command requires external scripts due to complex file scanning and validation logic:

1. **check-fictional-refs_analyzer.sh**: Primary implementation
   - File discovery based on scope
   - Reference extraction using regex patterns
   - Reverse path mapping logic
   - Existence validation
   - Detailed error reporting

**Script Patterns:**
- User deployment: `~/.claude/scripts/agent-complex/check-fictional-refs_*.sh`
- Development location: `../scripts/check-fictional-refs_*.sh`

## Performance Considerations

- **Type-Based Validation**: Use specific type (root/user/project) for focused checks
- **Caching**: Cache validated references during single run
- **Parallel Processing**: Process independent file validations in parallel
- **Early Exit**: Stop on first error in CI/CD contexts with --fail-fast flag

## Requirements

- Git repository (for git status integration)
- Access to entire repository structure for validation
- Read access to all command, agent, script, and doc files
- Basic shell utilities (grep, find, sed, awk)

## Error Handling

### Common Errors

- **Missing Files**: Entity referenced but file doesn't exist
- **Wrong Location**: Entity exists but in wrong directory
- **Format Issues**: Documentation not using inline code format
- **Future References**: References to planned but non-existent entities

### Error Resolution

Each error provides:
- Exact file and line number
- Expected file location
- Suggested fixes
- Related documentation references

## Related Commands

- `/agent-complex:check-paths` - Validates deployment path readiness
- `/agent-complex:check-documentation` - Validates documentation standards
- `/agent-complex:check-performance-optimizations` - Identifies optimization opportunities
- `/agent-complex:run-qa` - Comprehensive quality assurance orchestration

## Related Documentation

- `.claude/docs/agent-complex/claude-command-file-rules.md` - Command file guidelines
- `.claude/docs/agent-complex/claude-agent-file-rules.md` - Agent file guidelines
- `.claude/docs/agent-complex/agent-complex-rules.md` - Core principles and patterns

## Notes

- **Zero Tolerance**: No fictional references are acceptable
- **Present State**: Only validates against current repository state
- **Format Enforcement**: Documentation must use backticks, not hyperlinks
- **Reverse Mapping**: Intelligently maps deployment paths to source locations
- **CI/CD Ready**: Designed for integration into deployment pipelines

## Version History

- **v1.0.0** - Initial release
  - Comprehensive entity reference validation
  - Support for agents, commands, scripts, and docs
  - Reverse path mapping from deployment to source
  - Detailed error reporting with fix suggestions
  - Multiple scope options for flexible validation