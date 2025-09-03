#!/bin/bash
set -euo pipefail

# update-command_main.sh - Main implementation script for update-command
# This script handles the core logic of creating or updating Claude command files

# 🔴 WORKFLOW ENFORCEMENT NOTICE 🔴
echo "═══════════════════════════════════════════════════════════════════"
echo "⚙️ UPDATE-COMMAND WORKFLOW v1.0.0"
echo "This command will:"
echo "1. Create a feature branch for your new command"
echo "2. Generate the command file with proper structure"
echo "3. Commit and push changes"
echo "4. Create a pull request for review"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 4 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /update-command <base-branch> <type:topic> <command-name> \"<description>\""
    echo "  base-branch: Branch to base feature on (e.g., main, dev)"
    echo "  type:topic: Combined type and topic (e.g., user:dev, project:supabase)"
    echo "  command-name: Name for the command (kebab-case)"
    echo "  description: Purpose and functionality of the command"
    exit 1
fi

BASE_BRANCH="$1"
TYPE_TOPIC="$2"
COMMAND_NAME="$3"
DESCRIPTION="$4"

# Parse type:topic format
if [[ ! "$TYPE_TOPIC" =~ ^([^:]+):([^:]+)$ ]]; then
    echo "❌ Error: Invalid type:topic format '$TYPE_TOPIC'"
    echo "Expected format: type:topic (e.g., user:dev, project:supabase)"
    exit 1
fi

TYPE="${BASH_REMATCH[1]}"
TOPIC="${BASH_REMATCH[2]}"

# Validate type
if [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ] && [ "$TYPE" != "nexus" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'user', 'project', or 'nexus'"
    exit 1
fi

# Validate topic (non-empty)
if [ -z "$TOPIC" ]; then
    echo "❌ Error: Topic cannot be empty"
    echo "Examples: dev, git, slack, docs, security, tools"
    exit 1
fi

# Validate command name format (kebab-case)
if ! [[ "$COMMAND_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "❌ Error: Invalid command name format"
    echo "Command name must be kebab-case (lowercase letters, numbers, and hyphens)"
    echo "Examples: execute-deployment, create-feature-branch, sync-database"
    exit 1
fi

# Validate command name length
if [ ${#COMMAND_NAME} -gt 40 ]; then
    echo "❌ Error: Command name too long (${#COMMAND_NAME} characters)"
    echo "Maximum 40 characters recommended"
    exit 1
fi

# Validate git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# 🚨 STEP 1: CREATE FEATURE BRANCH 🚨
echo ""
echo "📌 STEP 1: Creating feature branch..."
echo "───────────────────────────────────────"

# Generate feature branch name
FEATURE_NAME="add-$COMMAND_NAME-command"

# Inform Claude to use Task tool for create-feature-branch
echo "🔴 ACTION REQUIRED: Execute create-feature-branch command"
echo "Please execute: /git:create-feature-branch $BASE_BRANCH $FEATURE_NAME"
echo ""
echo "⏸️  Waiting for feature branch creation..."
echo "   The create-feature-branch command will:"
echo "   - Switch to $BASE_BRANCH branch and sync"
echo "   - Create branch: claude/$FEATURE_NAME"
echo "   - Handle any uncommitted changes"
echo ""

# Note: In actual execution, Claude will use Task tool here
# This is a placeholder for the workflow documentation

# 🚨 STEP 2: CREATE COMMAND FILE 🚨
echo ""
echo "📌 STEP 2: Creating command file..."
echo "───────────────────────────────────────"

# Determine target directory based on type and topic
if [ "$TYPE" = "user" ]; then
    TARGET_DIR="ubuntu-vm/user/$TOPIC/commands"
    SCOPE="user-level ($TOPIC topic)"
elif [ "$TYPE" = "project" ]; then
    TARGET_DIR="ubuntu-vm/project/$TOPIC/commands"
    SCOPE="project-specific ($TOPIC topic)"
elif [ "$TYPE" = "nexus" ]; then
    TARGET_DIR=".claude/commands/nexus/$TOPIC"
    SCOPE="nexus ($TOPIC topic)"
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Define command file path
COMMAND_FILE="$TARGET_DIR/$COMMAND_NAME.md"

# Check for existing command (determine if this is create or update)
ACTION="create"
if [ -f "$COMMAND_FILE" ]; then
    ACTION="update"
    echo "🔄 Updating existing command: $COMMAND_FILE"
else
    echo "🆕 Creating new command: $COMMAND_NAME"
fi

echo "⚙️ Processing $SCOPE command: $COMMAND_NAME"
echo "📁 Location: $COMMAND_FILE"

# Generate or update command file
if [ "$ACTION" = "update" ]; then
    # For updates, only update the description in the first line
    # Preserve all other content
    if grep -q "^# Args:" "$COMMAND_FILE"; then
        # Update the first line with new description
        sed -i "1s/.*/# Args: \`<args>\`. v1.0.0. $DESCRIPTION/" "$COMMAND_FILE"
        echo "✅ Command description updated successfully!"
    else
        echo "❌ Error: Existing file doesn't have proper Args header format"
        echo "Please manually update the file or delete it to recreate"
        exit 1
    fi
else
    # Create new command file with comprehensive template
    cat > "$COMMAND_FILE" << 'EOF'
# Args: `<arg1>` `<arg2>` `[optional-arg]`. v1.0.0. DESCRIPTION_PLACEHOLDER

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/COMMAND_NAME_PLACEHOLDER` in bash.

## Summary

[Provide a comprehensive summary of what this command does, its purpose, and key features]

## Usage

```bash
/COMMAND_NAME_PLACEHOLDER <arg1> <arg2> [optional-arg]
```

## Arguments

- `<arg1>`: Description of first required argument (REQUIRED)
  - Examples: value1, value2, value3
  - Additional guidance or constraints
- `<arg2>`: Description of second required argument (REQUIRED)
  - Examples: option1, option2, option3
  - Additional guidance or constraints
- `[optional-arg]`: Description of optional argument (OPTIONAL)
  - Default: default-value
  - Examples: opt1, opt2, opt3

## Examples

```bash
# Basic usage example
/COMMAND_NAME_PLACEHOLDER value1 option1

# Example with optional argument
/COMMAND_NAME_PLACEHOLDER value2 option2 opt1

# Complex example with explanation
/COMMAND_NAME_PLACEHOLDER complex-value special-option custom-opt
# This example demonstrates [specific use case]
```

## What This Command Does

[Detailed explanation of the command's functionality, step-by-step process, and expected outcomes]

### Key Features
- Feature 1: Description
- Feature 2: Description
- Feature 3: Description

### Process Overview
1. **Step 1**: What happens first
2. **Step 2**: What happens next
3. **Step 3**: Final actions and results

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from `ubuntu-vm/user/agent-complex/docs/claude-command-file-rules.md` regarding external script usage.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/COMMAND_NAME_PLACEHOLDER` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**

**🔴 MANDATORY RULE: If your implementation exceeds 50 lines of bash code, you MUST use external scripts** 🔴

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

#!/bin/bash
set -euo pipefail

# Parse arguments (keep minimal validation inline)
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /COMMAND_NAME_PLACEHOLDER <arg1> <arg2> [optional-arg]"
    exit 1
fi

ARG1="$1"
ARG2="$2"
OPTIONAL_ARG="${3:-}"

# 🔴 DECISION POINT: Complex logic must use external scripts
# If your implementation is simple (<50 lines), implement directly here
# If complex (>50 lines, loops, functions, workflows), use external scripts

# Example of simple direct implementation:
echo "🚀 Executing COMMAND_NAME_PLACEHOLDER..."
# [Simple implementation here if <50 lines]

# Example of external script pattern (for complex implementations):
# SCRIPT_PATHS=(
#     "$HOME/.claude/scripts/COMMAND_NAME_PLACEHOLDER_main.sh"
#     "../scripts/COMMAND_NAME_PLACEHOLDER_main.sh"
# )
# 
# SCRIPT_PATH=""
# for path in "${SCRIPT_PATHS[@]}"; do
#     if [[ -f "$path" ]]; then
#         SCRIPT_PATH="$path"
#         break
#     fi
# done
# 
# if [[ -n "$SCRIPT_PATH" ]]; then
#     echo "🚀 Using optimized script: $SCRIPT_PATH"
#     "$SCRIPT_PATH" "$ARG1" "$ARG2" "$OPTIONAL_ARG"
# else
#     echo "⚠️ Script not found. Using minimal fallback..."
#     exit 1
# fi
```

### Script Architecture (If Using External Scripts)

If this command requires external scripts (>50 lines, complex logic):

1. **COMMAND_NAME_PLACEHOLDER_main.sh**: Primary implementation
   - Core logic and workflow
   - Main processing steps

2. **COMMAND_NAME_PLACEHOLDER_helper.sh**: Supporting operations (optional)
   - Utility functions
   - Common operations

**Script Patterns:**
- User commands: `~/.claude/scripts/TOPIC_PLACEHOLDER/COMMAND_NAME_PLACEHOLDER_*.sh`
- Project commands: `.claude/scripts/TOPIC_PLACEHOLDER/COMMAND_NAME_PLACEHOLDER_*.sh`
- Development location: `../scripts/COMMAND_NAME_PLACEHOLDER_*.sh`

## Performance Considerations

- **Script Usage**: Use external scripts for operations >50 lines or complex workflows
- **Parallel Execution**: Where applicable, use parallel processing for independent operations
- **Validation Efficiency**: Front-load validation to fail fast on invalid inputs
- **Resource Management**: Clean up temporary resources and handle interruptions gracefully

## Requirements

- Git repository (command must be run within a git repository)
- [Other requirements specific to this command]
- [Dependencies on external tools]
- [Minimum version requirements]

## Error Handling

### Common Errors

- **Missing Arguments**: Validates all required arguments are provided
- **Invalid Format**: Ensures arguments follow expected patterns
- **Repository Requirements**: Verifies git repository context when needed
- **Permission Issues**: Handles file and directory permission problems

### Error Messages

The command provides clear, actionable error messages with:
- Description of what went wrong
- Expected format or values
- Examples of correct usage
- Suggestions for resolution

## Related Commands

- `/related-command-1` - Brief description of relationship
- `/related-command-2` - Brief description of relationship
- `/TOPIC_PLACEHOLDER:another-command` - Topic-specific related command

## Related Documentation

- `ubuntu-vm/user/agent-complex/docs/claude-command-file-rules.md` - Command file creation guidelines (MANDATORY READING)

**Additional Documentation:**
- User docs: `~/.claude/docs/{topic}/{doc-name}.md`
- Project docs: `.claude/docs/{topic}/{doc-name}.md` (relative to project root)

Examples:
- `~/.claude/docs/git/workflow-guide.md` - Git workflow best practices (user)
- `.claude/docs/supabase/edge-functions.md` - Supabase edge function guidelines (project)

## Notes

- **Script Rule Enforcement**: Commands >50 lines MUST use external scripts per guidelines
- [Important notes about command behavior]
- [Limitations or constraints]
- [Best practices for usage]

## Version History

- **v1.0.0** - Initial version
  - Core functionality implemented
  - Basic argument validation
  - External script pattern support
EOF

    # Replace placeholders with actual values
    sed -i "s/DESCRIPTION_PLACEHOLDER/$DESCRIPTION/g" "$COMMAND_FILE"
    sed -i "s/COMMAND_NAME_PLACEHOLDER/$COMMAND_NAME/g" "$COMMAND_FILE"
    sed -i "s/TOPIC_PLACEHOLDER/$TOPIC/g" "$COMMAND_FILE"
    
    echo "✅ Command file created successfully!"
fi

# 🚨 STEP 3: COMMIT AND PUSH 🚨
echo ""
echo "📌 STEP 3: Committing and pushing changes..."
echo "───────────────────────────────────────"

# Stage the command file
echo "📝 Staging command file..."
git add "$COMMAND_FILE"

# Create commit message
COMMIT_MSG="feat: $(if [ "$ACTION" = "update" ]; then echo "Update"; else echo "Add"; fi) $COMMAND_NAME command for $TOPIC topic

- $(if [ "$ACTION" = "update" ]; then echo "Updated"; else echo "Created"; fi) $SCOPE command
- Purpose: $DESCRIPTION
- Location: $COMMAND_FILE

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "💾 Committing changes..."
git commit -m "$COMMIT_MSG"

echo "🚀 Pushing to remote..."
git push origin "claude/$FEATURE_NAME"

# 🚨 STEP 4: CREATE PULL REQUEST 🚨
echo ""
echo "📌 STEP 4: Creating pull request..."
echo "───────────────────────────────────────"

# Build PR body based on action
if [ "$ACTION" = "update" ]; then
    PR_BODY="## Summary

This PR updates the existing $SCOPE command: $COMMAND_NAME

## Description
Updated description: $DESCRIPTION

## Command Details
- **Name**: $COMMAND_NAME
- **Type**: $SCOPE
- **Topic**: $TOPIC
- **File**: $COMMAND_FILE
- **Action**: Updated existing command

## Changes Made
- Updated the command description in header
- All other content preserved (structure, examples, implementation)

## Sync Behavior
$(if [ "$TYPE" = "user" ]; then
    echo "Syncs to: ~/.claude/commands/$TOPIC/$COMMAND_NAME.md"
elif [ "$TYPE" = "project" ]; then
    echo "Project commands sync to project-specific locations"
elif [ "$TYPE" = "nexus" ]; then
    echo "Syncs to: .claude/commands/nexus/$TOPIC/$COMMAND_NAME.md"
fi)

🤖 Generated with [Claude Code](https://claude.ai/code)"
else
    PR_BODY="## Summary

This PR adds a new $SCOPE command: $COMMAND_NAME

## Description
$DESCRIPTION

## Command Details
- **Name**: $COMMAND_NAME
- **Type**: $SCOPE
- **Topic**: $TOPIC
- **File**: $COMMAND_FILE

## Sync Behavior
$(if [ "$TYPE" = "user" ]; then
    echo "Will sync to: ~/.claude/commands/$TOPIC/$COMMAND_NAME.md"
elif [ "$TYPE" = "project" ]; then
    echo "Project commands sync to project-specific locations"
elif [ "$TYPE" = "nexus" ]; then
    echo "Will sync to: .claude/commands/nexus/$TOPIC/$COMMAND_NAME.md"
fi)

## Testing
To test the command after merge:
\`\`\`
/$TOPIC:$COMMAND_NAME <args>
\`\`\`

## Next Steps
1. Review and customize the generated command file:
   - Update the Args line with specific argument structure
   - Replace placeholder content with actual implementation
   - Add proper examples and usage patterns
2. Consider creating supporting scripts:
   - Check if script-based execution would improve performance
   - Create scripts in ../scripts/ following naming convention
   - Update command file to integrate with scripts
3. Add relevant documentation references:
   - Link to related docs in ubuntu-vm/$TYPE/docs/
   - Reference related commands for workflow integration
4. Test the command thoroughly:
   - Verify all argument combinations work correctly
   - Test error handling and edge cases
   - Ensure integration with existing workflows

## Guidelines
Refer to ubuntu-vm/user/agent-complex/docs/claude-command-file-rules.md for the latest best practices

🤖 Generated with [Claude Code](https://claude.ai/code)"
fi

echo "🔄 Creating PR with GitHub CLI..."
PR_URL=$(gh pr create \
  --base "$BASE_BRANCH" \
  --title "feat: $(if [ "$ACTION" = "update" ]; then echo "Update"; else echo "Add"; fi) $COMMAND_NAME command for $TOPIC topic" \
  --body "$PR_BODY" 2>&1)

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo "✅ SUCCESS: Command $(if [ "$ACTION" = "update" ]; then echo "update"; else echo "creation"; fi) workflow completed!"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "📋 Summary:"
    echo "  - Command: $TOPIC:$COMMAND_NAME"
    echo "  - Branch: claude/$FEATURE_NAME"
    echo "  - File: $COMMAND_FILE"
    echo "  - PR: $PR_URL"
    echo ""
    echo "🎯 Next Actions:"
    echo "  1. Visit the PR to review the command file"
    echo "  2. Customize the command's implementation and examples"
    echo "  3. Create supporting scripts if beneficial"
    echo "  4. Request review when ready"
    echo "  5. Merge to deploy the command"
else
    echo "❌ Error creating PR. Please create manually:"
    echo "  gh pr create --base $BASE_BRANCH --title \"feat: $(if [ "$ACTION" = "update" ]; then echo "Update"; else echo "Add"; fi) $COMMAND_NAME command for $TOPIC topic\""
fi