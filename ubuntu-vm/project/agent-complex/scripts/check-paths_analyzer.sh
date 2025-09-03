#!/bin/bash
# check-paths_analyzer.sh - Type-aware deployment context validator for agent-complex commands
# Version: 1.8.0
# Purpose: Validates that commands and scripts are ready for DEPLOYED context with type-specific path fixes, script validation, and cross-script reference analysis

set -euo pipefail

# Configuration
readonly SCRIPT_NAME="check-paths_analyzer.sh"
readonly VERSION="1.8.0"

# Color codes for output formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Global counters
ISSUES_FOUND=0
FILES_ANALYZED=0

# Usage information
usage() {
    echo "Usage: $0 <type> [description]"
    echo "Type: 'user' or 'project' - determines which path patterns to apply"
    echo "Description: Optional context for the analysis (e.g., 'working directory changes')"
    echo "Note: Always analyzes current working directory changes via git status"
}

# Error handling
error_exit() {
    echo -e "${RED}❌ ERROR: $1${NC}" >&2
    exit 1
}

# Info messages
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Warning messages
warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Success messages
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Issue reporting
report_issue() {
    local file="$1"
    local line_num="$2"
    local issue="$3"
    local suggestion="$4"
    
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    
    echo -e "${RED}🔍 PATH ISSUE FOUND${NC}"
    echo -e "  📁 File: ${BLUE}$file${NC}"
    if [[ "$line_num" != "0" ]]; then
        echo -e "  📍 Line: $line_num"
    fi
    echo -e "  ❗ Issue: $issue"
    echo -e "  💡 Suggestion: ${GREEN}$suggestion${NC}"
    echo ""
}

# Get files from current working directory changes
get_target_files() {
    local type="$1"
    local description="$2"
    local files=()
    
    info "Type: $type ($(if [ "$type" = "user" ]; then echo "User-level paths"; else echo "Project-level paths"; fi))"
    info "Context: $description"
    info "Validating deployment readiness (checking git status for modified files)"
    
    # Always get modified and untracked files from working directory
    mapfile -t files < <(git status --porcelain | grep -E '\.(md|sh)$' | awk '{print $2}' 2>/dev/null || true)
    
    # Filter and output files (skip the info lines that got mixed in)
    for file in "${files[@]}"; do
        if [[ -f "$file" ]] && [[ "$file" =~ \.(md|sh)$ ]]; then
            echo "$file"
        fi
    done
}

# Validate command file paths
validate_command_file() {
    local file="$1"
    local type="$2"
    local line_num=0
    
    FILES_ANALYZED=$((FILES_ANALYZED + 1))
    info "Validating command file for deployment ($type): $file"
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check that deployed paths use correct PRIMARY path based on type
        if [[ "$line" =~ SCRIPT_PATHS.*= ]]; then
            if [[ "$file" =~ commands/.*\.md$ ]]; then
                if [[ "$type" = "user" ]] && [[ ! "$line" =~ ~/\.claude/scripts/ ]]; then
                    report_issue "$file" "$line_num" \
                        "USER COMMAND: Script paths array missing ~/.claude/scripts/ as primary path" \
                        "Always list ~/.claude/scripts/ FIRST in SCRIPT_PATHS array for user commands"
                elif [[ "$type" = "project" ]] && [[ ! "$line" =~ \.claude/scripts/ ]]; then
                    report_issue "$file" "$line_num" \
                        "PROJECT COMMAND: Script paths array missing .claude/scripts/{topic}/ as primary path" \
                        "Always list .claude/scripts/{topic}/ FIRST in SCRIPT_PATHS array for project commands"
                fi
            fi
        fi
        
        # Check for $HOME/.claude instead of ~/.claude (deployment issue)
        if [[ "$line" =~ \$HOME/\.claude ]]; then
            report_issue "$file" "$line_num" \
                "DEPLOYED CONTEXT: Using \$HOME/.claude instead of ~/.claude" \
                "Use tilde notation ~/.claude/ for portability in deployed context"
        fi
        
        # Check for incorrect documentation references based on type
        if [[ "$line" =~ ubuntu-vm/user/.*docs/ ]] || [[ "$line" =~ ubuntu-vm/project/.*docs/ ]]; then
            if [[ "$type" = "user" ]]; then
                report_issue "$file" "$line_num" \
                    "USER COMMAND: References development documentation path" \
                    "Must use '~/.claude/docs/{topic}/' for deployed user documentation paths"
            else
                report_issue "$file" "$line_num" \
                    "PROJECT COMMAND: References development documentation path" \
                    "Must use '.claude/docs/{topic}/' for deployed project documentation paths"
            fi
        fi
        
        # Check for hardcoded absolute paths that will break in deployment
        if [[ "$line" =~ /opt/projects/ ]]; then
            if [[ "$type" = "user" ]]; then
                report_issue "$file" "$line_num" \
                    "USER COMMAND: Hardcoded /opt/projects/ path will FAIL when deployed" \
                    "Must use ~/.claude/ for deployed user paths, ../scripts/ only as fallback"
            else
                report_issue "$file" "$line_num" \
                    "PROJECT COMMAND: Hardcoded /opt/projects/ path will FAIL when deployed" \
                    "Must use .claude/ for deployed project paths, ../scripts/ only as fallback"
            fi
        fi
        
        # Check for missing script path validation patterns
        if [[ "$line" =~ SCRIPT_PATH.*= ]] && ! grep -q "for path in.*SCRIPT_PATHS" "$file"; then
            report_issue "$file" "$line_num" \
                "Script path assignment without proper fallback pattern" \
                "Use SCRIPT_PATHS array with multiple path options for robustness"
        fi
        
        # Check for proper Claude command execution context
        if [[ "$file" =~ \.md$ ]] && [[ "$line" =~ ^#!/bin/bash ]] && ! grep -q "CLAUDE EXECUTION CONTEXT" "$file"; then
            report_issue "$file" "$line_num" \
                "Bash execution block missing Claude execution context notice" \
                "Add '# 🚨 CLAUDE EXECUTION CONTEXT' comment to clarify execution environment"
        fi
        
    done < "$file"
}

# Validate script file paths
validate_script_file() {
    local file="$1"
    local type="$2"
    local line_num=0
    
    FILES_ANALYZED=$((FILES_ANALYZED + 1))
    info "Analyzing script file ($type): $file"
    
    # Skip validation for the check-paths_analyzer.sh script itself to avoid false positives
    if [[ "$file" =~ check-paths_analyzer\.sh$ ]]; then
        info "Skipping self-validation for check-paths analyzer script"
        return 0
    fi
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Check for source paths in scripts (should use deployed paths)
        # Skip validation messages, comments, echo statements, and documentation references
        if [[ "$line" =~ ubuntu-vm/user/ ]] || [[ "$line" =~ ubuntu-vm/root/ ]]; then
            # Skip various patterns that legitimately reference source paths for documentation/validation
            if [[ ! "$line" =~ ^[[:space:]]*# ]] && 
               [[ ! "$line" =~ echo.*ubuntu-vm ]] && 
               [[ ! "$line" =~ "📚 REFERENCE" ]] &&
               [[ ! "$line" =~ "•.*ubuntu-vm" ]] &&
               [[ ! "$line" =~ report_issue.*ubuntu-vm ]] &&
               [[ ! "$line" =~ "Command file.*ubuntu-vm" ]] &&
               [[ ! "$line" =~ "Agent file.*ubuntu-vm" ]]; then
                report_issue "$file" "$line_num" \
                    "Script references source development path" \
                    "Scripts should reference deployed paths (~/.claude/ or .claude/) when deployed"
            fi
        fi
        
        # Check for proper script header patterns
        if [[ $line_num -eq 1 ]] && [[ "$line" != "#!/bin/bash" ]]; then
            report_issue "$file" "1" \
                "Script missing proper shebang" \
                "Start script with #!/bin/bash"
        fi
        
        # Check for missing error handling
        if [[ $line_num -le 10 ]] && ! grep -q "set -euo pipefail" "$file"; then
            if [[ $line_num -eq 10 ]]; then  # Only report once at line 10
                report_issue "$file" "$line_num" \
                    "Script missing error handling setup" \
                    "Add 'set -euo pipefail' near the top of script"
            fi
        fi
        
    done < "$file"
}

# Validate script file references and naming conventions
validate_script_references() {
    local file="$1"
    local type="$2"
    
    # Only validate command files for script references
    if [[ ! "$file" =~ commands/.*\.md$ ]]; then
        return 0
    fi
    
    info "Validating script references in command file: $file"
    
    # Extract the command name from the file path
    local command_name
    command_name=$(basename "$file" .md)
    
    # Determine the topic and scripts directory based on the file path and type
    local topic_dir scripts_dir
    if [[ "$type" = "user" ]]; then
        # For user commands: ubuntu-vm/user/{topic}/commands/{command}.md
        if [[ "$file" =~ ubuntu-vm/user/([^/]+)/commands/ ]]; then
            topic_dir="${BASH_REMATCH[1]}"
            scripts_dir="ubuntu-vm/user/$topic_dir/scripts"
        else
            warn "Unable to determine topic directory for user command: $file"
            return 0
        fi
    else
        # For project commands: ubuntu-vm/project/{topic}/commands/{command}.md
        if [[ "$file" =~ ubuntu-vm/project/([^/]+)/commands/ ]]; then
            topic_dir="${BASH_REMATCH[1]}"
            scripts_dir="ubuntu-vm/project/$topic_dir/scripts"
        else
            warn "Unable to determine topic directory for project command: $file"
            return 0
        fi
    fi
    
    # Find script references in the command file
    local line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Look for script path references (various patterns)
        if [[ "$line" =~ \$\{?SCRIPT_PATH\}?.*=.*\.sh ]] || 
           [[ "$line" =~ \.\./scripts/.*\.sh ]] || 
           [[ "$line" =~ ~/\.claude/scripts/.*\.sh ]] || 
           [[ "$line" =~ \.claude/scripts/.*\.sh ]]; then
            
            # Extract the script filename from the line
            local script_filename
            if [[ "$line" =~ ([a-zA-Z0-9_-]+\.sh) ]]; then
                script_filename="${BASH_REMATCH[1]}"
                
                # Check if the script file exists in the development scripts directory
                local script_path="$scripts_dir/$script_filename"
                if [[ ! -f "$script_path" ]]; then
                    report_issue "$file" "$line_num" \
                        "SCRIPT NOT FOUND: Referenced script '$script_filename' does not exist" \
                        "Create the script at: $script_path"
                fi
                
                # Validate naming convention based on type
                # User scripts: <command-name>_<operation>.sh
                # Project scripts: <topic>_<command-name>_<operation>.sh
                if [[ "$type" = "project" ]]; then
                    # Project scripts should have topic prefix
                    if [[ ! "$script_filename" =~ ^${topic_dir}_${command_name}_[a-zA-Z0-9-]+\.sh$ ]]; then
                        report_issue "$file" "$line_num" \
                            "SCRIPT NAMING: Script '$script_filename' does not follow project naming convention" \
                            "Use naming pattern: ${topic_dir}_${command_name}_<operation>.sh (e.g., ${topic_dir}_${command_name}_main.sh, ${topic_dir}_${command_name}_helper.sh)"
                    fi
                else
                    # User scripts don't have topic prefix
                    if [[ ! "$script_filename" =~ ^${command_name}_[a-zA-Z0-9-]+\.sh$ ]]; then
                        report_issue "$file" "$line_num" \
                            "SCRIPT NAMING: Script '$script_filename' does not follow user naming convention" \
                            "Use naming pattern: ${command_name}_<operation>.sh (e.g., ${command_name}_analyzer.sh, ${command_name}_helper.sh)"
                    fi
                fi
            fi
        fi
        
        # Also check for hardcoded script names in SCRIPT_PATHS arrays
        if [[ "$line" =~ SCRIPT_PATHS.*= ]] || [[ "$line" =~ \".*\.sh\" ]]; then
            # Extract script filenames from arrays or quoted strings
            local script_matches
            script_matches=$(echo "$line" | grep -oE '[a-zA-Z0-9_-]+\.sh' || true)
            
            if [[ -n "$script_matches" ]]; then
                while IFS= read -r script_match; do
                    if [[ -n "$script_match" ]]; then
                        local script_path="$scripts_dir/$script_match"
                        if [[ ! -f "$script_path" ]]; then
                            report_issue "$file" "$line_num" \
                                "SCRIPT NOT FOUND: Referenced script '$script_match' does not exist" \
                                "Create the script at: $script_path"
                        fi
                        
                        # Validate naming convention based on type
                        # User scripts: <command-name>_<operation>.sh
                        # Project scripts: <topic>_<command-name>_<operation>.sh
                        if [[ "$type" = "project" ]]; then
                            # Project scripts should have topic prefix
                            if [[ ! "$script_match" =~ ^${topic_dir}_${command_name}_[a-zA-Z0-9-]+\.sh$ ]]; then
                                report_issue "$file" "$line_num" \
                                    "SCRIPT NAMING: Script '$script_match' does not follow project naming convention" \
                                    "Use naming pattern: ${topic_dir}_${command_name}_<operation>.sh (e.g., ${topic_dir}_${command_name}_main.sh, ${topic_dir}_${command_name}_validator.sh)"
                            fi
                        else
                            # User scripts don't have topic prefix  
                            if [[ ! "$script_match" =~ ^${command_name}_[a-zA-Z0-9-]+\.sh$ ]]; then
                                report_issue "$file" "$line_num" \
                                    "SCRIPT NAMING: Script '$script_match' does not follow user naming convention" \
                                    "Use naming pattern: ${command_name}_<operation>.sh (e.g., ${command_name}_main.sh, ${command_name}_validator.sh)"
                            fi
                        fi
                    fi
                done <<< "$script_matches"
            fi
        fi
        
    done < "$file"
}

# Validate cross-script references within script files
validate_cross_script_references() {
    local file="$1"
    local type="$2"
    
    # Only validate script files for cross-script references
    if [[ ! "$file" =~ scripts/.*\.sh$ ]]; then
        return 0
    fi
    
    info "Validating cross-script references in script file: $file"
    
    # Determine the topic and scripts directory based on the file path and type
    local topic_dir scripts_dir
    if [[ "$type" = "user" ]]; then
        # For user scripts: ubuntu-vm/user/{topic}/scripts/{script}.sh
        if [[ "$file" =~ ubuntu-vm/user/([^/]+)/scripts/ ]]; then
            topic_dir="${BASH_REMATCH[1]}"
            scripts_dir="ubuntu-vm/user/$topic_dir/scripts"
        else
            warn "Unable to determine topic directory for user script: $file"
            return 0
        fi
    else
        # For project scripts: ubuntu-vm/project/{topic}/scripts/{script}.sh
        if [[ "$file" =~ ubuntu-vm/project/([^/]+)/scripts/ ]]; then
            topic_dir="${BASH_REMATCH[1]}"
            scripts_dir="ubuntu-vm/project/$topic_dir/scripts"
        else
            warn "Unable to determine topic directory for project script: $file"
            return 0
        fi
    fi
    
    # Find cross-script references in the script file
    local line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Look for script execution patterns that reference other scripts
        # Pattern 1: ../scripts/other-script.sh (relative development path)
        if [[ "$line" =~ \.\./scripts/([a-zA-Z0-9_-]+\.sh) ]]; then
            local referenced_script="${BASH_REMATCH[1]}"
            local script_path="$scripts_dir/$referenced_script"
            
            # Check if this is a hardcoded relative path (should use topic-based deployment)
            if [[ "$type" = "user" ]]; then
                report_issue "$file" "$line_num" \
                    "CROSS-SCRIPT REFERENCE: Script '$referenced_script' uses development path '../scripts/'" \
                    "Use topic-based deployment with fallback: Check for '~/.claude/scripts/$topic_dir/$referenced_script' first, then '../scripts/$referenced_script'"
            else
                report_issue "$file" "$line_num" \
                    "CROSS-SCRIPT REFERENCE: Script '$referenced_script' uses development path '../scripts/'" \
                    "Use topic-based deployment with fallback: Check for '.claude/scripts/$topic_dir/$referenced_script' first, then '../scripts/$referenced_script'"
            fi
            
            # Verify the referenced script exists
            if [[ ! -f "$script_path" ]]; then
                report_issue "$file" "$line_num" \
                    "CROSS-SCRIPT REFERENCE: Referenced script '$referenced_script' does not exist" \
                    "Create the script at: $script_path"
            fi
        fi
        
        # Pattern 2: Direct script execution without path validation (e.g., "./script.sh" or "script.sh")
        if [[ "$line" =~ (\./|\"|\'|^)[[:space:]]*([a-zA-Z0-9_-]+\.sh) ]] && [[ ! "$line" =~ ^[[:space:]]*# ]]; then
            local referenced_script="${BASH_REMATCH[2]}"
            
            # Skip if it's a script in the current directory or a variable reference
            if [[ ! "$line" =~ \$\{ ]] && [[ ! "$line" =~ \$\( ]] && [[ "$referenced_script" != "$(basename "$file")" ]]; then
                local script_path="$scripts_dir/$referenced_script"
                
                # Only report if the script exists in our scripts directory (indicating it's a cross-script reference)
                if [[ -f "$script_path" ]]; then
                    report_issue "$file" "$line_num" \
                        "CROSS-SCRIPT REFERENCE: Direct script call '$referenced_script' should use deployment-aware path" \
                        "Use multi-path fallback pattern to check deployed location first, then development fallback"
                fi
            fi
        fi
        
        # Pattern 3: Variable-based script paths that might need topic-based updates
        if [[ "$line" =~ script_path=.*\.sh ]] || [[ "$line" =~ SCRIPT.*=.*\.sh ]]; then
            # Check if this is using old non-topic-based patterns
            if [[ "$line" =~ ~/\.claude/scripts/[^/]+\.sh ]] && [[ "$type" = "user" ]]; then
                report_issue "$file" "$line_num" \
                    "CROSS-SCRIPT REFERENCE: Script path should use topic-based structure" \
                    "Update to use '~/.claude/scripts/$topic_dir/script-name.sh' instead of '~/.claude/scripts/script-name.sh'"
            elif [[ "$line" =~ \.claude/scripts/[^/]+\.sh ]] && [[ "$type" = "project" ]]; then
                report_issue "$file" "$line_num" \
                    "CROSS-SCRIPT REFERENCE: Script path should use topic-based structure" \
                    "Update to use '.claude/scripts/$topic_dir/script-name.sh' instead of '.claude/scripts/script-name.sh'"
            fi
        fi
        
    done < "$file"
}

# Analyze agent-complex specific patterns
validate_agent_complex_patterns() {
    local file="$1"
    local type="$2"
    
    if [[ "$file" =~ agent-complex/ ]]; then
        info "Checking agent-complex specific patterns in: $file"
        
        # Check for proper Critical Context sections in agent files
        if [[ "$file" =~ agents/.*\.md$ ]]; then
            if ! grep -q "## Critical Context" "$file"; then
                report_issue "$file" "0" \
                    "Agent file missing Critical Context section" \
                    "Add '## Critical Context' section with required documentation loading instructions"
            fi
            
            if ! grep -q "Use the Read tool to load ALL critical documents" "$file"; then
                report_issue "$file" "0" \
                    "Agent file missing explicit document loading instruction" \
                    "Include 'Use the Read tool to load ALL critical documents before beginning any task'"
            fi
        fi
        
        # Check for Available Commands tables in agent files
        if [[ "$file" =~ agents/.*\.md$ ]]; then
            if ! grep -q "Available Claude Slash Commands" "$file"; then
                report_issue "$file" "0" \
                    "Agent file missing Available Commands table" \
                    "Add '## Available Claude Slash Commands' table with command inventory"
            fi
        fi
        
        # Check for proper command file headers
        if [[ "$file" =~ commands/.*\.md$ ]]; then
            local first_line
            first_line=$(head -n 1 "$file")
            if [[ ! "$first_line" =~ ^#\ Args: ]]; then
                report_issue "$file" "1" \
                    "Command file missing proper Args header format" \
                    "Start with '# Args: \`<arg1>\` \`<arg2>\`. v0.1.0. Description of what command does.'"
            fi
            
            if [[ "$first_line" =~ \<.*\> ]] && [[ ! "$first_line" =~ \`.*\` ]]; then
                report_issue "$file" "1" \
                    "Command file arguments not wrapped in backticks" \
                    "Wrap arguments in backticks: \`<arg>\` instead of <arg>"
            fi
        fi
    fi
}

# Generate summary report
generate_summary() {
    local type="$1"
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "    TYPE-AWARE DEPLOYMENT READINESS VALIDATION"
    echo "═══════════════════════════════════════════════════"
    echo "📂 Type: $type ($(if [ "$type" = "user" ]; then echo "User-level"; else echo "Project-level"; fi))"
    echo "📊 Files analyzed: $FILES_ANALYZED"
    echo "🔍 Issues found: $ISSUES_FOUND"
    echo ""
    
    if [[ $ISSUES_FOUND -eq 0 ]]; then
        success "All files are READY FOR DEPLOYMENT! 🎉"
        if [[ "$type" = "user" ]]; then
            echo "✅ Commands will work correctly when deployed to ~/.claude/"
        else
            echo "✅ Commands will work correctly when deployed to project .claude/"
        fi
    else
        warn "Found $ISSUES_FOUND deployment issues that MUST be fixed"
        echo ""
        echo "🚨 DEPLOYMENT REQUIREMENTS ($type):"
        if [[ "$type" = "user" ]]; then
            echo "   • PRIMARY path: ~/.claude/scripts/ (not ../scripts/)"
            echo "   • Use tilde notation: ~/.claude/ (not \$HOME/.claude/)"
            echo "   • Documentation: ~/.claude/docs/{topic}/ (not development paths)"
        else
            echo "   • PRIMARY path: .claude/scripts/{topic}/ (not ../scripts/)"
            echo "   • Use relative notation: .claude/ (project-relative)"
            echo "   • Documentation: .claude/docs/{topic}/ (not development paths)"
        fi
        echo "   • NO hardcoded paths: /opt/projects/ will FAIL in production"
        echo "   • Script files must exist: Referenced scripts must be in {topic}/scripts/"
        echo "   • Script naming: Use <command-name>_<operation>.sh pattern"
        echo ""
        echo "📚 DEPLOYMENT GUIDELINES:"
        echo "   • .claude/docs/agent-complex/claude-command-file-rules.md"
        echo "   • .claude/docs/agent-complex/agent-complex-rules.md"
    fi
}

# Main execution
main() {
    if [[ $# -lt 1 ]]; then
        echo "❌ Error: Missing required type argument"
        usage
        exit 1
    fi
    
    local type="$1"
    local description="${2:-working directory changes}"
    
    # Validate type argument
    if [[ "$type" != "user" ]] && [[ "$type" != "project" ]]; then
        echo "❌ Error: Invalid type '$type'. Must be 'user' or 'project'"
        usage
        exit 1
    fi
    
    info "🔍 Starting TYPE-AWARE deployment readiness validation..."
    info "📂 Type: $type ($(if [ "$type" = "user" ]; then echo "User-level paths"; else echo "Project-level paths"; fi))"
    info "📋 Description: $description"
    info "🏠 Working directory: $(pwd)"
    info "🎯 Target: Validate for deployment context"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error_exit "Not in a git repository. This command requires git context."
    fi
    
    # Get target files
    local files
    mapfile -t files < <(get_target_files "$type" "$description")
    
    if [[ ${#files[@]} -eq 0 ]]; then
        info "No .md or .sh files found in working directory changes"
        success "Nothing to analyze! 🎉"
        exit 0
    fi
    
    echo ""
    info "Found ${#files[@]} files to analyze:"
    for file in "${files[@]}"; do
        echo "  📄 $file"
    done
    echo ""
    
    # Analyze each file
    for file in "${files[@]}"; do
        if [[ ! -f "$file" ]]; then
            warn "File not found (may have been deleted): $file"
            continue
        fi
        
        # Determine file type and validate accordingly
        if [[ "$file" =~ \.md$ ]]; then
            validate_command_file "$file" "$type"
        elif [[ "$file" =~ \.sh$ ]]; then
            validate_script_file "$file" "$type"
        fi
        
        # Apply script reference validation
        validate_script_references "$file" "$type"
        
        # Apply cross-script reference validation
        validate_cross_script_references "$file" "$type"
        
        # Apply agent-complex specific validation
        validate_agent_complex_patterns "$file" "$type"
    done
    
    # Generate final report
    generate_summary "$type"
    
    # Exit with error code if issues found
    if [[ $ISSUES_FOUND -gt 0 ]]; then
        exit 1
    fi
}

# Script execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi