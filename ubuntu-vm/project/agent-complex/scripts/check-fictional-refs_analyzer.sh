#!/bin/bash
set -euo pipefail

# check-fictional-refs_analyzer.sh - Validates entity references point to real, existing entities
# Part of the agent-complex QA system
# Version: 1.0.0

# Parse arguments
TYPE="${1:-all}"
DESCRIPTION="${2:-entity reference validation}"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters for summary
TOTAL_FILES=0
TOTAL_REFS=0
FICTIONAL_REFS=0
MISSING_AGENTS=0
MISSING_COMMANDS=0
MISSING_SCRIPTS=0
MISSING_DOCS=0
FORMAT_VIOLATIONS=0

# Arrays to store issues
declare -a ISSUES

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "/opt/projects/engram-copilot-docs")

# Function to determine files to scan based on type
get_files_to_scan() {
    local type="$1"
    case "$type" in
        all)
            find "$REPO_ROOT/ubuntu-vm" -type f -name "*.md" 2>/dev/null || true
            ;;
        root)
            find "$REPO_ROOT/ubuntu-vm/root" -type f -name "*.md" 2>/dev/null || true
            ;;
        user)
            find "$REPO_ROOT/ubuntu-vm/user" -type f -name "*.md" 2>/dev/null || true
            ;;
        project)
            find "$REPO_ROOT/ubuntu-vm/project" -type f -name "*.md" 2>/dev/null || true
            ;;
        *)
            echo "❌ Invalid type: $type" >&2
            exit 1
            ;;
    esac
}

# Function to reverse map deployment path to source path
reverse_map_path() {
    local ref_path="$1"
    local entity_type="$2"
    local source_path=""
    
    # Handle user-level deployment paths
    if [[ "$ref_path" =~ ^~/.claude/(commands|agents|docs|scripts)/([^/]+)/(.+)$ ]]; then
        local resource="${BASH_REMATCH[1]}"
        local topic="${BASH_REMATCH[2]}"
        local filename="${BASH_REMATCH[3]}"
        source_path="$REPO_ROOT/ubuntu-vm/user/$topic/$resource/$filename"
    # Handle project-level deployment paths
    elif [[ "$ref_path" =~ ^\.claude/(commands|agents|docs|scripts)/([^/]+)/(.+)$ ]]; then
        local resource="${BASH_REMATCH[1]}"
        local topic="${BASH_REMATCH[2]}"
        local filename="${BASH_REMATCH[3]}"
        source_path="$REPO_ROOT/ubuntu-vm/project/$topic/$resource/$filename"
    # Handle root-level deployment paths
    elif [[ "$ref_path" =~ ^/root/.claude/(commands|scripts|docs)/(.+)$ ]]; then
        local resource="${BASH_REMATCH[1]}"
        local filename="${BASH_REMATCH[2]}"
        source_path="$REPO_ROOT/ubuntu-vm/root/$resource/$filename"
    # Handle development paths
    elif [[ "$ref_path" =~ ^\.\./scripts/(.+)$ ]]; then
        local filename="${BASH_REMATCH[1]}"
        # Need to determine context from current file location
        source_path=""  # Will be resolved contextually
    # Handle direct source paths
    elif [[ "$ref_path" =~ ^ubuntu-vm/(.+)$ ]]; then
        source_path="$REPO_ROOT/$ref_path"
    fi
    
    echo "$source_path"
}

# Function to check if agent exists
check_agent_exists() {
    local agent_ref="$1"
    local file="$2"
    local line_num="$3"
    
    # Parse agent reference patterns
    local topic=""
    local agent_name=""
    
    # Pattern: @agent-{topic}:{agent-name}
    if [[ "$agent_ref" =~ @agent-([^:]+):(.+) ]]; then
        topic="${BASH_REMATCH[1]}"
        agent_name="${BASH_REMATCH[2]}"
    # Pattern: {topic}:{agent-name} (without @agent- prefix)
    elif [[ "$agent_ref" =~ ^([^/@]+):([^/]+)$ ]]; then
        topic="${BASH_REMATCH[1]}"
        agent_name="${BASH_REMATCH[2]}"
    else
        return 0  # Not a valid agent reference pattern
    fi
    
    # Check possible agent locations
    local user_agent="$REPO_ROOT/ubuntu-vm/user/$topic/agents/$agent_name.md"
    local project_agent="$REPO_ROOT/ubuntu-vm/project/$topic/agents/$agent_name.md"
    local flat_user_agent="$REPO_ROOT/ubuntu-vm/user/agents/$agent_name.md"
    local flat_project_agent="$REPO_ROOT/ubuntu-vm/project/agents/$agent_name.md"
    
    if [[ ! -f "$user_agent" && ! -f "$project_agent" && ! -f "$flat_user_agent" && ! -f "$flat_project_agent" ]]; then
        ((FICTIONAL_REFS++))
        ((MISSING_AGENTS++))
        ISSUES+=("❌ FICTIONAL REFERENCE DETECTED
File: $file
Line: $line_num
Issue: Reference to non-existent agent '$agent_ref'
Expected: Agent file should exist at one of:
  - $user_agent
  - $project_agent
  - $flat_user_agent
  - $flat_project_agent
Status: File not found
Suggestion: Create the agent file or update the reference to an existing agent
")
        return 1
    fi
    return 0
}

# Function to check if command exists
check_command_exists() {
    local command_ref="$1"
    local file="$2"
    local line_num="$3"
    
    # Parse command reference patterns
    local topic=""
    local command_name=""
    
    # Pattern: /{topic}:{command-name}
    if [[ "$command_ref" =~ ^/([^:]+):(.+)$ ]]; then
        topic="${BASH_REMATCH[1]}"
        command_name="${BASH_REMATCH[2]}"
    else
        return 0  # Not a valid command reference pattern
    fi
    
    # Special handling for agent-complex commands
    if [[ "$topic" == "agent-complex" ]]; then
        local agent_complex_cmd="$REPO_ROOT/ubuntu-vm/user/agent-complex/commands/$command_name.md"
        if [[ ! -f "$agent_complex_cmd" ]]; then
            ((FICTIONAL_REFS++))
            ((MISSING_COMMANDS++))
            ISSUES+=("❌ FICTIONAL REFERENCE DETECTED
File: $file
Line: $line_num
Issue: Reference to non-existent command '$command_ref'
Expected: Command file should exist at:
  - $agent_complex_cmd
Status: File not found
Suggestion: Create the command file or update the reference to an existing command
")
            return 1
        fi
        return 0
    fi
    
    # Check possible command locations
    local root_cmd="$REPO_ROOT/ubuntu-vm/root/commands/$command_name.md"
    local user_cmd="$REPO_ROOT/ubuntu-vm/user/$topic/commands/$command_name.md"
    local project_cmd="$REPO_ROOT/ubuntu-vm/project/$topic/commands/$command_name.md"
    
    if [[ ! -f "$root_cmd" && ! -f "$user_cmd" && ! -f "$project_cmd" ]]; then
        ((FICTIONAL_REFS++))
        ((MISSING_COMMANDS++))
        ISSUES+=("❌ FICTIONAL REFERENCE DETECTED
File: $file
Line: $line_num
Issue: Reference to non-existent command '$command_ref'
Expected: Command file should exist at one of:
  - $root_cmd
  - $user_cmd
  - $project_cmd
Status: File not found
Suggestion: Create the command file or update the reference to an existing command
")
        return 1
    fi
    return 0
}

# Function to check if script exists
check_script_exists() {
    local script_ref="$1"
    local file="$2"
    local line_num="$3"
    local current_file_dir=$(dirname "$file")
    
    # Handle different script path patterns
    local script_path=""
    
    # Development path: ../scripts/
    if [[ "$script_ref" =~ ^\.\./scripts/(.+)$ ]]; then
        local script_name="${BASH_REMATCH[1]}"
        # Determine context from current file
        if [[ "$current_file_dir" =~ ubuntu-vm/user/([^/]+)/commands ]]; then
            local topic="${BASH_REMATCH[1]}"
            script_path="$REPO_ROOT/ubuntu-vm/user/$topic/scripts/$script_name"
        elif [[ "$current_file_dir" =~ ubuntu-vm/project/([^/]+)/commands ]]; then
            local topic="${BASH_REMATCH[1]}"
            script_path="$REPO_ROOT/ubuntu-vm/project/$topic/scripts/$script_name"
        elif [[ "$current_file_dir" =~ ubuntu-vm/root/commands ]]; then
            script_path="$REPO_ROOT/ubuntu-vm/root/scripts/$script_name"
        fi
    # User deployment path: ~/.claude/scripts/{topic}/
    elif [[ "$script_ref" =~ ^~/.claude/scripts/([^/]+)/(.+)$ ]]; then
        local topic="${BASH_REMATCH[1]}"
        local script_name="${BASH_REMATCH[2]}"
        script_path="$REPO_ROOT/ubuntu-vm/user/$topic/scripts/$script_name"
    # Project deployment path: .claude/scripts/{topic}/
    elif [[ "$script_ref" =~ ^\.claude/scripts/([^/]+)/(.+)$ ]]; then
        local topic="${BASH_REMATCH[1]}"
        local script_name="${BASH_REMATCH[2]}"
        script_path="$REPO_ROOT/ubuntu-vm/project/$topic/scripts/$script_name"
    # Root deployment path: /root/.claude/scripts/
    elif [[ "$script_ref" =~ ^/root/.claude/scripts/(.+)$ ]]; then
        local script_name="${BASH_REMATCH[1]}"
        script_path="$REPO_ROOT/ubuntu-vm/root/scripts/$script_name"
    fi
    
    if [[ -n "$script_path" && ! -f "$script_path" ]]; then
        ((FICTIONAL_REFS++))
        ((MISSING_SCRIPTS++))
        ISSUES+=("❌ FICTIONAL REFERENCE DETECTED
File: $file
Line: $line_num
Issue: Reference to non-existent script '$script_ref'
Expected: Script file should exist at:
  - $script_path
Status: File not found
Suggestion: Create the script file or update the reference to an existing script
")
        return 1
    fi
    return 0
}

# Function to check if documentation exists
check_doc_exists() {
    local doc_ref="$1"
    local file="$2"
    local line_num="$3"
    local line_content="$4"
    
    # Check if documentation reference uses hyperlink format (not allowed)
    if [[ "$line_content" =~ \[.*\]\($doc_ref\) ]]; then
        ((FORMAT_VIOLATIONS++))
        ISSUES+=("❌ FORMAT VIOLATION DETECTED
File: $file
Line: $line_num
Issue: Documentation reference uses hyperlink format instead of inline code
Reference: $doc_ref
Current: [...](${doc_ref})
Expected: \`$doc_ref\`
Suggestion: Replace hyperlink with inline code format using backticks
")
        return 1
    fi
    
    # Parse documentation path patterns
    local doc_path=""
    
    # User deployment path: ~/.claude/docs/{topic}/
    if [[ "$doc_ref" =~ ^~/.claude/docs/([^/]+)/(.+)$ ]]; then
        local topic="${BASH_REMATCH[1]}"
        local doc_name="${BASH_REMATCH[2]}"
        doc_path="$REPO_ROOT/ubuntu-vm/user/$topic/docs/$doc_name"
    # Project deployment path: .claude/docs/{topic}/
    elif [[ "$doc_ref" =~ ^\.claude/docs/([^/]+)/(.+)$ ]]; then
        local topic="${BASH_REMATCH[1]}"
        local doc_name="${BASH_REMATCH[2]}"
        doc_path="$REPO_ROOT/ubuntu-vm/project/$topic/docs/$doc_name"
    # Root deployment path: /root/.claude/docs/
    elif [[ "$doc_ref" =~ ^/root/.claude/docs/(.+)$ ]]; then
        local doc_name="${BASH_REMATCH[1]}"
        doc_path="$REPO_ROOT/ubuntu-vm/root/docs/$doc_name"
    # Direct source path
    elif [[ "$doc_ref" =~ ubuntu-vm/(user|project|root)/([^/]+/)?docs/(.+)$ ]]; then
        doc_path="$REPO_ROOT/$doc_ref"
    fi
    
    if [[ -n "$doc_path" && ! -f "$doc_path" ]]; then
        ((FICTIONAL_REFS++))
        ((MISSING_DOCS++))
        ISSUES+=("❌ FICTIONAL REFERENCE DETECTED
File: $file
Line: $line_num
Issue: Reference to non-existent documentation '$doc_ref'
Expected: Documentation file should exist at:
  - $doc_path
Status: File not found
Suggestion: Create the documentation file or update the reference to existing docs
")
        return 1
    fi
    return 0
}

# Function to scan a file for entity references
scan_file_for_references() {
    local file="$1"
    local line_num=0
    
    ((TOTAL_FILES++))
    
    while IFS= read -r line; do
        ((line_num++))
        
        # Check for agent references: @agent-{topic}:{name} or {topic}:{name}
        if [[ "$line" =~ @agent-[^[:space:]]+:[^[:space:]]+ ]] || [[ "$line" =~ [^/@[:space:]]+:[^/:[:space:]]+ ]]; then
            local agent_ref="${BASH_REMATCH[0]}"
            ((TOTAL_REFS++))
            check_agent_exists "$agent_ref" "$file" "$line_num"
        fi
        
        # Check for command references: /{topic}:{command}
        if [[ "$line" =~ /[^[:space:]]+:[^[:space:]]+ ]]; then
            local command_ref="${BASH_REMATCH[0]}"
            ((TOTAL_REFS++))
            check_command_exists "$command_ref" "$file" "$line_num"
        fi
        
        # Check for script references in various patterns
        # Pattern: ../scripts/*.sh
        if [[ "$line" =~ \.\./scripts/[^[:space:]\"\']+\.sh ]]; then
            local script_ref="${BASH_REMATCH[0]}"
            ((TOTAL_REFS++))
            check_script_exists "$script_ref" "$file" "$line_num"
        fi
        # Pattern: ~/.claude/scripts/{topic}/*.sh
        if [[ "$line" =~ ~/.claude/scripts/[^[:space:]\"\']+\.sh ]]; then
            local script_ref="${BASH_REMATCH[0]}"
            ((TOTAL_REFS++))
            check_script_exists "$script_ref" "$file" "$line_num"
        fi
        # Pattern: .claude/scripts/{topic}/*.sh
        if [[ "$line" =~ \.claude/scripts/[^[:space:]\"\']+\.sh ]]; then
            local script_ref="${BASH_REMATCH[0]}"
            ((TOTAL_REFS++))
            check_script_exists "$script_ref" "$file" "$line_num"
        fi
        # Pattern: /root/.claude/scripts/*.sh
        if [[ "$line" =~ /root/.claude/scripts/[^[:space:]\"\']+\.sh ]]; then
            local script_ref="${BASH_REMATCH[0]}"
            ((TOTAL_REFS++))
            check_script_exists "$script_ref" "$file" "$line_num"
        fi
        
        # Check for documentation references (must be in backticks)
        # Pattern: `path/to/doc.md`
        if [[ "$line" =~ \`[^[:space:]\`]+\.md\` ]]; then
            local doc_ref="${BASH_REMATCH[0]}"
            doc_ref="${doc_ref//\`/}"  # Remove backticks
            ((TOTAL_REFS++))
            check_doc_exists "$doc_ref" "$file" "$line_num" "$line"
        fi
        # Also check for incorrect hyperlink format
        if [[ "$line" =~ \[[^\]]+\]\([^\)]+\.md\) ]]; then
            local doc_ref=$(echo "$line" | sed -n 's/.*](\([^)]*\.md\)).*/\1/p')
            ((TOTAL_REFS++))
            check_doc_exists "$doc_ref" "$file" "$line_num" "$line"
        fi
        
    done < "$file"
}

# Main execution
echo "═══════════════════════════════════════════════════════════════════"
echo "🔍 ENTITY REFERENCE VALIDATION"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📋 Configuration:"
echo "  - Type: $TYPE"
echo "  - Context: $DESCRIPTION"
echo "  - Repository: $REPO_ROOT"
echo ""

# Get files to scan
echo "🔎 Discovering files to scan..."
FILES_TO_SCAN=$(get_files_to_scan "$TYPE")
FILE_COUNT=$(echo "$FILES_TO_SCAN" | grep -c "." || echo "0")

if [[ $FILE_COUNT -eq 0 ]]; then
    echo "ℹ️ No files to scan for type: $TYPE"
    exit 0
fi

echo "📂 Found $FILE_COUNT files to scan"
echo ""

# Scan each file
echo "🚀 Scanning for entity references..."
echo "───────────────────────────────────────"

while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        scan_file_for_references "$file"
    fi
done <<< "$FILES_TO_SCAN"

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "📊 VALIDATION RESULTS"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Display issues if any
if [[ ${#ISSUES[@]} -gt 0 ]]; then
    for issue in "${ISSUES[@]}"; do
        echo -e "$issue"
    done
fi

# Display summary
echo "📋 VALIDATION SUMMARY"
echo "───────────────────────────────────────"
echo "  - Total files scanned: $TOTAL_FILES"
echo "  - References validated: $TOTAL_REFS"
echo "  - Fictional references found: $FICTIONAL_REFS"
if [[ $FICTIONAL_REFS -gt 0 ]]; then
    echo "  - Missing entities breakdown:"
    [[ $MISSING_AGENTS -gt 0 ]] && echo "    • Agents: $MISSING_AGENTS"
    [[ $MISSING_COMMANDS -gt 0 ]] && echo "    • Commands: $MISSING_COMMANDS"
    [[ $MISSING_SCRIPTS -gt 0 ]] && echo "    • Scripts: $MISSING_SCRIPTS"
    [[ $MISSING_DOCS -gt 0 ]] && echo "    • Documentation: $MISSING_DOCS"
fi
[[ $FORMAT_VIOLATIONS -gt 0 ]] && echo "  - Format violations: $FORMAT_VIOLATIONS"

echo ""
if [[ $FICTIONAL_REFS -eq 0 && $FORMAT_VIOLATIONS -eq 0 ]]; then
    echo -e "${GREEN}✅ SUCCESS${NC} - All entity references are valid!"
    echo "All references point to existing entities. Deployment ready!"
    exit 0
else
    echo -e "${RED}❌ FAILED${NC} - Fix fictional references before deployment"
    echo ""
    echo "🔧 Recommended Actions:"
    echo "  1. Create missing entity files OR"
    echo "  2. Update references to point to existing entities"
    echo "  3. Replace hyperlink format with inline code (backticks) for docs"
    echo "  4. Re-run validation after fixes"
    echo ""
    echo "📚 Related Documentation:"
    echo "  - \`.claude/docs/agent-complex/claude-command-file-rules.md\`"
    echo "  - \`.claude/docs/agent-complex/claude-agent-file-rules.md\`"
    exit 1
fi