# Args: `<type:topic>` `<agent-name>` `<description>`. v3.0.0. Create or update agent files with proper frontmatter configuration.

## Summary

Creates new Claude agent files or updates existing ones with proper frontmatter configuration following the guidelines in `.claude/docs/agent-complex/claude-agent-file-rules.md`. Supports topic-based organization for both user-level agents (`~/.claude/agents/{topic}/`) and project-specific agents (`.claude/agents/{topic}/`). When updating existing agents, the command preserves the agent's content while updating the description to use single-line format for Claude Code CLI compatibility. This command focuses solely on agent file creation and does not manage git workflows.

## Command Execution

This command directly creates or updates agent files without managing git workflows. Users should handle branch creation and PR management separately.

## Usage

```bash
/agent-complex:update-agent <type:topic> <agent-name> "<description>"
```

## Arguments

- `<type:topic>`: Agent type and topic combined (REQUIRED)
  - Format: `type:topic` where:
    - `type` is either `user`, `project`, or `nexus`
    - `topic` is the category (e.g., `dev`, `git`, `slack`, `docs`, `security`, `auth`, `database`)
  - Examples: `user:dev`, `project:supabase`, `user:general`, `nexus:auth`
  - `user` agents deploy to `~/.claude/agents/{topic}:{agent-name}.md`
  - `project` agents deploy to `.claude/agents/{topic}:{agent-name}.md`
  - `nexus` agents deploy to `.claude/agents/nexus:{topic}:{agent-name}.md`
- `<agent-name>`: Name for the agent file (REQUIRED)
  - Kebab-case format (lowercase with hyphens)
  - Should be descriptive but concise
  - Examples: `release-notes-writer`, `pr-analyzer`, `security-auditor`
  - Maximum 30 characters recommended
- `<description>`: Purpose and duties of the agent (REQUIRED)
  - Brief description of what the agent does
  - Will be used in frontmatter and system prompt
  - Quote if contains spaces
  - Examples: "Review code for security vulnerabilities", "Analyze git commit history"

## Path Configuration Table

**CRITICAL**: Understanding deployment paths and how agents reference components is essential:

| Component | Type | Deployment Path | How Agent References |
|-----------|------|-----------------|----------------------|
| **User Agents** | Files | `~/.claude/agents/{topic}:{agent-name}.md` | `@agent-{topic}:{agent-name}` or `@agent-{agent-name}` |
| **User Docs** | References | `~/.claude/docs/{topic}/{doc-name}.md` | `` `~/.claude/docs/{topic}/{doc-name}.md` `` |
| **User Commands** | References | `~/.claude/commands/{topic}/{command-name}.md` | `/{topic}:{command-name}` |
| **Project Agents** | Files | `.claude/agents/{topic}:{agent-name}.md` | `@agent-{topic}:{agent-name}` or `@agent-{agent-name}` |
| **Project Docs** | References | `.claude/docs/{topic}/{doc-name}.md` | `` `.claude/docs/{topic}/{doc-name}.md` `` |
| **Project Commands** | References | `.claude/commands/{topic}/{command-name}.md` | `/{topic}:{command-name}` |
| **Nexus Agents** | Files | `.claude/agents/nexus:{topic}:{agent-name}.md` | `@agent-nexus:{topic}:{agent-name}` |
| **Nexus Docs** | References | `.claude/docs/nexus/{topic}/{doc-name}.md` | `` `.claude/docs/nexus/{topic}/{doc-name}.md` `` |
| **Nexus Commands** | References | `.claude/commands/nexus/{topic}/{command-name}.md` | `/nexus:{topic}:{command-name}` |

### Key Points:
- **Implementation Environment**: Files are implemented directly in the deployment/destination paths
- **In Agent Files**: Always use deployment paths when referencing documentation
- **User vs Project**: User paths use `~/.claude/`, project paths use `<project-root>/.claude/`
- **Flat User Agents**: `general` topic agents deploy without topic prefix (e.g., `~/.claude/agents/security-auditor.md`)

## Examples

```bash
# Create user agent in dev topic
/agent-complex:update-agent user:dev release-notes-writer "Generate comprehensive release notes from PR history"
# Deploys to: ~/.claude/agents/dev:release-notes-writer.md

# Create user agent in git topic
/agent-complex:update-agent user:git pr-analyzer "Analyze pull requests for code quality and patterns"
# Deploys to: ~/.claude/agents/git:pr-analyzer.md

# Create flat user agent (backward compatibility)
/agent-complex:update-agent user:general security-auditor "Audit code for security vulnerabilities"
# Deploys to: ~/.claude/agents/security-auditor.md (flat agent, no topic prefix)

# Create project agent in supabase topic
/agent-complex:update-agent project:supabase database-migrator "Handle Supabase database schema migrations"
# Deploys to: .claude/agents/supabase:database-migrator.md

# Create project agent in cloudflare topic
/agent-complex:update-agent project:cloudflare edge-function-validator "Validate Cloudflare edge functions"
# Deploys to: .claude/agents/cloudflare:edge-function-validator.md

# Create nexus agent in auth topic
/agent-complex:update-agent nexus:auth login-handler "Handle authentication and login workflows"
# Deploys to: .claude/agents/nexus:auth:login-handler.md
```

## What This Command Does

### 1. Validate Arguments
- Validates type:topic format (e.g., user:dev, project:supabase)
- Validates type is either 'user' or 'project'
- Validates topic is provided (non-empty)
- Validates agent-name follows kebab-case format

### 2. Generate Agent Configuration
- Uses provided agent-name directly (no auto-generation)
- Generates minimal frontmatter with name and description
- Creates template system prompt with guidance for customization
- Includes critical instructions about command usage and verification
- Determines appropriate file location based on type and topic

### 3. Create Agent File
- Places agent in topic-based directory structure
- Ensures proper frontmatter formatting with YAML syntax
- Includes comprehensive system prompt with role definition, methodology, and output format
- Adds "Useful Commands" section for command integration
- For user agents synced with sync-commands-with-remote:
  - Flat agents (`general` topic) → `~/.claude/agents/{agent-name}.md`
  - Topic agents → `~/.claude/agents/{topic}:{agent-name}.md`

### 4. Directory Structure Management
- Creates necessary directories if they don't exist
- For user agents: `~/.claude/agents/{topic}/`
- For project agents: `.claude/agents/{topic}/`

## Usage Notes

### Direct File Operations

This command focuses solely on creating or updating agent files:

1. **Agent File Creation**: Creates the agent file with proper configuration
2. **Update Detection**: Automatically detects if agent exists and updates appropriately
3. **Template Generation**: Provides comprehensive template for new agents
4. **Path Management**: Handles topic-based directory structure automatically

### Git Workflow Management

Users should manage git workflows separately:
- Create feature branches manually using standard git commands
- Commit changes after reviewing the generated agent file
- Create PRs using standard git workflow commands

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🤖 UPDATE-AGENT v3.0.0"
echo "This command will create or update an agent file with proper configuration."
echo "Note: Git workflow management (branches, commits, PRs) should be handled separately."
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 3 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:update-agent <type:topic> <agent-name> \"<description>\""
    echo "  type:topic: Combined type and topic (e.g., user:dev, project:supabase, nexus:auth)"
    echo "  agent-name: Name for the agent (kebab-case)"
    echo "  description: Purpose and duties of the agent"
    exit 1
fi

TYPE_TOPIC="$1"
AGENT_NAME="$2"
DESCRIPTION="$3"

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
    echo "Examples: dev, git, slack, docs, security, general"
    exit 1
fi

# Validate agent name format (kebab-case)
if ! [[ "$AGENT_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "❌ Error: Invalid agent name format"
    echo "Agent name must be kebab-case (lowercase letters, numbers, and hyphens)"
    echo "Examples: release-notes-writer, pr-analyzer, security-auditor"
    exit 1
fi

# Validate agent name length
if [ ${#AGENT_NAME} -gt 30 ]; then
    echo "❌ Error: Agent name too long (${#AGENT_NAME} characters)"
    echo "Maximum 30 characters recommended"
    exit 1
fi

# Validate git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Step 1: Validate and provide guidance on description

# Validate and provide guidance on description
echo ""
echo "📋 Description Validation:"
echo "───────────────────────────────────────"
echo "✅ Checking description follows new principles..."
echo ""
echo "⚠️  REMINDER: Agent descriptions must:"
echo "  1. Provide a HOLISTIC overview of ALL capabilities"
echo "  2. Specify clear ACTIVATION CONDITIONS"
echo "  3. Define EXPECTED OUTCOMES"
echo ""
echo "❌ AVOID:"
echo "  - Focusing on specific features or recent updates"
echo "  - Narrow descriptions that miss the agent's full scope"
echo "  - Vague activation triggers"
echo ""

# Step 2: Create agent file
echo ""
echo "📌 Creating agent file..."
echo "───────────────────────────────────────"

# Determine target directory based on type and topic
if [ "$TYPE" = "user" ]; then
    TARGET_DIR="ubuntu-vm/user/$TOPIC/agents"
    SCOPE="user-level ($TOPIC topic)"
    AGENT_FILE="$TARGET_DIR/$AGENT_NAME.md"
elif [ "$TYPE" = "project" ]; then
    TARGET_DIR=".claude/$TOPIC/agents"
    SCOPE="project-specific ($TOPIC topic)"
    AGENT_FILE="$TARGET_DIR/$AGENT_NAME.md"
elif [ "$TYPE" = "nexus" ]; then
    TARGET_DIR=".claude/agents"
    SCOPE="nexus ($TOPIC topic)"
    # Nexus agents use special naming convention
    AGENT_FILE="$TARGET_DIR/nexus:$TOPIC:$AGENT_NAME.md"
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Check if agent already exists
if [ -f "$AGENT_FILE" ]; then
    echo "📝 Agent already exists: $AGENT_FILE"
    echo "🔄 Updating existing agent..."
    
    # Backup the existing file
    cp "$AGENT_FILE" "${AGENT_FILE}.bak"
    
    # Extract existing content after frontmatter
    EXISTING_CONTENT=$(awk 'BEGIN{frontmatter=0} /^---$/{frontmatter++; if(frontmatter==2){getline; while(getline)print}}' "$AGENT_FILE")
    
    # Update the agent with new description (single-line format)
    UPDATE_MODE=true
else
    echo "🤖 Creating new agent: $AGENT_NAME"
    UPDATE_MODE=false
fi

echo "📁 Location: $AGENT_FILE"

# Generate frontmatter and system prompt
if [ "$UPDATE_MODE" = true ]; then
    # For updates, preserve existing color if present
    EXISTING_COLOR=$(awk '/^color:/ {print $2; exit}' "$AGENT_FILE" 2>/dev/null || echo "blue")
    
    # Determine agent name format
    if [ "$TYPE" = "user" ] && [ "$TOPIC" = "general" ]; then
        AGENT_FULL_NAME="$AGENT_NAME"  # Flat agents don't use topic prefix
    else
        AGENT_FULL_NAME="$TOPIC:$AGENT_NAME"
    fi
    
    # Create updated agent file with single-line description
    cat > "$AGENT_FILE" << EOF
---
name: $AGENT_FULL_NAME
description: $DESCRIPTION
color: $EXISTING_COLOR
---

$EXISTING_CONTENT
EOF
else
    # Determine agent name format
    if [ "$TYPE" = "user" ] && [ "$TOPIC" = "general" ]; then
        AGENT_FULL_NAME="$AGENT_NAME"  # Flat agents don't use topic prefix
    else
        AGENT_FULL_NAME="$TOPIC:$AGENT_NAME"
    fi
    
    # For new agents, create full template with single-line description
    cat > "$AGENT_FILE" << EOF
---
name: $AGENT_FULL_NAME
description: $DESCRIPTION
color: blue
---

You are a specialized agent with the following purpose: $DESCRIPTION

## Core Expertise and Capabilities

### Essential Resources Table

[IMPORTANT: Create a table of the most critical commands and documentation for this agent. This table should be placed at the very beginning of the Core Expertise section. Format:

| Resource Type | Name | Purpose | When to Use |
|--------------|------|---------|-------------|
| **Command** | \`/command-name <args>\` | Brief purpose | Specific scenarios |
| **Documentation** | \`path/to/doc.md\` | What it contains | When to reference |

Example:
| Resource Type | Name | Purpose | When to Use |
|--------------|------|---------|-------------|
| **Command** | \`git checkout -b <branch-name>\` | Creates feature branches | Starting new implementation work |
| **Command** | \`/git:cleanup-pr <pr-number>\` | Cleans up merged PRs | After PR is merged |
| **Documentation** | \`~/.claude/docs/git/workflow.md\` | Git workflow best practices | Planning branch strategies |
| **Documentation** | \`~/.claude/docs/git/pr-guidelines.md\` | PR creation standards | Before creating PRs |

Include only the most essential resources (5-10 items max) that are central to the agent's primary functions.]

[IMPORTANT: After the table, develop the rest of the Core Expertise section with subsections such as:
- Primary capabilities and specializations
- Methodologies and approaches
- Output formats and standards
- Key principles and constraints
- Any specialized knowledge or context

The system prompt should be tailored to the agent's specific role rather than following a generic template.]

## Useful Commands

[IMPORTANT: You should verify and list actual commands that exist in:
- User commands: ~/.claude/commands/{topic}/
- Project commands: .claude/commands/{topic}/

For each command listed:
1. Verify it exists in the appropriate directory
2. Check the command's argument structure from its .md file
3. Provide a brief description of when and how it's typically used
4. Include the correct argument syntax

Example format:
- \`/command-name <arg1> <arg2>\` - Brief description of what it does and when to use it

Note: Unlike regular commands, agents SHOULD proactively suggest and use these commands when appropriate for their tasks. The commands listed here are tools the agent can freely utilize.

Remove this instruction block and replace with actual verified commands.]

## Related Documentation

[IMPORTANT: Documentation Path Configuration - CRITICAL DISTINCTION
This agent is a $TYPE agent, so use the appropriate paths:

STORAGE PATHS (for verification during creation):
- User docs: ~/.claude/docs/{topic}/
- Project docs: .claude/docs/{topic}/

DEPLOYMENT PATHS (for references in this agent file):
- User docs: ~/.claude/docs/{topic}/
- Project docs: <project-root>/.claude/docs/{topic}/

⚠️ CRITICAL: This is a $TYPE agent, so use $(if [ "$TYPE" = "user" ]; then echo "~/.claude/docs/{topic}/"; else echo "<project-root>/.claude/docs/{topic}/"; fi) for all documentation references.

For each doc listed:
1. Verify it exists in the STORAGE directory during agent file creation
2. Reference it using the DEPLOYMENT path in the agent file
3. Provide a brief description of what guidance it contains
4. Indicate when the agent should reference this documentation

Example format for $TYPE agents:
- \`$(if [ "$TYPE" = "user" ]; then echo "~/.claude/docs/{topic}/doc-name.md"; else echo "<project-root>/.claude/docs/{topic}/doc-name.md"; fi)\` - Brief description of the documentation content

Note: Documentation provides context, best practices, and guidelines that help agents make better decisions. Agents should reference these docs when relevant to their tasks.

Remove this instruction block and replace with actual verified documentation.]
EOF

echo "✅ Agent file $(if [ "$UPDATE_MODE" = true ]; then echo "updated"; else echo "created"; fi) successfully!"

if [ "$UPDATE_MODE" = true ]; then
    echo ""
    echo "🔄 Summary of update:"
    echo "  - Updated description to single-line format"
    echo "  - All other content preserved"
    echo "  - Backup created at ${AGENT_FILE}.bak"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ SUCCESS: Agent file operation completed!"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📋 Summary:"
echo "  - Agent: $TOPIC:$AGENT_NAME"
echo "  - File: $AGENT_FILE"
echo "  - Type: $SCOPE"
echo "  - Topic: $TOPIC"
echo ""
if [ "$UPDATE_MODE" = false ]; then
    echo "🎯 Next Steps:"
    echo "  1. Review and customize the generated agent file"
    echo "  2. Replace the placeholder system prompt with specific content"
    echo "  3. Verify and update the Useful Commands section"
    echo "  4. Add relevant documentation references"
    echo "  5. Commit changes when satisfied with the agent configuration"
fi
```

## Directory Structure

### User Agents (Deployed Structure)
```
~/.claude/agents/
├── security-auditor.md          # Flat agent (general topic, no prefix)
├── code-formatter.md             # Flat agent (general topic, no prefix)
├── dev:release-notes-writer.md  # Development topic agent
├── dev:issue-tracker.md         # Development topic agent
├── git:pr-analyzer.md           # Git topic agent
├── git:commit-formatter.md      # Git topic agent
└── slack:message-formatter.md   # Slack topic agent
```

### Project Agents (Deployed Structure)
```
.claude/agents/
├── supabase:database-migrator.md      # Supabase topic agent
├── supabase:edge-function-tester.md   # Supabase topic agent
├── cloudflare:worker-optimizer.md     # Cloudflare topic agent
├── cloudflare:edge-function-validator.md # Cloudflare topic agent
├── vercel:serverless-optimizer.md     # Vercel topic agent
└── vercel:deployment-validator.md     # Vercel topic agent
```

## Agent File Template

Generated agents provide a minimal starting structure:

### Frontmatter Section
```yaml
---
name: topic:agent-name
description: |
  [The provided description text]
color: blue
---
```

### System Prompt Section
- **Opening Statement**: Basic purpose declaration
- **Customization Instructions**: Guidance for developing the agent
- **Useful Commands**: Critical section with verification requirements
  - Must verify commands exist in the appropriate directories
  - Must check argument structure from command files
  - Agents should proactively use these commands when appropriate

## Validation

The command validates:
- **Type**: Must be 'user' or 'project'
- **Topic**: Required, non-empty string
- **Agent Name**: Must follow kebab-case format
- **Name Length**: Maximum 30 characters recommended
- **File Updates**: Handles both creation and updates gracefully

## Error Handling

- **Missing Arguments**: Clear usage instructions with format examples
- **Invalid Format**: Explains type:topic format with examples
- **Invalid Type**: Must be 'user' or 'project'
- **Invalid Topic**: Must be non-empty
- **Update Detection**: Automatically detects existing agents and updates them

## Notes

- **Topic-Based File Naming**:
  - Agents deploy as flat files with topic-prefixed names
  - User agents: `~/.claude/agents/{topic}:{agent-name}.md`
  - Project agents: `.claude/agents/{topic}:{agent-name}.md`
  - Exception: `general` topic agents deploy without prefix (e.g., `security-auditor.md`)
- **Agent Deployment**:
  - User agents with topics deploy as `{topic}:{agent-name}.md`
  - Flat user agents (general topic) deploy without topic prefix
  - Project agents deploy with topic prefix to project `.claude/agents/`
- **Naming Conventions**:
  - Agent names must be kebab-case (lowercase with hyphens)
  - Maximum 30 characters recommended
  - No auto-generation from description - explicit naming required
- **Guidelines Compliance**: Follows all patterns from `.claude/docs/agent-complex/claude-agent-file-rules.md` including documentation references
- **Directory Creation**: Creates necessary topic directories automatically
- **Template Quality**: Provides professional template with topic-aware content
- **Customization**: Generated file serves as starting point for enhancement

## Common Execution Errors and Solutions

### Error: "./~/.claude/commands/agent-complex/update-agent: No such file or directory"
**Cause**: Attempting to execute the .md file directly as a script
**Solution**: Use Claude's slash command invocation: `/agent-complex:update-agent <args>`

### Error: "conditional binary operator expected"
**Cause**: Bash syntax incompatibility in conditional statements
**Solution**: Fixed in v2.3.0 - uses POSIX-compliant conditional syntax

### Error: "File does not exist: claude-agent-file.md"
**Cause**: Incorrect guidelines filename reference
**Solution**: Fixed in v2.3.0 - corrected to `claude-agents-file.md`