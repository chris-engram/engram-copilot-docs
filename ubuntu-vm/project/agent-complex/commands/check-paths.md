# Args: `<type>` `[description]`. v1.8.0. Validates deployment readiness for user or project commands. Checks script and docs existence, naming conventions, reference formats (docs must use inline code, not hyperlinks), cross-script references, and path accuracy with topic-based organization. Ensures commands will work correctly when deployed to production.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/check-paths` in bash.

## Summary

**DEPLOYMENT VALIDATION**: Validates that command and script files are ready for DEPLOYED context (when running from `.claude/`). This command checks paths during development to ensure they will work correctly when deployed. It verifies that commands use proper tilde notation (`.claude/`), scripts have correct fallback patterns, no hardcoded development paths remain, and that referenced script files exist with correct naming conventions.

## Usage

```bash
/agent-complex:check-paths <type> [description]
```

## Arguments

- `<type>`: Type of path fixes to apply (REQUIRED)
  - Accepts: 'root', 'user', or 'project'
  - Purpose: Determines which path patterns and naming conventions to apply
  - **'root'**: Root-level commands
    - Deployed path: `/root/.claude/scripts/`, `/root/.claude/docs/`
    - Script naming: `<command-name>_{operation}.*`
    - Example: `cleanup-pr_analyzer.sh`
  - **'user'**: Topic-based user commands  
    - Deployed path: `~/.claude/scripts/{topic}/`, `~/.claude/docs/{topic}/`
    - Script naming: `<command-name>_{operation}.*`
    - Example: `execute-prompt_validator.sh`
  - **'project'**: Project-specific commands
    - Deployed path: `.claude/scripts/{topic}/`, `.claude/docs/{topic}/`
    - Script naming: `<command-name>_{operation}.*`
    - Example: `deploy-service_main.sh`
- `[description]`: Description of files/locations to analyze (OPTIONAL)
  - Default: "working directory changes" (analyzes current git working directory)
  - Examples: "staged changes", "last commit files", "modified command files", "recent script updates"
  - Purpose: Provides context for which files to analyze for path accuracy
  - The actual files analyzed are determined by git status regardless of description

## Examples

```bash
# Check root-level user commands (no topic prefix in script names)
/agent-complex:check-paths root

# Check topic-based user commands (topic prefix required)
/agent-complex:check-paths user "dev topic commands"

# Check project-level paths with descriptive context
/agent-complex:check-paths project "staged changes ready for commit"

# Check root commands with context for recently modified files  
/agent-complex:check-paths root "last commit files"

# Check user topic commands with specific file type context
/agent-complex:check-paths user "modified dev command files"

# Check project-level paths for supabase topic
/agent-complex:check-paths project "supabase command updates"
```

### Quick Reference: Script Naming Patterns

| Command Type | Path Location | Naming Pattern | Example |
|--------------|---------------|----------------|---------|
| **Root** | `/root/.claude/scripts/` | `<command-name>_{operation}.*` | `cleanup-pr_analyzer.sh` |
| **User** | `~/.claude/scripts/{topic}/` | `<command-name>_{operation}.*` | `execute-prompt_validator.sh` |
| **Project** | `.claude/scripts/{topic}/` | `<command-name>_{operation}.*` | `deploy-service_main.sh` |

### Common Usage Scenarios

**During Development:**
```bash
# After creating/modifying root-level user command files - check before committing
/agent-complex:check-paths root "development changes"

# After creating/modifying topic-based user command files - check before committing
/agent-complex:check-paths user "development changes"

# After creating/modifying project command files - check before committing
/agent-complex:check-paths project "development changes"
```

**Before Staging:**
```bash
# Validate user-level changes before staging them
/agent-complex:check-paths user "files ready for staging"
git add -A  # Stage after validation passes

# Validate project-level changes before staging them
/agent-complex:check-paths project "files ready for staging"
git add -A  # Stage after validation passes
```

**Pre-Commit Validation:**
```bash
# Check staged user changes before committing  
/agent-complex:check-paths user "staged changes for commit"
git commit -m "feat: update user command paths"  # Commit after validation

# Check staged project changes before committing  
/agent-complex:check-paths project "staged changes for commit"
git commit -m "feat: update project command paths"  # Commit after validation
```

**Code Review Preparation:**
```bash
# Verify recent user-level changes follow path standards
/agent-complex:check-paths user "changes for code review"

# Verify recent project-level changes follow path standards
/agent-complex:check-paths project "changes for code review"
```

## What This Command Does

**VALIDATES DEPLOYED CONTEXT READINESS**: Ensures command and script files will work correctly when deployed to `.claude/`. This is critical because paths that work during development in `/opt/projects/` may fail when commands are deployed. The command runs during development but validates for production deployment.

### Key Validation Features for Deployment

1. **Deployment Context Requirements (Type-Specific)**
   
   **User Commands (type='user')**:
   - **Primary Script Path**: Commands MUST use `~/.claude/scripts/{topic}/` as the primary script path
   - **Fallback Path**: Development path `../scripts/` should be secondary fallback only
   - **Documentation Paths**: Must use `~/.claude/docs/{topic}/` for deployed documentation
   - **Tilde Notation**: Use `~/.claude/` not `$HOME/.claude/` for portability
   
   **Project Commands (type='project')**:
   - **Primary Script Path**: Commands MUST use `.claude/scripts/{topic}/` as the primary script path
   - **Fallback Path**: Development path `../scripts/` should be secondary fallback only
   - **Documentation Paths**: Must use `.claude/docs/{topic}/` for deployed documentation
   - **Relative Notation**: Use `.claude/` (relative to project root)
   
   **Common Requirements**:
   - **No Hardcoded Paths**: Reject `/opt/projects/`, `/home/user/` absolute paths
   - **Development Fallbacks**: `../scripts/` and `../docs/` for development context

### Common Problematic Paths and Type-Specific Corrections

#### User Commands (type='user')
| Problematic Path | Issue | Suggested Correction |
|------------------|-------|---------------------|
| `/opt/projects/engram-copilot-docs/...` | Hardcoded development path | `~/.claude/...` |
| `../scripts/script-name.sh` | Relative development path | `~/.claude/scripts/{topic}/script-name.sh` |
| `$HOME/.claude/...` | Variable notation | `~/.claude/...` |
| `/home/user/.claude/...` | Absolute path with user | `~/.claude/...` |
| `./docs/topic/file.md` | Relative docs path | `~/.claude/docs/topic/file.md` |

#### Project Commands (type='project')
| Problematic Path | Issue | Suggested Correction |
|------------------|-------|---------------------|
| `/opt/projects/engram-copilot-docs/...` | Hardcoded development path | `.claude/...` |
| `../scripts/script-name.sh` | Relative development path | `.claude/scripts/{topic}/script-name.sh` |
| `~/.claude/scripts/...` | User-level path in project | `.claude/scripts/{topic}/...` |
| `./docs/topic/file.md` | Relative docs path | `.claude/docs/{topic}/file.md` |
| `/opt/projects/project/{topic}/...` | Development path | `.claude/{topic}/...` |

2. **Script File Path Validation**
   - **Deployment Path Usage**: Checks scripts reference deployed paths when appropriate
   - **Error Handling**: Validates presence of `set -euo pipefail` and proper shebangs
   - **Development vs Deployed Context**: Distinguishes between development and deployment references

3. **Script File Existence and Naming Validation**
   - **Script Existence**: Verifies that script files referenced in commands actually exist in the correct scripts directory:
     - Root commands: Scripts should exist in `/root/.claude/scripts/`
     - User commands: Scripts should exist in `~/.claude/scripts/{topic}/`
     - Project commands: Scripts should exist in `.claude/scripts/{topic}/`
     - Example: A user command `execute-prompt` in topic `dev` should have scripts in `~/.claude/scripts/dev/execute-prompt_*.sh`
     - Example: A project command `deploy-service` in topic `supabase` should have scripts in `.claude/scripts/supabase/deploy-service_*.sh`
   - **Naming Convention**: Validates that script file names follow the guidelines naming convention:
     - All scripts use same pattern: `<command-name>_{operation}.*` 
     - User scripts organized by topic: `~/.claude/scripts/{topic}/execute-prompt_validator.sh`
     - Project scripts organized by topic: `.claude/scripts/{topic}/deploy-service_main.sh`
   - **Path Consistency**: Ensures script references match actual file locations in the repository structure

4. **Cross-Script Reference Validation**
   - **Script-to-Script Calls**: Validates when scripts call other scripts within the same topic
   - **Topic-Based Path Usage**: Ensures cross-script references use topic-based deployment structure
   - **Development vs Deployed Paths**: Detects hardcoded development paths in script calls
   - **Multi-Path Fallback Pattern**: Validates scripts use proper fallback patterns for deployment
   - **Reference Existence**: Verifies that scripts referenced by other scripts actually exist

   **Script Naming Validation Examples:**
   
   | Type | Command | Script Name | Valid | Reason |
   |------|---------|-------------|-------|---------|
   | **User** | `execute-prompt` (topic: dev) | `execute-prompt_validator.sh` | ✅ | Follows pattern: `<command-name>_{operation}.*` |
   | **User** | `execute-prompt` (topic: dev) | `dev_execute-prompt_validator.sh` | ❌ | No topic prefix in filename |
   | **User** | `cleanup-pr` (topic: git) | `cleanup-pr_analyzer.sh` | ✅ | Correct naming pattern |
   | **User** | `cleanup-pr` (topic: git) | `prompt_helper.sh` | ❌ | Must match command name exactly |
   | **Project** | `deploy-service` (project: supabase) | `deploy-service_main.sh` | ✅ | Follows pattern: `<command-name>_{operation}.*` |
   | **Project** | `deploy-service` (project: supabase) | `supabase_deploy-service_main.sh` | ❌ | No topic prefix in filename |
   | **Project** | `setup-worker` (project: cloudflare) | `setup-worker_validator.sh` | ✅ | Correct naming pattern |
   | **Project** | `setup-worker` (project: cloudflare) | `cloudflare_setup-worker_validator.sh` | ❌ | No topic prefix in filename |

   **Cross-Script Reference Validation Examples:**
   
   | Type | Script Call | Valid | Reason |
   |------|-------------|-------|---------|
   | **User** | `~/.claude/scripts/git/cleanup-pr_analyzer.sh` | ✅ | Topic-based deployment path |
   | **User** | `../scripts/cleanup-pr_analyzer.sh` (with fallback) | ✅ | Development fallback with proper check |
   | **User** | `../scripts/cleanup-pr_analyzer.sh` (hardcoded) | ❌ | Should use topic-based deployment first |
   | **User** | `~/.claude/scripts/cleanup-pr_analyzer.sh` | ❌ | Missing topic in path (should be `/git/`) |
   | **Project** | `.claude/scripts/supabase/deploy_main.sh` | ✅ | Topic-based project deployment path |
   | **Project** | `../scripts/deploy_main.sh` (hardcoded) | ❌ | Should use topic-based deployment first |

4. **Documentation File Existence and Reference Validation**
   - **Docs Existence**: Verifies that documentation files referenced in commands actually exist in the correct docs directory:
     - Root commands: Docs should exist in `/root/.claude/docs/`
     - User commands: Docs should exist in `~/.claude/docs/{topic}/`
     - Project commands: Docs should exist in `.claude/docs/{topic}/`
     - Example: A command referencing `claude-command-file-rules.md` should exist in `.claude/docs/agent-complex/`
     - Example: A project command referencing `edge-functions-guide.md` should exist in `.claude/docs/supabase/`
   - **Reference Format**: Validates that all documentation references use inline code format:
     - ✅ CORRECT: `.claude/docs/agent-complex/claude-command-file-rules.md` (for agent-complex docs)
     - ❌ WRONG: [claude-command-file-rules.md](.claude/docs/agent-complex/claude-command-file-rules.md)
     - All docs references MUST use backticks for inline code, NOT hyperlinks
   - **Path Format**: Ensures documentation references use deployed paths:
     - User docs: `~/.claude/docs/{topic}/filename.md`
     - Project docs: `.claude/docs/{topic}/filename.md`
   - **Common Documentation Files**: Validates existence of commonly referenced docs:
     - `claude-command-file-rules.md` - Command file guidelines
     - `claude-agent-file-rules.md` - Agent file guidelines
     - `claude-meta-command-file-rules.md` - Meta-command guidelines
     - Topic-specific documentation files

   **Documentation Reference Validation Examples:**
   
   | Type | Reference Format | Valid | Reason |
   |------|-----------------|-------|---------|
   | **Project** | \`.claude/docs/agent-complex/guide.md\` | ✅ | Inline code with deployed path |
   | **Project** | [guide.md](.claude/docs/agent-complex/guide.md) | ❌ | Hyperlink format not allowed |
   | **User** | \`../docs/guide.md\` | ❌ | Development path, should use deployed |
   | **User** | See guide.md for details | ❌ | Missing backticks and full path |
   | **Project** | \`.claude/docs/supabase/api.md\` | ✅ | Inline code with relative deployed path |
   | **Project** | [API Guide](.claude/docs/supabase/api.md) | ❌ | Hyperlink format not allowed |
   | **Project** | \`/opt/projects/project/supabase/docs/api.md\` | ❌ | Development path in deployed context |

5. **Agent-Complex Specific Patterns**
   - **Agent File Requirements**: Validates Critical Context sections and Available Commands tables
   - **Command File Headers**: Ensures proper `# Args:` format with backticks around arguments
   - **Documentation Loading Instructions**: Checks for explicit Read tool usage guidelines

### Analysis Process
1. **Git-Based File Discovery**: Identifies updated files in the current working directory using git status
2. **Contextual Logging**: Uses the provided description to add context to the analysis output
3. **Multi-Layer Validation**: Applies general path validation plus agent-complex specific patterns
4. **Script File Validation**: Checks that referenced scripts exist and follow naming conventions
5. **Cross-Script Reference Validation**: Analyzes scripts that call other scripts for proper deployment paths
6. **Documentation Validation**: Verifies docs exist and all references use inline code format (not hyperlinks)
7. **Detailed Issue Reporting**: Provides specific line numbers, issues, and actionable suggestions
8. **Comprehensive Summary**: Generates overview with fix recommendations and documentation references

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from the agent-complex documentation regarding external script usage.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/check-paths` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**

**🔴 MANDATORY RULE: If your implementation exceeds 50 lines of bash code, you MUST use external scripts** 🔴

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

#!/bin/bash
set -euo pipefail

# Parse arguments (keep minimal validation inline)
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required type argument"
    echo "Usage: /agent-complex:check-paths <type> [description]"
    echo "  type: 'root', 'user', or 'project'"
    echo "  description: Optional context for analysis"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-working directory changes}"

# Validate type argument
if [ "$TYPE" != "root" ] && [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'root', 'user', or 'project'"
    exit 1
fi

# Display analysis context
echo "🔍 Validating paths for DEPLOYED context (type: $TYPE)..."
echo "📋 Context: $DESCRIPTION"
echo "🎯 Goal: Ensure commands will work when deployed to production"
echo "📂 Path Type: $(if [ "$TYPE" = "root" ]; then echo "Root-level (.claude/)"; elif [ "$TYPE" = "user" ]; then echo "User-level (.claude/)"; else echo "Project-level (.claude/)"; fi)"

# 🔴 DECISION POINT: Complex logic must use external scripts
# If your implementation is simple (<50 lines), implement directly here
# If complex (>50 lines, loops, functions, workflows), use external scripts

# This command requires external script due to complex git operations and file analysis
# Following the >50 lines rule from claude-command-file-rules.md
# Define script paths based on type
if [ "$TYPE" = "user" ]; then
    SCRIPT_PATHS=(
        "../scripts/check-paths_analyzer.sh"
        ".claude/scripts/agent-complex/check-paths_analyzer.sh"
    )
else
    SCRIPT_PATHS=(
        "../scripts/check-paths_analyzer.sh"
        ".claude/scripts/agent-complex/check-paths_analyzer.sh"
    )
fi

SCRIPT_PATH=""
for path in "${SCRIPT_PATHS[@]}"; do
    if [[ -f "$path" ]]; then
        SCRIPT_PATH="$path"
        break
    fi
done

if [[ -n "$SCRIPT_PATH" ]]; then
    echo "🚀 Using deployment validator script: $SCRIPT_PATH"
    "$SCRIPT_PATH" "$TYPE" "$DESCRIPTION"
else
    echo "⚠️ Deployment validator script not found. Using basic fallback..."
    echo "📋 Would validate files for deployment readiness"
    echo "📂 Type: $TYPE"
    echo "📝 Context: $DESCRIPTION"
    echo "📝 Script should be created at: ../scripts/check-paths_analyzer.sh"
    echo "⚠️ CRITICAL: Cannot validate deployment readiness without analyzer script"
    exit 1
fi

# Note: Implementation moved to active code above
```

### Script Architecture (If Using External Scripts)

This command requires external scripts due to complex git operations and file analysis:

1. **check-paths_analyzer.sh**: Primary implementation
   - Git file discovery (working directory changes via git status)
   - Contextual logging using provided description
   - Path pattern analysis for command files and scripts
   - Documentation reference validation
   - Issue reporting and fix suggestions

**Script Patterns:**
- User commands: `~/.claude/scripts/agent-complex/check-paths_*.sh`
- Project commands: `.claude/scripts/agent-complex/check-paths_*.sh`
- Development location: `../scripts/check-paths_*.sh`

## Performance Considerations

- **Script Usage**: Use external scripts for operations >50 lines or complex workflows
- **Parallel Execution**: Where applicable, use parallel processing for independent operations
- **Validation Efficiency**: Front-load validation to fail fast on invalid inputs
- **Resource Management**: Clean up temporary resources and handle interruptions gracefully

## Requirements

- Git repository (command must be run within a git repository)
- Access to agent-complex documentation for path validation rules
- Read access to command files and scripts in the repository
- Basic shell utilities (grep, find, awk) for path analysis

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

- `/agent-complex:update-agent` - Create or update agent files with proper structure
- `/agent-complex:update-command` - Create or update command files following guidelines
- `/agent-complex:update-doc` - Create or update documentation for agent consumption

## Related Documentation

- `.claude/docs/agent-complex/claude-command-file-rules.md` - Command file creation guidelines (MANDATORY READING)
- `.claude/docs/agent-complex/agent-complex-rules.md` - Core principles and patterns for building agent complexes
- `.claude/docs/agent-complex/claude-agent-file-rules.md` - Essential patterns for agent development

## Notes

- **Script Rule Enforcement**: Commands >50 lines MUST use external scripts per guidelines
- **Type-Aware Validation**: Automatically detects user vs project commands for appropriate validation rules
- **Development Focus**: Validates files in development context for deployment readiness
- **Script Naming**: All scripts use `<command-name>_{operation}.*` pattern, organized by topic directories
- **Documentation Standards**: All docs references must use inline code format (backticks), never hyperlinks
- **Reference Validation**: Ensures documentation files exist and are referenced with correct deployed paths

## Version History

- **v1.8.0** - Cross-script reference validation enhancement
  - Added comprehensive cross-script reference validation for scripts calling other scripts
  - Validates topic-based deployment paths in cross-script calls
  - Detects hardcoded development paths (../scripts/) that should use deployment structure
  - Ensures scripts use multi-path fallback patterns for deployment readiness
  - Verifies existence of scripts referenced by other scripts
  - Added analysis of variable-based script paths for topic-based structure
  - Enhanced validation process to include cross-script reference analysis step
  - Added examples of correct vs incorrect cross-script reference patterns

- **v1.7.0** - Documentation validation enhancement
  - Added comprehensive documentation file existence validation
  - Added validation for documentation reference format (must use inline code, not hyperlinks)
  - Checks that all docs references use backticks instead of markdown hyperlinks
  - Validates documentation paths match deployment structure
  - Enhanced analysis process to include documentation validation step
  - Added examples of correct vs incorrect documentation references
  
- **v1.6.0** - Topic-based script deployment strategy
  - Updated all script naming to consistent pattern: `<command-name>_{operation}.*`
  - User scripts deployed to: `~/.claude/scripts/{topic}/`
  - Project scripts deployed to: `.claude/scripts/{topic}/`
  - Root scripts deployed to: `/root/.claude/scripts/`
  - Removed topic prefix from filenames, using directory organization instead
- **v1.5.0** - Enhanced script naming convention for project scripts
  - Previous version with topic prefix in filenames
- **v1.4.0** - Script validation enhancement
  - Added validation for script file existence in development repositories
  - Added validation for script file naming conventions (`<command-name>_<operation>.sh`)
  - Enhanced analysis process to check script references against actual files
  - Updated documentation to reflect new script validation capabilities

- **v1.2.0** - Deployment context emphasis
  - Clarified that command validates for DEPLOYED context, not development
  - Updated all documentation to emphasize deployment readiness
  - Changed messages from "path accuracy" to "deployment validation"
  - Added explicit deployment context requirements section

- **v1.1.1** - Path correction update
  - Fixed $HOME/.claude paths to use tilde notation (`~/.claude`)
  - Enhanced validation to catch both $HOME and tilde path formats
  - Updated script suggestions to use proper destination path format

- **v1.1.0** - Parameter refactor
  - Changed session-type parameter to description for better UX
  - Updated script to handle description-based context
  - Improved documentation with descriptive examples

- **v1.0.0** - Initial version
  - Core functionality implemented
  - Basic argument validation
  - External script pattern support