# Args: `<type:topic>` `<command-name>` `<description>`. v2.1.0. Create or update user and project command files with proper structure and configuration.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-command` in bash.

## Summary

Creates or updates Claude command files with proper structure and configuration following the comprehensive guidelines in **`.claude/docs/agent-complex/claude-command-file-rules.md`** - the authoritative source for command file standards. Supports topic-based organization for both user-level commands (`~/.claude/commands/{topic}/`) and project-specific commands (`.claude/commands/{topic}/`). 

The command automatically applies appropriate templates:
- **Regular commands**: Uses `.claude/docs/agent-complex/regular-command-template.md`
- **Meta-commands** (with `run-*` prefix): Uses `.claude/docs/agent-complex/meta-command-template.md` following `.claude/docs/agent-complex/claude-meta-command-file-rules.md`

This command focuses solely on command file creation and does not manage git workflows.

## Command Execution

This command directly creates or updates command files without managing git workflows. Users should handle branch creation and PR management separately.

## Usage

```bash
/agent-complex:update-command <type:topic> <command-name> "<description>"
```

## Arguments

- `<type:topic>`: Command type and topic combined (REQUIRED)
  - Format: `type:topic` where:
    - `type` is either `user`, `project`, or `nexus`
    - `topic` is the category (e.g., `dev`, `git`, `slack`, `docs`, `security`, `tools`, `auth`, `database`)
  - Examples: `user:dev`, `project:supabase`, `user:git`, `nexus:auth`
  - `user` commands go to `~/.claude/commands/{topic}/`
  - `project` commands go to `.claude/commands/{topic}/`
  - `nexus` commands go to `.claude/commands/nexus/{topic}/`
- `<command-name>`: Name for the command file (REQUIRED)
  - Kebab-case format (lowercase with hyphens)
  - Should be descriptive but concise
  - For meta-commands (see `.claude/docs/agent-complex/claude-meta-command-file-rules.md`): MUST use `run-*` prefix (e.g., `run-deploy`, `run-design-dev`)
  - Regular commands: `execute-deployment`, `deploy-service`, `sync-database`
  - Maximum 40 characters recommended
- `<description>`: Purpose and functionality of the command (REQUIRED)
  - **MUST describe what the command does, NOT recent changes**
  - Brief description of the command's purpose and functionality
  - Will be used in the command header and system prompt
  - Quote if contains spaces
  - **❌ AVOID**: "Added X support", "Fixed Y issue", "Updated to use Z"
  - **✅ USE**: "Deploy application to production environment", "Create and configure feature branch"

## Path Configuration Table

**CRITICAL**: Understanding deployment paths and how commands reference components is essential:

| Component | Type | Deployment Path | How Command References |
|-----------|------|-----------------|------------------------|
| **User Commands** | Files | `~/.claude/commands/{topic}/` | `/{topic}:{command-name}` |
| **User Scripts** | Files | `~/.claude/scripts/{topic}/` | `~/.claude/scripts/{topic}/{command-name}_{operation}.*` |
| **User Docs** | References | `~/.claude/docs/{topic}/` | `` `~/.claude/docs/{topic}/{doc-name}.md` `` |
| **Project Commands** | Files | `<project-root>/.claude/commands/{topic}/` | `/{topic}:{command-name}` |
| **Project Scripts** | Files | `<project-root>/.claude/scripts/{topic}/` | `.claude/scripts/{topic}/{command-name}_{operation}.*` |
| **Project Docs** | References | `<project-root>/.claude/docs/{topic}/` | `` `.claude/docs/{topic}/{doc-name}.md` `` |
| **Nexus Commands** | Files | `<project-root>/.claude/commands/nexus/{topic}/` | `/nexus:{topic}:{command-name}` |
| **Nexus Scripts** | Files | `<project-root>/.claude/scripts/nexus/{topic}/` | `.claude/scripts/nexus/{topic}/{command-name}_{operation}.*` |
| **Nexus Docs** | References | `<project-root>/.claude/docs/nexus/{topic}/` | `` `.claude/docs/nexus/{topic}/{doc-name}.md` `` |

### Key Points:
- **Implementation Environment**: Files are implemented directly in the deployment/destination paths
- **In Command Files**: 
  - User commands reference scripts at `~/.claude/scripts/{topic}/{command-name}_{operation}.*`
  - Project commands reference scripts at `.claude/scripts/{topic}/{command-name}_{operation}.*` (relative to project root)
- **Documentation References**:
  - User docs: `~/.claude/docs/{topic}/`
  - Project docs: `.claude/docs/{topic}/` (relative to project root)
- **Script Integration**: All commands should leverage scripts for atomic operations when beneficial

## Examples

```bash
# Create user command in dev topic
/agent-complex:update-command user:dev execute-deployment "Deploy application to production environment"
# Creates: ~/.claude/commands/dev/execute-deployment.md

# Create user command in git topic
/agent-complex:update-command user:git create-hotfix "Create and manage hotfix branches"
# Creates: ~/.claude/commands/git/create-hotfix.md

# Create user command in tools topic
/agent-complex:update-command user:tools config-database "Configure database connections and settings"
# Creates: ~/.claude/commands/tools/config-database.md

# Create project command in supabase topic
/agent-complex:update-command project:supabase deploy-edge-function "Deploy and manage Supabase edge functions"
# Creates: .claude/commands/supabase/deploy-edge-function.md

# Create project command in cloudflare topic
/agent-complex:update-command project:cloudflare deploy-worker "Deploy and configure Cloudflare Workers"
# Creates: .claude/commands/cloudflare/deploy-worker.md

# Create meta-command (following `.claude/docs/agent-complex/claude-meta-command-file-rules.md`) in figma-make topic
/agent-complex:update-command project:figma-make run-design-dev "Run design-to-implementation workflow with configurable steps"
# Creates: .claude/commands/figma-make/run-design-dev.md

# Create meta-command (following `.claude/docs/agent-complex/claude-meta-command-file-rules.md`) in dev topic
/agent-complex:update-command user:dev run-full-deployment "Orchestrate complete deployment workflow with pre-checks and validation"
# Creates: ~/.claude/commands/dev/run-full-deployment.md

# Create nexus command in auth topic
/agent-complex:update-command nexus:auth setup-authentication "Configure authentication workflows and patterns"
# Creates: .claude/commands/nexus/auth/setup-authentication.md
```

## What This Command Does

### 1. Validate Arguments
- Validates type:topic format (e.g., user:dev, project:supabase)
- Validates type is either 'user' or 'project'
- Validates topic is provided (non-empty)
- Validates command-name follows kebab-case format

### 2. Generate Command Configuration
- Uses provided command-name directly (no auto-generation)
- Generates comprehensive command file structure following **`.claude/docs/agent-complex/claude-command-file-rules.md`**
- Applies appropriate template:
  - Regular commands: `.claude/docs/agent-complex/regular-command-template.md`
  - Meta-commands: `.claude/docs/agent-complex/meta-command-template.md`
- Creates template with proper header format and sections
- Includes critical instructions about argument handling and validation
- Determines appropriate file location based on type and topic

### 3. Create Command File
- User commands:
  - Commands → `~/.claude/commands/{topic}/{command-name}.md`
  - Scripts → `~/.claude/scripts/{topic}/{command-name}_{operation}.*` with topic-organized naming
- Project commands:
  - Commands → `<project-root>/.claude/commands/{topic}/{command-name}.md`
  - Scripts → `<project-root>/.claude/scripts/{topic}/{command-name}_{operation}.*` with topic-organized naming
- Places command in topic-based directory structure
- Ensures proper header formatting with Args line per **`.claude/docs/agent-complex/claude-command-file-rules.md`**
- Includes comprehensive sections from standardized templates
- Adds script integration patterns and performance optimization guidance



## Usage Notes

### Direct File Operations

This command focuses solely on creating or updating command files:

1. **Command File Creation**: Creates the command file with proper configuration
2. **Update Detection**: Automatically detects if command exists and updates appropriately
3. **Template Generation**: Provides comprehensive template for new commands
4. **Path Management**: Handles topic-based directory structure automatically

### Git Workflow Management

Users should manage git workflows separately:
- Create feature branches manually using standard git commands
- Commit changes after reviewing the generated command file
- Create PRs using standard git workflow commands

## Implementation

The main implementation is located in the external script `.claude/scripts/agent-complex/update-command_main.sh` when deployed.

```bash
# Path resolution for the main script
# User script location: ~/.claude/scripts/agent-complex/update-command_main.sh
# Project script location: .claude/scripts/agent-complex/update-command_main.sh
# Storage/sync location: ~/.claude/scripts/agent-complex/update-command_main.sh

#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "📝 UPDATE-COMMAND v2.1.0"
echo "This command will create or update a command file with proper configuration."
echo "Note: Git workflow management (branches, commits, PRs) should be handled separately."
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 3 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:update-command <type:topic> <command-name> \"<description>\""
    echo "  type:topic: Combined type and topic (e.g., user:dev, project:supabase)"
    echo "  command-name: Name for the command (kebab-case)"
    echo "  description: Purpose and functionality of the command"
    exit 1
fi

TYPE_TOPIC="$1"
COMMAND_NAME="$2"
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
    echo "Examples: dev, git, slack, docs, security, tools"
    exit 1
fi

# Validate command name format (kebab-case)
if ! [[ "$COMMAND_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "❌ Error: Invalid command name format"
    echo "Command name must be kebab-case (lowercase letters, numbers, and hyphens)"
    echo "Examples: execute-deployment, deploy-service, sync-database"
    exit 1
fi

# Validate command name length
if [ ${#COMMAND_NAME} -gt 40 ]; then
    echo "❌ Error: Command name too long (${#COMMAND_NAME} characters)"
    echo "Maximum 40 characters recommended"
    exit 1
fi

# Determine if this is a meta-command
IS_META_COMMAND=false
if [[ "$COMMAND_NAME" =~ ^run-.+ ]]; then
    IS_META_COMMAND=true
    echo "🎭 Detected meta-command (run-* prefix)"
fi

# Step 1: Determine destination directory and create command file
echo ""
echo "📌 Creating command file in destination environment..."
echo "───────────────────────────────────────"

# Determine destination directory based on type and topic
# Files are developed directly in the deployment/destination paths
if [ "$TYPE" = "user" ]; then
    # User commands go to user home deployment location
    TARGET_DIR="~/.claude/commands/$TOPIC"
    SCOPE="user-level ($TOPIC topic)"
    DEPLOYED_PATH="~/.claude/commands/$TOPIC/$COMMAND_NAME.md"
elif [ "$TYPE" = "project" ]; then
    # Project commands go to project-relative deployment location
    TARGET_DIR=".claude/commands/$TOPIC"
    SCOPE="project-specific ($TOPIC topic)"
    DEPLOYED_PATH=".claude/commands/$TOPIC/$COMMAND_NAME.md"
elif [ "$TYPE" = "nexus" ]; then
    # Nexus commands go to nexus namespace in project
    TARGET_DIR=".claude/commands/nexus/$TOPIC"
    SCOPE="nexus ($TOPIC topic)"
    DEPLOYED_PATH=".claude/commands/nexus/$TOPIC/$COMMAND_NAME.md"
fi

# Create destination directory
mkdir -p "$TARGET_DIR"

# Define command file path (in destination location)
COMMAND_FILE="$TARGET_DIR/$COMMAND_NAME.md"

# Check if command already exists
if [ -f "$COMMAND_FILE" ]; then
    echo "📝 Command already exists: $COMMAND_FILE"
    echo "🔄 Updating existing command..."
    
    # Backup the existing file
    cp "$COMMAND_FILE" "${COMMAND_FILE}.bak"
    
    UPDATE_MODE=true
else
    echo "📝 Creating new command: $COMMAND_NAME"
    UPDATE_MODE=false
fi

echo "📁 Location: $COMMAND_FILE"

# Generate command file content
if [ "$UPDATE_MODE" = true ]; then
    # For updates, extract existing args and version
    EXISTING_HEADER=$(head -1 "$COMMAND_FILE")
    EXISTING_ARGS=$(echo "$EXISTING_HEADER" | sed -n 's/^# Args: \(.*\)\. v[0-9]\+\.[0-9]\+\.[0-9]\+\..*/\1/p')
    EXISTING_VERSION=$(echo "$EXISTING_HEADER" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "v0.0.0")
    
    # Preserve existing args if found, otherwise keep as-is
    if [ -z "$EXISTING_ARGS" ]; then
        # If we can't parse the args, preserve the entire header except description
        echo "⚠️ Warning: Could not parse existing args format. Preserving original header structure."
        EXISTING_ARGS="\`<args>\`"  # Fallback only if we truly can't parse
    fi
    
    # Determine version bump based on description changes
    # For description-only updates, bump patch version
    NEW_VERSION=$(echo "$EXISTING_VERSION" | awk -F. '{print $1"."$2"."$3+1}')
    
    # Update header preserving args but updating version and description
    sed -i "1s/.*/# Args: $EXISTING_ARGS. $NEW_VERSION. $DESCRIPTION/" "$COMMAND_FILE"
    
    echo "✅ Command file updated successfully!"
    echo "  - Updated version: $EXISTING_VERSION → $NEW_VERSION"
    echo "  - Preserved existing args: $EXISTING_ARGS"
    echo "  - Updated description: $DESCRIPTION"
    echo "  - Backup created at ${COMMAND_FILE}.bak"
else
    # Create new command file
    # Templates are fully documented in separate files:
    # - Regular: .claude/docs/agent-complex/regular-command-template.md
    # - Meta: .claude/docs/agent-complex/meta-command-template.md
    
    # Determine which template to use (from destination environment)
    if [ "$IS_META_COMMAND" = true ]; then
        # Templates are in user home for user commands, project-relative for project commands
        if [ "$TYPE" = "user" ]; then
            TEMPLATE_FILE=".claude/docs/agent-complex/meta-command-template.md"
        else
            TEMPLATE_FILE=".claude/docs/agent-complex/meta-command-template.md"
        fi
        echo "📋 Using meta-command template from: $TEMPLATE_FILE"
    else
        if [ "$TYPE" = "user" ]; then
            TEMPLATE_FILE=".claude/docs/agent-complex/regular-command-template.md"
        else
            TEMPLATE_FILE=".claude/docs/agent-complex/regular-command-template.md"
        fi
        echo "📋 Using regular command template from: $TEMPLATE_FILE"
    fi
    
    # Extract template content from the template file
    # The template is between the markdown code block markers
    TEMPLATE_CONTENT=$(sed -n '/^```markdown$/,/^```$/p' "$TEMPLATE_FILE" 2>/dev/null | sed '1d;$d' || echo "")
    
    if [ -z "$TEMPLATE_CONTENT" ]; then
        echo "⚠️ Template file not found or empty. Using fallback basic template..."
        cat > "$COMMAND_FILE" << 'EOF'
# Args: \`<arg1>\` \`[arg2]\`. v0.1.0. DESCRIPTION_PLACEHOLDER

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/COMMAND_NAME_PLACEHOLDER` in bash.

## Summary

[Provide a comprehensive summary of what this command does]

## Usage

\`\`\`bash
/TOPIC_PLACEHOLDER:COMMAND_NAME_PLACEHOLDER <args>
\`\`\`

## Arguments

- \`<arg1>\`: Description of first argument (REQUIRED/OPTIONAL)

## Implementation

\`\`\`bash
#!/bin/bash
set -euo pipefail

echo "Command implementation"
\`\`\`

## Notes

- See \`.claude/docs/agent-complex/claude-command-file-rules.md\` for comprehensive guidelines
- See \`.claude/docs/agent-complex/regular-command-template.md\` or \`.claude/docs/agent-complex/meta-command-template.md\` for full template
EOF
    else
        # Write the extracted template content to the command file
        echo "$TEMPLATE_CONTENT" > "$COMMAND_FILE"
    fi
    
    # Replace placeholders
    sed -i "s/DESCRIPTION_PLACEHOLDER/$DESCRIPTION/g" "$COMMAND_FILE"
    sed -i "s/COMMAND_NAME_PLACEHOLDER/$COMMAND_NAME/g" "$COMMAND_FILE"
    sed -i "s/TOPIC_PLACEHOLDER/$TOPIC/g" "$COMMAND_FILE"
    
    echo "✅ Command file created successfully!"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ SUCCESS: Command file operation completed!"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📋 Summary:"
echo "  - Command: $TOPIC:$COMMAND_NAME"
echo "  - File: $COMMAND_FILE"
echo "  - Type: $SCOPE"
echo "  - Topic: $TOPIC"
if [ "$IS_META_COMMAND" = true ]; then
    echo "  - Meta-command: Yes (orchestrates other commands)"
fi
echo ""
if [ "$UPDATE_MODE" = false ]; then
    echo "🎯 Next Steps:"
    echo "  1. 🔴 CRITICAL: Update the Args line with proper argument names (not generic <arg1>)"
    echo "  2. Review and customize the generated command file"
    echo "  3. Update argument descriptions and examples to match your specific args"
    echo "  4. Implement the command logic"
    echo "  5. Add error handling and validation"
    echo "  6. Commit changes when satisfied with the command"
    echo ""
    echo "  ⚠️ Remember: Replace generic <arg1> [arg2] with actual argument names like:"
    echo "     - <pr-number> for PR operations"
    echo "     - <branch> [option] for branch operations"
    echo "     - <file-path> <pattern> for search operations"
fi

```

## Directory Structure

### Destination Environment Structure

The destination directory structure follows a consistent pattern organized by topics. Each deployment can have different topics based on specific needs.

**User Environment** (in user home directory):
```
~/.claude/
├── agents/                      # Agent definitions
│   └── {topic}:{agent-name}.md  # Agent files with topic prefix
├── commands/                    # Command files
│   └── {topic}/                 # Topic-organized commands
│       └── {command-name}.md    # Individual command files
├── scripts/                     # Supporting scripts
│   └── {topic}/                 # Topic-organized scripts
│       └── {command-name}_{operation}.*  # Command-specific scripts
└── docs/                        # Documentation
    └── {topic}/                 # Topic-organized documentation
        └── {doc-name}.md        # Individual documentation files
```

**Project Environment** (in project root directory):
```
.claude/
├── agents/                      # Project-specific agents
│   └── {topic}:{agent-name}.md  # Agent files with topic prefix
├── commands/                    # Project-specific commands
│   └── {topic}/                 # Topic-organized commands
│       └── {command-name}.md    # Individual command files
├── scripts/                     # Project-specific scripts
│   └── {topic}/                 # Topic-organized scripts
│       └── {command-name}_{operation}.*  # Command-specific scripts
└── docs/                        # Project-specific documentation
    └── {topic}/                 # Topic-organized documentation
        └── {doc-name}.md        # Individual documentation files
```

**Key Notes**:
- `{topic}` represents functional categories (e.g., `dev`, `git`, `slack`, `tools`, `security`, `testing`, `deployment`)
- Commands are invoked as `/{topic}:{command-name}`
- Agents are named as `{topic}:{agent-name}.md` files (flat structure in agents/)
- Scripts follow the naming pattern `{command-name}_{operation}.*` for modularity
- User environment uses `~/` while project environment uses relative paths

### Key Characteristics of Destination Structure:

1. **Separate Locations**: 
   - User commands: `~/.claude/commands/{topic}/` (user home directory)
   - Project commands: `.claude/commands/{topic}/` (project root directory)
2. **Topic Organization**: Commands organized by functional topic/domain
3. **Direct Execution Path**: Commands are invoked as `/{topic}:{command-name}`
4. **Clear Scope Separation**: User-level commands isolated from project-specific commands

### Storage Structure (Sync Source Only)

The storage structure maintains separation for sync management but is not used for execution:

```
# User commands (synced to ~/.claude/commands/{topic}/)
~/.claude/commands/{topic}/

# Project commands (synced to .claude/commands/{topic}/)
.claude/commands/{topic}/
```

**Note**: The storage structure is only relevant for:
- Version control organization
- Sync script operations
- Backup purposes

## Command File Templates

**IMPORTANT**: All generated templates follow the comprehensive guidelines in **`.claude/docs/agent-complex/claude-command-file-rules.md`**.

This command uses two standardized templates that are fully documented:
- **`.claude/docs/agent-complex/regular-command-template.md`** - For standard commands
- **`.claude/docs/agent-complex/meta-command-template.md`** - For orchestrator commands with `run-*` prefix

Generated commands provide a comprehensive starting structure:

### Header Section
```markdown
# Args: `<arg1>` `<arg2>` `[optional-arg]`. v1.0.0. Description
```

**🚨 CRITICAL WARNING: DESCRIPTION MUST DESCRIBE COMMAND PURPOSE**
- **DO NOT use recent updates in description**: "Added support for X", "Fixed Y", "Updated to use Z"
- **DO use timeless functional description**: "Deploy application to environment", "Create feature branch"
- **The description tells users WHAT THE COMMAND DOES, not what was recently changed**
- **Examples**:
  - ❌ WRONG: "Added remove option support"
  - ✅ CORRECT: "Update and sync git branch with remote"

### Core Sections
- **Summary**: Comprehensive overview
- **Usage**: Command invocation examples
- **Arguments**: Detailed argument descriptions
- **Examples**: Multiple usage scenarios
- **What This Command Does**: Detailed functionality explanation
- **Script Integration**: Performance optimization patterns
- **Agent References**: Standardized agent invocation patterns using `@agent-` prefix
- **Requirements**: Dependencies and prerequisites
- **Error Handling**: Common errors and solutions

### Meta-Command Specific Sections

For commands with the `run-*` prefix, the template additionally includes:

- **Basic Meta-Command Workflow**: Standardized 3-step workflow pattern
  
  **CRITICAL**: All generated meta-commands follow this standardized workflow structure:
  
  1. **Create Feature Branch** 🚨 **MANDATORY FIRST STEP** 🚨
     ```bash
     # Create feature branch using standard git commands
     git checkout -b "feature/<feature-name>"
     ```
     
     **Requirements:**
     - Base branch MUST be `dev` (not main)
     - Feature name derived from command context or arguments
     - This step creates the proper branch foundation for all implementation work

  2. **Execute Command(s), Agent(s), or Mixed Operations** 🚨 **CORE WORKFLOW EXECUTION** 🚨
     
     **Choose the appropriate execution pattern:**
     
     **Option A: Command-Only Execution**
     ```bash
     # Execute one or more specialized commands
     Task tool: "/analyze-codebase <project-path>"
     Task tool: "/optimize-performance <component-path>"
     ```
     
     **Option B: Agent-Only Execution**
     ```bash
     # Delegate to specialized agents
     Task tool: "@agent-design-system - Apply design patterns to components"
     Task tool: "@agent-security-audit - Review authentication flow"
     ```
     
     **Option C: Mixed Command + Agent Execution**
     ```bash
     # Combine commands and agents for complex workflows
     Task tool: "/setup-database-schema <schema-file>"
     Task tool: "@agent-data-migration - Migrate user data safely"
     Task tool: "/deploy-backend <environment>"
     ```

  3. **Quality Assurance Validation** 🚨 **MANDATORY QA STEP** 🚨
     ```bash
     # Run check-paths for QA validation before PR creation
     Task tool: "/agent-complex:check-paths user \"Files updated by command operation\""
     ```
     
     **Requirements:**
     - Validates all file path references are deployment-ready
     - Ensures script paths, documentation paths follow conventions
     - Blocks PR creation if validation fails
     - Required for all file updates before proceeding to PR

  4. **Create Pull Request** 🚨 **MANDATORY FINAL STEP** 🚨
     ```bash
     # Create PR with dev as target branch (only if QA validation passes)
     Task tool: "/dev:create-pr"
     ```
     
     **Requirements:**
     - Target branch MUST be `dev` (matching the base branch from step 1)
     - PR creation includes issue linking and proper metadata
     - Only proceed if QA validation from step 3 passes
     - This completes the implementation workflow cycle

- **Flag Reference Table**: Comprehensive table documenting all flags
  ```markdown
  | Flag | Description | Triggers | Execution Mode | Dependencies |
  |------|-------------|----------|----------------|--------------|
  | `--config` | Configure settings | `/configure` command | Serial | None |
  | `--deploy` | Deploy application | `/deploy-backend` + `/deploy-frontend` | Serial | `--test` |
  | `--full` | Complete workflow | All of the above | Mixed | None |
  ```

- **Flag-Based Routing**: Implementation patterns for flag handling
  ```bash
  if [[ "$FLAGS" == *"--config"* ]]; then
      /configure-settings $PROJECT_NAME
  fi
  ```

- **Dependency Validation**: Checks for flag dependencies
  ```bash
  if [[ "$FLAGS" == *"--deploy"* ]] && [[ "$FLAGS" != *"--test"* ]]; then
      echo "❌ Error: --deploy requires --test flag"
      exit 1
  fi
  ```

- **Mixed Execution Patterns**: Documentation of serial vs parallel execution
  - Commands can trigger one or more commands
  - Commands can trigger a mix of commands and agents
  - Commands can trigger one or more agents
  - Indicates which flags run independently vs dependently

## Agent Reference Standards

**🚨 CRITICAL: All generated command files include standardized agent reference patterns using the `@agent-` prefix.**

All command templates generated by this command automatically include proper agent reference formatting following the standards documented in `.claude/docs/agent-complex/claude-command-file-rules.md`:

### Agent Reference Examples in Generated Templates

**✅ CORRECT: Standardized agent references**
```bash
# Single agent invocation
Task tool: "@agent-code-reviewer" with task: "Review PR changes for quality"

# Domain-specific agent invocation  
Task tool: "@agent-figma-make:design-dev" with prompt: "Create responsive design system"

# Multiple parallel agent invocations
- Task tool: "@agent-security-auditor" with task: "Scan for vulnerabilities"
- Task tool: "@agent-performance-optimizer" with task: "Analyze performance bottlenecks"
- Task tool: "@agent-test-engineer" with task: "Generate comprehensive test suite"
```

**❌ INCORRECT: Missing @agent- prefix**
```bash
# These patterns will NOT be used in generated templates
Task tool: "code-reviewer" with task: "Review PR changes"
Task tool: "figma-make:design-dev" with prompt: "Create design"
```

### Agent Reference Formatting Rules Applied

Generated command files follow these standardization rules:

1. **Prefix Requirement**: All agent references use `@agent-` prefix
2. **Domain Agents**: Format `@agent-{domain}:{agent-name}` for specialized domain agents
   - Examples: `@agent-figma-make:design-dev`, `@agent-supabase:edge-functions`
3. **General Agents**: Format `@agent-{agent-name}` for general-purpose agents
   - Examples: `@agent-code-reviewer`, `@agent-security-auditor`
4. **Documentation**: Agent references in documentation sections use the same format
5. **Consistency**: Same format used throughout all generated sections

### Meta-Command Agent Integration

For meta-commands (following `.claude/docs/agent-complex/claude-meta-command-file-rules.md`) with `run-*` prefix, agent references in flag tables use the standardized format:

```markdown
| Flag | Description | Triggers | Execution Mode | Dependencies |
|------|-------------|----------|----------------|--------------|
| `--review` | Code review | `@agent-code-reviewer` | Parallel | None |
| `--security` | Security audit | `@agent-security-auditor` | Parallel | `--review` |
| `--optimize` | Performance optimization | `@agent-performance-optimizer` + `/optimize-script` | Mixed | `--review` |
```

This ensures all generated command files follow the repository's agent reference standards from creation.

## Validation

The command validates:
- **Type**: Must be 'user' or 'project'
- **Topic**: Required, non-empty string
- **Command Name**: Must follow kebab-case format
- **Meta-Command Naming**: Commands starting with `run-` are treated as meta-commands
- **Name Length**: Maximum 40 characters recommended
- **Git Repository**: Must be run in a git repository
- **File Updates**: Handles both creation and updates gracefully

## Error Handling

- **Missing Arguments**: Clear usage instructions with format examples
- **Invalid Format**: Explains type:topic format with examples
- **Invalid Type**: Must be 'user' or 'project'
- **Missing Git**: Requires git repository context
- **Invalid Topic**: Must be non-empty
- **Update Validation**: Ensures proper file format for updates

## Version History

- **v2.1.0** - Destination environment implementation:
  - Commands now created directly in destination paths (not storage paths)
  - User commands use ~/.claude/ paths (user home directory)
  - Project commands use .claude/ paths (project-relative)
  - Updated directory detection to use destination environment
  - Template files loaded from appropriate destination paths
  - Clear separation between user-level and project-specific locations
  - Removed obsolete Directory Structure Management section
  - Enhanced Directory Structure documentation with destination focus

- **v2.0.1** - Fixed argument and version handling:
  - Preserves existing args when updating commands (no more generic `<args>` replacement)
  - Uses v0.1.0 as initial version for new commands (following semver best practices)
  - Updated templates to use descriptive placeholders instead of generic `<args>`
  - Added warnings to customize args for new commands
  - Improved version extraction and preservation logic

- **v2.0.0** - Major refactor for topic-based organization:
  - Restructured for topic-based directory structure
  - Removed git workflow management (now handled separately)
  - Simplified to focus on command file operations only
  - Added support for meta-command templates

## Notes

- **Destination Environment Development**:
  - Commands are created directly in deployment paths
  - User commands: `~/.claude/commands/{topic}/{command-name}.md`
  - Project commands: `.claude/commands/{topic}/{command-name}.md`
- **Storage/Sync Locations**:
  - User storage: `~/.claude/commands/{topic}/` (for sync purposes only)
  - Project storage: `.claude/commands/{topic}/` (for sync purposes only)
- **Naming Conventions**:
  - Command names must be kebab-case (lowercase with hyphens)
  - Meta-commands (see `.claude/docs/agent-complex/claude-meta-command-file-rules.md`) MUST use `run-*` prefix (e.g., `run-deploy`, `run-design-dev`)
  - Maximum 40 characters recommended
  - Should be descriptive and action-oriented
- **Meta-Command Features**:
  - Automatically generates flag reference table template
  - Includes flag-based routing patterns
  - Provides dependency validation examples
  - Documents serial vs parallel execution modes
  - Supports mixed command and agent orchestration
- **Guidelines Compliance**: Strictly follows all patterns from **`.claude/docs/agent-complex/claude-command-file-rules.md`** - the authoritative documentation
- **Template Quality**: Provides comprehensive template following best practices
- **Script Integration**: Includes patterns for script-enhanced execution
- **Create vs Update**: Intelligently handles both new command creation and existing command updates

## Essential Documentation References

**🚨 MUST READ**: These documents are essential for understanding command file implementation:

### Core Guidelines
- **`.claude/docs/agent-complex/claude-command-file-rules.md`** - The authoritative source for ALL command file standards
  - Command structure and sections
  - Script integration patterns
  - Performance optimization
  - Topic-based organization

### Templates
- **`.claude/docs/agent-complex/regular-command-template.md`** - Template for standard commands
  - Used automatically for non-meta commands
  - Includes all required sections
  - Placeholder documentation

- **`.claude/docs/agent-complex/meta-command-template.md`** - Template for orchestrator commands
  - Used for commands with `run-*` prefix
  - Flag reference table structure
  - Workflow orchestration patterns

### Specialized Guidelines
- **`.claude/docs/agent-complex/claude-meta-command-file-rules.md`** - Additional rules for meta-commands
  - Flag-based routing
  - Dependency management
  - Execution modes

