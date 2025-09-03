#!/bin/bash
set -euo pipefail

# sync-project-topic.sh - Optimized script for syncing project commands, scripts, and agents
# This script is auto-installed by the sync-project-topic command
# v2.9.1 - Fixed rsync ownership preservation warnings by using -rlptD instead of -av

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
TOPICS=""
BRANCH=""
REMOVE_MODE=false
if [ $# -lt 1 ]; then
    echo -e "${RED}❌ Error: Missing required topics argument${NC}"
    echo "Usage: sync-project-topic <topics> [branch | --branch <branch>] [--remove]"
    echo "  topics: comma-separated list (e.g., 'supabase,cloudflare') or 'all'"
    echo "  branch: optional branch name (default: main)"
    echo "         Can be specified as second argument or with --branch option"
    echo "  --remove: remove specified topics instead of syncing"
    exit 1
fi

TOPICS="$1"
shift  # Remove first argument to process remaining

# Parse remaining arguments for branch and remove flag
while [ $# -gt 0 ]; do
    if [ "$1" = "--branch" ]; then
        if [ $# -lt 2 ]; then
            echo -e "${RED}❌ Error: --branch requires a branch name${NC}"
            exit 1
        fi
        BRANCH="$2"
        shift 2
    elif [ "$1" = "--remove" ]; then
        REMOVE_MODE=true
        shift
    else
        # If not --branch or --remove flag, treat as positional branch argument
        if [ -z "$BRANCH" ] && [ "$REMOVE_MODE" = false ]; then
            BRANCH="$1"
        fi
        shift
    fi
done

# Default to main branch if not specified (only for sync mode)
if [ -z "$BRANCH" ] && [ "$REMOVE_MODE" = false ]; then
    BRANCH="main"
fi

# Save original working directory
ORIGINAL_DIR="$(pwd)"
TARGET_COMMANDS_DIR="$ORIGINAL_DIR/.claude/commands"
TARGET_SCRIPTS_DIR="$ORIGINAL_DIR/.claude/scripts"
TARGET_AGENTS_DIR="$ORIGINAL_DIR/.claude/agents"
TARGET_DOCS_DIR="$ORIGINAL_DIR/.claude/docs"

# Handle remove mode
if [ "$REMOVE_MODE" = true ]; then
    echo -e "${RED}🗑️  Remove mode activated${NC}"
    echo -e "   Target: ${YELLOW}$TARGET_COMMANDS_DIR${NC}"
    
    if [ ! -d "$TARGET_COMMANDS_DIR" ]; then
        echo -e "${YELLOW}⚠️  No .claude/commands directory found${NC}"
        exit 0
    fi
    
    if [ "$TOPICS" = "all" ]; then
        echo -e "${YELLOW}📦 Removing all project topics${NC}"
        
        # Find all topic directories and remove them
        REMOVED_COUNT=0
        # Remove all command topics
        find "$TARGET_COMMANDS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            TOPIC_NAME=$(basename "$dir")
            echo -e "${RED}  ✗ Removing commands: $TOPIC_NAME${NC}"
            rm -rf "$dir"
        done
        
        # Remove all script topics
        if [ -d "$TARGET_SCRIPTS_DIR" ]; then
            find "$TARGET_SCRIPTS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
                TOPIC_NAME=$(basename "$dir")
                echo -e "${RED}  ✗ Removing scripts directory: $TOPIC_NAME${NC}"
                rm -rf "$dir"
            done
        fi
        
        # Remove all agent files
        if [ -d "$TARGET_AGENTS_DIR" ]; then
            # Remove all {topic}:*.md files (any topic prefix format)
            find "$TARGET_AGENTS_DIR" -maxdepth 1 -name "*:*.md" -type f | while read -r file; do
                echo -e "${RED}  ✗ Removing agent: $(basename "$file")${NC}"
                rm -f "$file"
            done
        fi
        
        # Remove all doc topics
        if [ -d "$TARGET_DOCS_DIR" ]; then
            find "$TARGET_DOCS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
                TOPIC_NAME=$(basename "$dir")
                echo -e "${RED}  ✗ Removing docs directory: $TOPIC_NAME${NC}"
                rm -rf "$dir"
            done
        fi
        
        echo -e "\n${GREEN}✅ Removed all project command topics${NC}"
    else
        echo -e "${YELLOW}📦 Removing specific topics: $TOPICS${NC}"
        
        # Convert comma-separated list to array
        IFS=',' read -ra TOPIC_ARRAY <<< "$TOPICS"
        
        for topic in "${TOPIC_ARRAY[@]}"; do
            # Trim whitespace
            topic=$(echo "$topic" | xargs)
            
            # Remove all resources for the topic
            REMOVED_SOMETHING=false
            
            if [ -d "$TARGET_COMMANDS_DIR/$topic" ]; then
                echo -e "${RED}  ✗ Removing commands: $topic${NC}"
                rm -rf "$TARGET_COMMANDS_DIR/$topic"
                REMOVED_SOMETHING=true
            fi
            
            if [ -d "$TARGET_SCRIPTS_DIR/$topic" ]; then
                echo -e "${RED}  ✗ Removing scripts: $topic${NC}"
                rm -rf "$TARGET_SCRIPTS_DIR/$topic"
                REMOVED_SOMETHING=true
            fi
            
            # Remove any {topic}:* agent files (exact match only)
            if [ -d "$TARGET_AGENTS_DIR" ]; then
                # Use a more precise pattern to match only exact topic prefix
                # This ensures 'figma' doesn't match 'figma-make' files
                find "$TARGET_AGENTS_DIR" -maxdepth 1 -type f -name "*.md" | while read -r file; do
                    filename=$(basename "$file")
                    # Check if filename starts with exact topic followed by colon
                    if [[ "$filename" =~ ^${topic}:[^:].*\.md$ ]]; then
                        echo -e "${RED}  ✗ Removing agent: $filename${NC}"
                        rm -f "$file"
                        REMOVED_SOMETHING=true
                    fi
                done
            fi
            
            if [ -d "$TARGET_DOCS_DIR/$topic" ]; then
                echo -e "${RED}  ✗ Removing docs directory: $topic${NC}"
                rm -rf "$TARGET_DOCS_DIR/$topic"
                REMOVED_SOMETHING=true
            fi
            
            if [ "$REMOVED_SOMETHING" = false ]; then
                echo -e "${YELLOW}  ⚠️  Topic not found: $topic${NC}"
            fi
        done
        
        echo -e "\n${GREEN}✅ Topic removal completed${NC}"
    fi
    
    # Show remaining topics
    echo -e "\n${BLUE}📦 Remaining topics:${NC}"
    echo -e "${YELLOW}Commands:${NC}"
    if [ -d "$TARGET_COMMANDS_DIR" ]; then
        find "$TARGET_COMMANDS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            TOPIC_NAME=$(basename "$dir")
            echo "   - $TOPIC_NAME"
        done
    fi
    echo -e "${YELLOW}Scripts:${NC}"
    if [ -d "$TARGET_SCRIPTS_DIR" ]; then
        find "$TARGET_SCRIPTS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            TOPIC_NAME=$(basename "$dir")
            echo "   - $TOPIC_NAME/"
        done
    fi
    echo -e "${YELLOW}Agents:${NC}"
    if [ -d "$TARGET_AGENTS_DIR" ]; then
        # Show all agent files with {topic}:{agent-name}.md format
        find "$TARGET_AGENTS_DIR" -maxdepth 1 -name "*.md" -type f | while read -r file; do
            echo "   - $(basename "$file")"
        done
    fi
    echo -e "${YELLOW}Docs:${NC}"
    if [ -d "$TARGET_DOCS_DIR" ]; then
        find "$TARGET_DOCS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            TOPIC_NAME=$(basename "$dir")
            echo "   - $TOPIC_NAME/"
        done
    fi
    
    exit 0
fi

# GitHub repository information (only needed for sync mode)
GITHUB_REPO="https://github.com/Engram-Nexus/engram-copilot-docs.git"
GITHUB_REPO_NAME="engram-copilot-docs"

# Create temporary directory for cloning
TEMP_DIR="$(mktemp -d -t sync-project-topic-XXXXXX)"
trap "rm -rf '$TEMP_DIR'" EXIT

echo -e "${BLUE}🌐 Fetching latest commands from GitHub repository...${NC}"
echo -e "   Repository: ${YELLOW}$GITHUB_REPO${NC}"
echo -e "   Branch: ${YELLOW}$BRANCH${NC}"

# Clone the repository with sparse checkout
cd "$TEMP_DIR"
git clone --depth 1 --filter=blob:none --sparse --branch "$BRANCH" "$GITHUB_REPO" "$GITHUB_REPO_NAME" >/dev/null 2>&1 || {
    echo -e "${RED}❌ Failed to clone repository. Check your internet connection and branch name.${NC}"
    exit 1
}
cd "$GITHUB_REPO_NAME"
git sparse-checkout set ubuntu-vm/project >/dev/null 2>&1

# Define paths
PROJECT_DIR="$TEMP_DIR/$GITHUB_REPO_NAME/ubuntu-vm/project"
TARGET_COMMANDS_DIR="$ORIGINAL_DIR/.claude/commands"
TARGET_SCRIPTS_DIR="$ORIGINAL_DIR/.claude/scripts"
TARGET_AGENTS_DIR="$ORIGINAL_DIR/.claude/agents"

echo -e "${GREEN}✅ Successfully fetched repository${NC}"
echo "🔄 Syncing project commands, scripts, and agents to repository .claude directory..."

# Return to original working directory
cd "$ORIGINAL_DIR"

# Create target directories
mkdir -p "$TARGET_COMMANDS_DIR"
mkdir -p "$TARGET_SCRIPTS_DIR"
mkdir -p "$TARGET_AGENTS_DIR"
mkdir -p "$TARGET_DOCS_DIR"

# Sync commands
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}📁 Syncing commands from GitHub to repository...${NC}"
    echo -e "   Source: ${BLUE}GitHub:${NC} ubuntu-vm/project/"
    echo -e "   Target: ${BLUE}Repository:${NC} .claude/commands/"
    
    # Skip root-level .md files - only sync topic directories
    
    if [ "$TOPICS" = "all" ]; then
        # Sync all subdirectories
        echo -e "${YELLOW}📦 Syncing all topics${NC}"
        
        # Find all subdirectories and sync them (excluding hidden dirs and non-topic dirs)
        find "$PROJECT_DIR" -mindepth 1 -maxdepth 1 -type d ! -name ".*" | while read -r dir; do
            TOPIC_NAME=$(basename "$dir")
            echo -e "${GREEN}  ✓ Syncing topic: $TOPIC_NAME${NC}"
            # Sync commands from topic's commands subdirectory
            if [ -d "$dir/commands" ]; then
                echo -e "${BLUE}    ↳ Syncing topic commands${NC}"
                mkdir -p "$TARGET_COMMANDS_DIR/$TOPIC_NAME"
                rsync -rlptD "$dir/commands/" "$TARGET_COMMANDS_DIR/$TOPIC_NAME/"
            fi
            
            # Sync scripts from topic's scripts subdirectory
            if [ -d "$dir/scripts" ]; then
                echo -e "${BLUE}    ↳ Syncing topic scripts${NC}"
                mkdir -p "$TARGET_SCRIPTS_DIR/$TOPIC_NAME"
                find "$dir/scripts" -name "*.sh" -o -name "*.js" -type f | while read -r script; do
                    SCRIPT_NAME=$(basename "$script")
                    cp -v "$script" "$TARGET_SCRIPTS_DIR/$TOPIC_NAME/$SCRIPT_NAME"
                    chmod +x "$TARGET_SCRIPTS_DIR/$TOPIC_NAME/$SCRIPT_NAME"
                done
            fi
            
            # Sync agents from topic's agents subdirectory
            if [ -d "$dir/agents" ]; then
                echo -e "${BLUE}    ↳ Syncing topic agents${NC}"
                
                # First, remove any old {topic}:* files from root agents directory (exact match)
                find "$TARGET_AGENTS_DIR" -maxdepth 1 -type f -name "*.md" | while read -r oldfile; do
                    filename=$(basename "$oldfile")
                    # Check if filename starts with exact topic followed by colon
                    if [[ "$filename" =~ ^${TOPIC_NAME}:[^:].*\.md$ ]]; then
                        echo -e "${YELLOW}      Removing old format: $filename${NC}"
                        rm -f "$oldfile"
                    fi
                done
                
                # Sync agents to root directory with topic prefix
                find "$dir/agents" -name "*.md" -type f | while read -r agent; do
                    AGENT_NAME=$(basename "$agent" .md)
                    cp -v "$agent" "$TARGET_AGENTS_DIR/${TOPIC_NAME}:${AGENT_NAME}.md"
                    echo -e "${GREEN}      ✓ ${AGENT_NAME}.md → ${TOPIC_NAME}:${AGENT_NAME}.md${NC}"
                done
            fi
            
            # Sync docs from topic's docs subdirectory
            if [ -d "$dir/docs" ]; then
                echo -e "${BLUE}    ↳ Syncing topic docs${NC}"
                mkdir -p "$TARGET_DOCS_DIR/$TOPIC_NAME"
                rsync -rlptD "$dir/docs/" "$TARGET_DOCS_DIR/$TOPIC_NAME/"
            fi
        done
    else
        # Sync only specified topics
        echo -e "${YELLOW}📦 Syncing specific topics: $TOPICS${NC}"
        
        # Convert comma-separated list to array
        IFS=',' read -ra TOPIC_ARRAY <<< "$TOPICS"
        
        for topic in "${TOPIC_ARRAY[@]}"; do
            # Trim whitespace
            topic=$(echo "$topic" | xargs)
            
            if [ -d "$PROJECT_DIR/$topic" ]; then
                echo -e "${GREEN}  ✓ Syncing topic: $topic${NC}"
                # Sync commands from topic's commands subdirectory
                if [ -d "$PROJECT_DIR/$topic/commands" ]; then
                    echo -e "${BLUE}    ↳ Syncing topic commands${NC}"
                    mkdir -p "$TARGET_COMMANDS_DIR/$topic"
                    rsync -rlptD "$PROJECT_DIR/$topic/commands/" "$TARGET_COMMANDS_DIR/$topic/"
                fi
                
                # Sync scripts from topic's scripts subdirectory
                if [ -d "$PROJECT_DIR/$topic/scripts" ]; then
                    echo -e "${BLUE}    ↳ Syncing topic scripts${NC}"
                    mkdir -p "$TARGET_SCRIPTS_DIR/$topic"
                    find "$PROJECT_DIR/$topic/scripts" -name "*.sh" -o -name "*.js" -type f | while read -r script; do
                        SCRIPT_NAME=$(basename "$script")
                        cp -v "$script" "$TARGET_SCRIPTS_DIR/$topic/$SCRIPT_NAME"
                        chmod +x "$TARGET_SCRIPTS_DIR/$topic/$SCRIPT_NAME"
                    done
                fi
                
                # Sync agents from topic's agents subdirectory
                if [ -d "$PROJECT_DIR/$topic/agents" ]; then
                    echo -e "${BLUE}    ↳ Syncing topic agents${NC}"
                    
                    # First, remove any old {topic}:* files from root agents directory (exact match)
                    find "$TARGET_AGENTS_DIR" -maxdepth 1 -type f -name "*.md" | while read -r oldfile; do
                        filename=$(basename "$oldfile")
                        # Check if filename starts with exact topic followed by colon
                        if [[ "$filename" =~ ^${topic}:[^:].*\.md$ ]]; then
                            echo -e "${YELLOW}      Removing old format: $filename${NC}"
                            rm -f "$oldfile"
                        fi
                    done
                    
                    # Sync agents to root directory with topic prefix
                    find "$PROJECT_DIR/$topic/agents" -name "*.md" -type f | while read -r agent; do
                        AGENT_NAME=$(basename "$agent" .md)
                        cp -v "$agent" "$TARGET_AGENTS_DIR/${topic}:${AGENT_NAME}.md"
                        echo -e "${GREEN}      ✓ ${AGENT_NAME}.md → ${topic}:${AGENT_NAME}.md${NC}"
                    done
                fi
                
                # Sync docs from topic's docs subdirectory
                if [ -d "$PROJECT_DIR/$topic/docs" ]; then
                    echo -e "${BLUE}    ↳ Syncing topic docs${NC}"
                    mkdir -p "$TARGET_DOCS_DIR/$topic"
                    rsync -rlptD "$PROJECT_DIR/$topic/docs/" "$TARGET_DOCS_DIR/$topic/"
                fi
            else
                echo -e "${RED}  ✗ Topic not found: $topic${NC}"
            fi
        done
    fi
    
    # Count and list synced resources
    COMMAND_COUNT=$(find "$TARGET_COMMANDS_DIR" -name "*.md" -type f | wc -l)
    AGENT_COUNT=0
    if [ -d "$TARGET_AGENTS_DIR" ]; then
        AGENT_COUNT=$(find "$TARGET_AGENTS_DIR" -type f | wc -l)
    fi
    DOCS_COUNT=0
    if [ -d "$TARGET_DOCS_DIR" ]; then
        DOCS_COUNT=$(find "$TARGET_DOCS_DIR" -type f | wc -l)
    fi
    echo -e "${GREEN}✅ Synced $COMMAND_COUNT command files${NC}"
    if [ $AGENT_COUNT -gt 0 ]; then
        echo -e "${GREEN}✅ Synced $AGENT_COUNT agent files${NC}"
    fi
    
    # List synced commands
    echo -e "\n${YELLOW}📋 Synced commands:${NC}"
    find "$TARGET_COMMANDS_DIR" -name "*.md" -type f | sort | while read -r file; do
        # Get relative path from target commands dir
        REL_PATH="${file#$TARGET_COMMANDS_DIR/}"
        echo "  - $REL_PATH"
    done
    
    # List synced agents
    if [ $AGENT_COUNT -gt 0 ]; then
        echo -e "\n${YELLOW}🤖 Synced agents:${NC}"
        find "$TARGET_AGENTS_DIR" -name "*.md" -type f | sort | while read -r file; do
            # Get relative path from target agents dir
            REL_PATH="${file#$TARGET_AGENTS_DIR/}"
            echo "  - $REL_PATH"
        done
    fi
    
    # List synced docs
    if [ $DOCS_COUNT -gt 0 ]; then
        echo -e "\n${YELLOW}📚 Synced docs:${NC}"
        find "$TARGET_DOCS_DIR" -name "*.md" -type f | sort | while read -r file; do
            # Get relative path from target docs dir
            REL_PATH="${file#$TARGET_DOCS_DIR/}"
            echo "  - $REL_PATH"
        done
    fi
else
    echo -e "${RED}⚠️  No project directory found in GitHub repository${NC}"
    echo -e "   Expected path: ubuntu-vm/project/"
    echo -e "   Repository: $GITHUB_REPO"
    exit 1
fi

# Summary
# Check and update .gitignore to ensure .claude is not ignored
GITIGNORE_FILE="$ORIGINAL_DIR/.gitignore"
if [ -f "$GITIGNORE_FILE" ]; then
    echo -e "\n${YELLOW}🔧 Checking .gitignore for .claude entries...${NC}"
    
    # Remove any lines that would ignore .claude
    if grep -q "^\.claude" "$GITIGNORE_FILE" || grep -q "^/\.claude" "$GITIGNORE_FILE"; then
        echo -e "${YELLOW}  Found .claude in .gitignore - removing to enable tracking${NC}"
        # Create backup
        cp "$GITIGNORE_FILE" "$GITIGNORE_FILE.bak"
        # Remove lines that ignore .claude
        grep -v "^\.claude" "$GITIGNORE_FILE" | grep -v "^/\.claude" > "$GITIGNORE_FILE.tmp"
        mv "$GITIGNORE_FILE.tmp" "$GITIGNORE_FILE"
        echo -e "${GREEN}  ✓ Removed .claude from .gitignore${NC}"
        echo -e "${BLUE}  Backup saved to: .gitignore.bak${NC}"
    else
        echo -e "${GREEN}  ✓ .claude is not ignored (good!)${NC}"
    fi
else
    echo -e "\n${GREEN}✓ No .gitignore file found - .claude will be tracked${NC}"
fi

echo -e "\n${GREEN}✅ Project sync completed!${NC}"
echo -e "Resources synced from: ${BLUE}$GITHUB_REPO${NC} (branch: ${YELLOW}$BRANCH${NC})"
echo -e "Commands available at: ${YELLOW}$TARGET_COMMANDS_DIR/<topic>${NC}"
echo -e "Scripts available at: ${YELLOW}$TARGET_SCRIPTS_DIR${NC}"
echo -e "Agents available at: ${YELLOW}$TARGET_AGENTS_DIR/{topic}:*.md${NC}"

echo -e "\n${YELLOW}⚠️  IMPORTANT: Next Steps${NC}"
echo -e "1. ${YELLOW}Review the synced commands and agents${NC} in the repository's .claude/ directories"
echo -e "2. ${YELLOW}Commit these changes${NC} to version control if they look correct"
echo -e "3. ${YELLOW}Deploy to local Claude${NC}: Copy .claude/* directories to ~/.claude/ to use commands and agents"
echo -e "4. ${YELLOW}Deploy to remote machines${NC}: Use sync-commands-with-remote to deploy"

# Show synced topics
echo -e "\n${GREEN}📦 Synced topics:${NC}"
find "$TARGET_COMMANDS_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    TOPIC_NAME=$(basename "$dir")
    echo "   - $TOPIC_NAME"
done

# Note about agent directory structure
echo -e "\n${GREEN}🤖 Agent Directory Structure:${NC}"
echo -e "   Agents use topic prefix format: ${YELLOW}.claude/agents/{topic}:{agent-name}.md${NC}"
echo -e "   This allows Claude to recognize topic context automatically"

echo -e "\n${YELLOW}📝 Note:${NC} This command uses an optimized script when available at:"
echo "   ~/.claude/scripts/sync/sync-project-topic_sync.sh (primary)"
echo "   ../scripts/sync-project-topic_sync.sh (fallback)"

# Clean up temp directory (handled by trap, but be explicit)
rm -rf "$TEMP_DIR"