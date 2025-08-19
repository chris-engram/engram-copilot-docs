# Args: `<base-branch>` `[--config]` `[--philosophy]` `[--colors]` `[--screenflow]` `[--wireframes]` `[--prompt]` `[custom-instructions]`. v1.8.0. Added --wireframes flag for screenflows-wireframes.md documentation enhancement with embedded image examples

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/run-design-dev` in bash.

## Summary

**Meta-command** that orchestrates the complete design-dev workflow for Figma Make projects following the standard meta-command pattern. This command coordinates multiple operations including feature branch creation, optional design folder configuration, design-dev agent invocation with flag-based routing, and automated pull request creation. It provides a single entry point for complex design-to-development workflows while maintaining clear separation of concerns and ensuring proper integration with the development pipeline.

## Usage

```bash
/design:run-design-dev <base-branch> [options] [custom-instructions]
```

## Arguments

- `<base-branch>`: The branch to base the feature branch on (REQUIRED)
  - Examples: `main`, `dev`, `develop`, `release/v2.0`
  - This determines where changes will be branched from

### Options

- `--config`: Setup design folder structure (OPTIONAL)
  - When enabled, executes `/design:config-designs` command to create the foundational designs/ directory structure
  - Creates: designs/, designs/prototypes/, designs/screen-flows/ with README navigation files
  - Example: `--config`

- `--philosophy`: Request design philosophy guidance (OPTIONAL)
  - Prompts the agent to provide design philosophy and principles
  - **CLARIFICATION**: The agent will run the `/design:update-design-philosophy` command
  - Example: `--philosophy`

- `--colors`: Update color system and design tokens (OPTIONAL)
  - Prompts the `@agent-design:design-dev` to run the `/design:update-color-system` command
  - **Storage Location**: All color system content is generated and stored in `designs/colors/` directory
  - **Primary Output**: Creates COLOR-SYSTEM.md with embedded swatch palette images in `designs/colors/`
  - **Archiving**: Previous versions automatically archived in `designs/colors/archive/`
  - Example: `--colors`

- `--screenflow`: Request screen flow analysis with Dashboard Wireframe (SVG) as primary method (OPTIONAL)
  - Prompts the `@agent-design:screenflow-dev` agent to analyze and create screen flow specifications
  - **PRIMARY METHOD**: Uses Dashboard Wireframe (SVG) files for individual screen documentation
  - **ENHANCED CAPABILITIES**: Multi-screen storyboarding with embedded example images
  - **COMMAND EXECUTION**: The agent will run the `/design:update-screenflows` command with SVG-first workflow
  - **🔒 IMAGE VALIDATION**: Enforces embedded images (relative paths) and prevents hyperlinked images (external URLs)
  - **DOCUMENTATION**: References enhanced `ubuntu-vm/project/design/docs/screenflows-storyboarding.md` and `ubuntu-vm/project/design/docs/screenflows-wireframes.md`
  - **OUTPUT**: Creates wireframes/ directory with GitHub-compatible SVG wireframes
  - Example: `--screenflow`

- `--wireframes`: Update wireframes documentation with embedded image examples (OPTIONAL)
  - Prompts the `@agent-design:design-dev` agent to enhance screenflows-wireframes.md documentation
  - **COMMAND EXECUTION**: The agent will run the `/design:update-wireframes-documentation` command
  - **TARGET**: Updates `ubuntu-vm/project/design/docs/screenflows-wireframes.md` with embedded image examples
  - **PATTERN REFERENCE**: Follows successful embedded image patterns from `screenflows-storyboarding.md`
  - **🔒 IMAGE VALIDATION**: Enforces embedded images (relative paths) and prevents hyperlinked images (external URLs)
  - **EXAMPLES INTEGRATION**: Uses existing SVG files from `examples/` directory for embedded references
  - **GITHUB COMPATIBILITY**: Ensures all images render properly in GitHub markdown
  - Example: `--wireframes`

- `--prompt`: Add custom instructions (OPTIONAL)
  - Prompts the agent with additional custom instructions
  - Example: `--prompt`

- `[custom-instructions]`: Additional instructions without flags (OPTIONAL)
  - Any remaining arguments are treated as custom instructions
  - Can be used for quick, informal guidance
  - Example: `"Implement dark mode support"`

### Flag Execution Table

**CRITICAL**: This meta-command uses flag-based routing to determine execution flow. Each flag triggers specific operations:

| Flag | Description | Triggers | Execution Mode | Dependencies |
|------|-------------|----------|----------------|--------------|
| `--config` | Create designs folder structure | `/design:config-designs` command | Serial | None |
| `--philosophy` | Request design philosophy guidance | `@agent-design:design-dev` with philosophy prompt (runs `/design:update-design-philosophy`) | Agent | Requires feature branch |
| `--colors` | Update color system and design tokens | `@agent-design:design-dev` with colors prompt (runs `/design:update-color-system`) - **STORES in `designs/colors/`** | Agent | Requires feature branch |
| `--screenflow` | Request screen flow analysis with Dashboard Wireframe (SVG) primary method | `@agent-design:screenflow-dev` with screen flow prompt (runs `/design:update-screenflows` with SVG-first workflow + image validation) | Agent | Requires feature branch |
| `--wireframes` | Update wireframes documentation with embedded images | `@agent-design:design-dev` with wireframes prompt (runs `/design:update-wireframes-documentation`) | Agent | Requires feature branch |
| `--prompt` | Add custom instructions | `@agent-design:design-dev` with custom prompt | Agent | Requires feature branch |
| None | Base execution (no flags) | Feature branch creation only | Serial | None |

**Execution Patterns**:
- **Command-Only**: When only `--config` is provided, executes the command and exits
- **Agent-Only**: When any agent flag is provided, invokes the `@agent-design:design-dev` agent
- **Mixed**: When `--config` + agent flags are provided, executes command then invokes agent
- **Base**: When no flags are provided, only creates the feature branch

**🔴 CRITICAL FLAG EXECUTION PATTERNS**:

1. **Command-Only Flags** (e.g., `--config`):
   - Execute ONLY the specified command(s)
   - Do NOT invoke agents or perform additional activities
   - Example: `--config` runs `/design:config-designs` and stops

2. **Agent-Only Flags** (e.g., `--philosophy`, `--screenflow`, `--wireframes`, `--prompt`):
   - Invoke the agent with specific instructions
   - Agent performs ONLY the requested analysis/guidance
   - **IMPORTANT**: For `--philosophy` flag, the agent will run `/design:update-design-philosophy` command
   - **ENHANCED**: For `--screenflow` flag, the agent will run `/design:update-screenflows` command with Dashboard Wireframe (SVG) as primary method
   - **NEW**: For `--wireframes` flag, the agent will run `/design:update-wireframes-documentation` command to enhance screenflows-wireframes.md
   - Do NOT execute commands unless explicitly part of the agent's task

3. **Mixed Command+Agent Flags** (not present in this command):
   - Would execute commands first, then invoke agents
   - Each step remains discrete and purposeful

**⚠️ STRICT EXECUTION RULES**:
- If only `--config` is specified, ONLY execute the `/design:config-designs` command. Do not invoke the `@agent-design:design-dev` agent.
- If only `--philosophy` is specified, ONLY invoke the agent for design philosophy guidance. The agent will run `/design:update-design-philosophy` command as part of this guidance.
- If only `--screenflow` is specified, ONLY invoke the agent for screen flow analysis with Dashboard Wireframe (SVG) as primary method. Do not perform other design tasks.
- If only `--wireframes` is specified, ONLY invoke the agent for wireframes documentation enhancement. The agent will run `/design:update-wireframes-documentation` command to enhance screenflows-wireframes.md with embedded image examples.
- Multiple flags can be combined, but each flag's operation remains discrete and independent.
- The agent must NOT delegate or suggest additional activities beyond the selected flags.

## Examples

```bash
# Basic usage with base branch only
/design:run-design-dev main

# With configuration setup
/design:run-design-dev dev --config

# With philosophy and screen flow guidance
/design:run-design-dev main --philosophy --screenflow

# With wireframes documentation enhancement
/design:run-design-dev main --wireframes

# With custom prompt
/design:run-design-dev dev --prompt

# With multiple options and custom instructions
/design:run-design-dev main --config --philosophy "Focus on performance optimization"

# Enhanced wireframes and screenflow workflow
/design:run-design-dev dev --screenflow --wireframes

# Full example with all options
/design:run-design-dev dev --config --philosophy --screenflow --wireframes --prompt "Ensure accessibility compliance"
```

## Meta Command File Structure

This meta-command follows the established pattern for orchestrating complex workflows:

### Orchestration Flow
```
run-design-dev
├── Parse flags and arguments
├── Update branch (/git:update-branch)
├── Create feature branch (/git:create-feature-branch)
├── Route based on flags:
│   ├── --config → /design:config-designs
│   ├── --philosophy → @agent-design:design-dev (with context)
│   ├── --screenflow → @agent-design:screenflow-dev (with context)
│   ├── --wireframes → @agent-design:design-dev (with wireframes context)
│   └── --prompt → @agent-design:design-dev (with context)
└── Create pull request (/dev:create-pr)
```

### Command Delegation
- **Branch Update**: Delegates to `/git:update-branch`
- **Branch Management**: Delegates to `/git:create-feature-branch`
- **Configuration**: Delegates to `/design:config-designs`
- **Design Analysis**: Delegates to `@agent-design:design-dev` agent
- **PR Creation**: Delegates to `/dev:create-pr`

## What This Command Does

This meta-command orchestrates the complete design-to-development workflow following the standard meta-command pattern:

### 1. **Branch Update**
```bash
# First updates the current branch to ensure clean state
/git:update-branch
```

### 2. **Feature Branch Creation**
```bash
# Creates a timestamped feature branch after updating
/git:create-feature-branch <base-branch> design-dev-<timestamp>
```

### 3. **Configuration Setup** (when `--config` flag is used)
```bash
# Creates the designs folder structure
/design:config-designs
```

### 4. **Design-Dev Agent Invocation** (when agent flags are used)
```bash
# Invokes agent with contextual prompts based on flags
@agent-design:design-dev with:
  - Philosophy guidance (--philosophy)
  - Custom instructions (--prompt)
@agent-design:screenflow-dev with:
  - Screen flow analysis (--screenflow)
```

### 5. **Pull Request Creation** 🚨 **AUTOMATED PR CREATION** 🚨
```bash
# Creates PR to complete the workflow
/dev:create-pr <base-branch> "<generated-description>"
```

### 6. **Execution Modes**

Based on the flags provided, the command operates in distinct modes:

- **Command-Only Mode**: Executes specific commands without invoking agents
- **Agent-Only Mode**: Invokes the `@agent-design:design-dev` agent with specific instructions
- **Mixed Mode**: Executes commands first, then invokes agents
- **Base Mode**: Creates feature branch and PR when no flags are provided

### Detailed Process

#### 1. Argument Parsing and Validation
- Validates required base-branch argument
- Parses optional flags and categorizes them by type:
  - Command flags: `--config`
  - Agent flags: `--philosophy`, `--screenflow`, `--prompt`
- Determines execution mode based on flag combination
- Collects any remaining arguments as custom instructions

#### 2. Branch Update
```bash
# Updates the current branch to ensure clean working state
Task tool: "/git:update-branch"
```

#### 3. Feature Branch Creation
```bash
# Creates a feature branch after updating the current branch
Task tool: "/git:create-feature-branch $BASE_BRANCH design-dev-$(date +%Y%m%d-%H%M%S)"
```

#### 4. Mode-Based Execution

**Command-Only Mode**:
```bash
# Execute specific commands without agent invocation
Task tool: "/design:config-designs"
```

**Agent-Only or Mixed Mode**:
```bash
# Prepare context and invoke the appropriate agent
# For general design tasks:
Task tool with @agent-design:design-dev: "Assembled context prompt"
# For screenflow tasks:
Task tool with @agent-design:screenflow-dev: "Assembled screenflow context prompt"
```

#### 5. Pull Request Creation
```bash
# Always create PR to complete the workflow
Task tool: "/dev:create-pr $BASE_BRANCH \"$PR_BODY\""
```

The PR creation step:
- Summarizes all operations performed based on flags
- Links to the feature branch and base branch
- Provides a comprehensive description of changes
- Completes the standard meta-command workflow

## Implementation

```bash
# Validate arguments
if [[ $# -lt 1 ]]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /design:run-design-dev <base-branch> [options] [custom-instructions]"
    echo ""
    echo "Options:"
    echo "  --config              Configure project design settings"
    echo "  --philosophy          Request design philosophy guidance"
    echo "  --screenflow          Request screen flow analysis"
    echo "  --prompt              Add custom instructions"
    echo ""
    echo "Example: /design:run-design-dev main --config --screenflow"
    exit 1
fi

# Extract base branch
BASE_BRANCH="$1"
shift

# Initialize flag variables
CONFIG_FLAG=false
PHILOSOPHY_FLAG=false
COLORS_FLAG=false
SCREENFLOW_FLAG=false
PROMPT_FLAG=false
CUSTOM_INSTRUCTIONS=""

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --config)
            CONFIG_FLAG=true
            shift
            ;;
        --philosophy)
            PHILOSOPHY_FLAG=true
            shift
            ;;
        --colors)
            COLORS_FLAG=true
            shift
            ;;
        --screenflow)
            SCREENFLOW_FLAG=true
            shift
            ;;
        --prompt)
            PROMPT_FLAG=true
            shift
            ;;
        --*)
            echo "❌ Error: Unknown option: $1"
            echo "Valid options: --config, --philosophy, --colors, --screenflow, --prompt"
            exit 1
            ;;
        *)
            # Collect remaining arguments as custom instructions
            if [[ -z "$CUSTOM_INSTRUCTIONS" ]]; then
                CUSTOM_INSTRUCTIONS="$1"
            else
                CUSTOM_INSTRUCTIONS="$CUSTOM_INSTRUCTIONS $1"
            fi
            shift
            ;;
    esac
done

echo "🚀 Starting design-dev workflow..."
echo "📌 Base branch: $BASE_BRANCH"

# Display enabled flags
if [[ "$CONFIG_FLAG" == true ]]; then
    echo "📋 Config flag: enabled (will create designs folder structure)"
fi
if [[ "$PHILOSOPHY_FLAG" == true ]]; then
    echo "📖 Philosophy flag: enabled (will provide design philosophy guidance)"
fi
if [[ "$COLORS_FLAG" == true ]]; then
    echo "🎨 Colors flag: enabled (will update color system and design tokens)"
fi
if [[ "$SCREENFLOW_FLAG" == true ]]; then
    echo "🔄 Screenflow flag: enabled (will analyze screen flows)"
fi
if [[ "$PROMPT_FLAG" == true ]]; then
    echo "💬 Prompt flag: enabled (will add custom instructions)"
fi
if [[ -n "$CUSTOM_INSTRUCTIONS" ]]; then
    echo "📝 Custom instructions: $CUSTOM_INSTRUCTIONS"
fi

# Step 1: Update branch before feature creation
echo ""
echo "🔄 Updating branch before feature creation..."
echo "Executing: /git:update-branch"

# CLAUDE INSTRUCTION: Use Task tool to execute the update-branch command first
# Task tool: "/git:update-branch"

# Step 2: Create feature branch
echo ""
echo "🌿 Creating feature branch..."
FEATURE_NAME="design-dev-$(date +%Y%m%d-%H%M%S)"

# Use Task tool to create feature branch
echo "Executing: /git:create-feature-branch $BASE_BRANCH $FEATURE_NAME"

# CLAUDE INSTRUCTION: Use Task tool to execute the create-feature-branch command
# Task tool: "/git:create-feature-branch $BASE_BRANCH $FEATURE_NAME"

# Step 3: Prepare agent context
echo ""
echo "🎨 Preparing design-dev agent context..."

# Build comprehensive agent prompt with context
AGENT_PROMPT="You are being invoked through the run-design-dev command workflow. "
AGENT_PROMPT+="A feature branch has been created: $FEATURE_NAME. "
AGENT_PROMPT+="CRITICAL: You must STRICTLY follow ONLY the flags provided. Do NOT perform additional activities beyond what each flag specifies. "
AGENT_PROMPT+="Each flag has a discrete operation that must be executed independently:"
echo ""

# Add context based on enabled flags
CONFIG_ONLY=false
if [[ "$CONFIG_FLAG" == true ]]; then
    echo "📋 Config flag enabled - executing config-designs command"
    # Check if this is the only flag enabled
    if [[ "$PHILOSOPHY_FLAG" == false && "$COLORS_FLAG" == false && "$SCREENFLOW_FLAG" == false && "$PROMPT_FLAG" == false && -z "$CUSTOM_INSTRUCTIONS" ]]; then
        CONFIG_ONLY=true
        echo "🔴 Command-only execution: Will run /design:config-designs and exit"
    else
        AGENT_PROMPT+=" [--config FLAG]: First execute the /design:config-designs command to create the foundational designs folder structure."
    fi
fi

if [[ "$PHILOSOPHY_FLAG" == true ]]; then
    echo "📖 Philosophy flag enabled"
    AGENT_PROMPT+=" [--philosophy FLAG]: Provide ONLY design philosophy guidance, including design principles, best practices, and design standards. You will run the `/design:update-design-philosophy` command as part of this guidance."
fi

if [[ "$COLORS_FLAG" == true ]]; then
    echo "🎨 Colors flag enabled"
    AGENT_PROMPT+=" [--colors FLAG]: Update ONLY the color system and design tokens. You will run the `/design:update-color-system` command as part of this task. CRITICAL: All color system content MUST be stored in the designs/colors/ directory. The primary output is COLOR-SYSTEM.md with embedded swatch palette images located at designs/colors/COLOR-SYSTEM.md."
fi

if [[ "$SCREENFLOW_FLAG" == true ]]; then
    echo "🔄 Screenflow flag enabled with Dashboard Wireframe (SVG) as primary method"
    AGENT_PROMPT+=" [--screenflow FLAG]: Analyze and create ONLY screen flow specifications and documentation using Dashboard Wireframe (SVG) as the primary method. You must use the @agent-design:screenflow-dev agent and run the /design:update-screenflows command with SVG-first workflow. This creates wireframes/ directory with GitHub-compatible SVG wireframes and enhanced multi-screen storyboarding capabilities. Reference the enhanced documentation: ubuntu-vm/project/design/docs/screenflows-storyboarding.md and ubuntu-vm/project/design/docs/screenflows-wireframes.md. Do NOT perform other design tasks or execute unrelated commands."
fi

if [[ "$PROMPT_FLAG" == true ]]; then
    echo "💬 Prompt flag enabled"
    AGENT_PROMPT+=" [--prompt FLAG]: Follow ONLY the custom instructions provided. Do NOT add additional activities beyond what is explicitly requested."
fi

if [[ -n "$CUSTOM_INSTRUCTIONS" ]]; then
    echo "📝 Custom instructions: $CUSTOM_INSTRUCTIONS"
    AGENT_PROMPT+=" $CUSTOM_INSTRUCTIONS"
fi

# Add closing instructions if any flags were set
if [[ "$CONFIG_FLAG" == true || "$PHILOSOPHY_FLAG" == true || "$COLORS_FLAG" == true || "$SCREENFLOW_FLAG" == true || "$PROMPT_FLAG" == true || -n "$CUSTOM_INSTRUCTIONS" ]]; then
    AGENT_PROMPT+=" REMINDER: Execute ONLY the operations specified by the flags above. Do NOT perform additional design activities unless explicitly requested through the flags or custom instructions."
fi

# Step 4: Execute based on flags
if [[ "$CONFIG_ONLY" == true ]]; then
    # Command-only execution for --config flag
    echo ""
    echo "🔧 Executing command-only operation..."
    echo "Running: /design:config-designs"
    
    # CLAUDE INSTRUCTION: Use Task tool to execute the config-designs command ONLY
    # Task tool: "/design:config-designs"
    
    echo ""
    echo "✅ Config-designs command executed successfully!"
    echo "Design folder structure has been created. No agent invocation needed."
else
    # Execute design-dev agent for other flags
    echo ""
    echo "🤖 Executing design-dev agent..."
    echo ""
    echo "Agent context prepared. The agent will:"
    if [[ "$CONFIG_FLAG" == true ]]; then
        echo "- First execute /design:config-designs to create folder structure"
    fi
    if [[ "$PHILOSOPHY_FLAG" == true ]]; then
        echo "- Provide design philosophy guidance"
    fi
    if [[ "$COLORS_FLAG" == true ]]; then
        echo "- Update color system and design tokens (stored in designs/colors/)"
    fi
    if [[ "$SCREENFLOW_FLAG" == true ]]; then
        echo "- Analyze and create screen flow specifications using screenflow-dev agent with Dashboard Wireframe (SVG) as primary method"
        echo "  🔒 Note: Enhanced with embedded image validation - no external image URLs allowed"
    fi
    if [[ "$PROMPT_FLAG" == true || -n "$CUSTOM_INSTRUCTIONS" ]]; then
        echo "- Follow custom instructions"
    fi
    
    # CLAUDE INSTRUCTION: Use Task tool to execute the design-dev agent with the prepared prompt
    # Task tool with @agent-design:design-dev: "$AGENT_PROMPT"
fi

echo ""
echo "✅ Design-dev workflow completed successfully!"
echo ""

# Step 5: Create Pull Request 🚨 **AUTOMATED PR CREATION** 🚨
echo "📋 Creating pull request to complete the workflow..."

# Build PR description based on what was executed
PR_TITLE="feat: Design-dev workflow execution"
PR_BODY="## Summary

This PR contains the design-dev workflow execution with the following operations:"

# Add details based on executed flags
if [[ "$CONFIG_FLAG" == true ]]; then
    PR_BODY+="
- Created design folder structure via /design:config-designs"
fi
if [[ "$PHILOSOPHY_FLAG" == true ]]; then
    PR_BODY+="
- Updated design philosophy documentation"
fi
if [[ "$COLORS_FLAG" == true ]]; then
    PR_BODY+="
- Updated color system and design tokens (COLOR-SYSTEM.md in designs/colors/)"
fi
if [[ "$SCREENFLOW_FLAG" == true ]]; then
    PR_BODY+="
- Created/updated screen flow specifications using screenflow-dev agent with Dashboard Wireframe (SVG) as primary method
- 🔒 Enhanced with embedded image validation - all images use relative paths for GitHub compatibility"
fi
if [[ "$PROMPT_FLAG" == true || -n "$CUSTOM_INSTRUCTIONS" ]]; then
    PR_BODY+="
- Implemented custom design requirements"
fi

PR_BODY+="

## Details
- Feature branch: $FEATURE_NAME
- Base branch: $BASE_BRANCH
- Workflow: run-design-dev meta-command

## Testing
Design artifacts have been created/updated according to the specified flags.

🤖 Generated with [Claude Code](https://claude.ai/code)"

# Use Task tool to create the pull request
echo ""
echo "🚀 Creating PR from $FEATURE_NAME to $BASE_BRANCH..."

# CLAUDE INSTRUCTION: Use Task tool to execute the create-pr command
# The create-pr command will output the PR URL which should be captured
# Task tool: "/dev:create-pr $BASE_BRANCH \"$PR_BODY\""
# Expected output format: "✅ Pull request created: https://github.com/owner/repo/pull/123"

# Extract PR URL from the create-pr command output
# CLAUDE INSTRUCTION: Capture the PR URL from the create-pr command output
PR_URL="<PR-URL-FROM-CREATE-PR-OUTPUT>"

echo ""
echo "✅ Meta-command workflow completed!"
echo "📌 Feature branch: $FEATURE_NAME"
echo "🎯 Pull request created targeting: $BASE_BRANCH"
echo "🔗 PR Link: $PR_URL"
```

## Error Handling

### Common Errors

1. **Missing Base Branch**
   - Error: "Missing required arguments"
   - Solution: Provide a valid base branch name

2. **Invalid Option**
   - Error: "Unknown option: [option]"
   - Solution: Use only supported options (--config, --philosophy, --screen-flow, --prompt)

3. **Flag Usage**
   - Note: All flags are now simple boolean flags (no values required)
   - Each flag enables specific agent prompts and behaviors

## Error Recovery

If any delegated command fails, this meta-command will:

1. **Stop Execution**: Immediately halt the workflow to prevent cascading failures
2. **Report Failure**: Clearly indicate which command failed and why
3. **Provide Recovery Steps**:
   - For branch creation failures: Check git status and resolve conflicts
   - For config-designs failures: Verify permissions and existing directory structure
   - For agent invocation failures: Review agent availability and context

### Recovery Examples

```bash
# If feature branch creation fails:
echo "❌ Failed to create feature branch"
echo "Recovery steps:"
echo "1. Check current branch: git branch"
echo "2. Resolve any uncommitted changes: git status"
echo "3. Retry the command or manually create branch"

# If config-designs command fails:
echo "❌ Failed to execute config-designs"
echo "Recovery steps:"
echo "1. Check if designs/ directory already exists"
echo "2. Verify write permissions in project root"
echo "3. Run /design:config-designs manually"
```

## Requirements

- Git repository with proper remote configuration
- Access to git:create-feature-branch command
- Access to @agent-design:design-dev agent
- Valid base branch in repository
- Optional: Configuration files for enhanced agent behavior

## Notes

- **Feature Branch Naming**: Automatically generates timestamp-based branch names
- **Boolean Flags**: All flags are simple boolean switches that enable specific agent behaviors
- **Agent Prompts**: Each flag corresponds to a specific prompt sent to the design-dev agent
- **Config Integration**: --config flag directly invokes the config-designs command
- **Argument Flexibility**: Supports both flagged options and positional custom instructions
- **Agent Integration**: Seamlessly passes configuration to the design-dev agent
- **Workflow Automation**: Combines branch management with agent execution

## Version History  

- **v1.8.1** - Enhanced --screenflow workflow with embedded image validation enforcement
  - **🔒 Image Validation Integration**: Added embedded image validation references to --screenflow flag documentation
  - **Command Enhancement**: Updated to reflect `/design:update-screenflows` v2.2.0 with comprehensive image validation
  - **Agent Communication**: Enhanced agent execution prompts to mention embedded image validation requirements
  - **PR Description Updates**: Added image validation context to pull request descriptions
  - **GitHub Compatibility**: Emphasizes embedded images (relative paths) over hyperlinked images (external URLs)
  - **Error Prevention**: Helps prevent validation failures by informing users about embedded image requirements

- **v1.8.0** - Enhanced --screenflow workflow with Dashboard Wireframe (SVG) as primary method
  - **SVG-First Workflow**: Updated --screenflow flag to use Dashboard Wireframe (SVG) as the primary method for individual screen documentation
  - **Multi-Screen Storyboarding**: Enhanced storyboarding capabilities with embedded example images
  - **GitHub-Compatible Output**: SVG wireframes render natively in GitHub markdown for seamless team collaboration
  - **Enhanced Agent Integration**: Updated screenflow-dev agent integration to emphasize SVG-first approach
  - **Documentation References**: Updated to reference enhanced screenflows-storyboarding.md and screenflows-wireframes.md
  - **Command Execution**: Modified agent prompt to specify SVG-first workflow and wireframes/ directory creation
  - **Flag Execution Table**: Updated screenflow flag description to emphasize Dashboard Wireframe (SVG) primary method
  - **PR Description Enhancement**: Updated pull request body to reflect SVG-first screenflow capabilities
  - **Execution Rules**: Updated strict execution rules to include Dashboard Wireframe (SVG) methodology
  - Maintains backward compatibility with existing Mermaid diagram workflows as fallback documentation

- **v1.7.0** - Enhanced --colors workflow documentation and storage pattern reinforcement
  - Added explicit storage location documentation for --colors flag (`designs/colors/` directory)
  - Enhanced flag execution table to emphasize color system storage location
  - Updated agent prompt to include CRITICAL storage requirements for colors workflow  
  - Added storage location details to PR description generation
  - Reinforced that COLOR-SYSTEM.md is created in designs/colors/ with embedded swatch palette images
  - Documented automatic archiving pattern in designs/colors/archive/
  - Ensures consistent and robust color system file organization following established patterns
- **v1.6.0** - Updated screenflow flag and agent integration
  - Changed flag from `--screen-flow` to `--screenflow` for consistency
  - Updated flag to call `@agent-design:screenflow-dev` instead of general design-dev agent
  - Added specific command execution: `/design:update-screenflows`
  - Added documentation references: `ubuntu-vm/project/design/docs/screenflows-storyboarding.md` and `ubuntu-vm/project/design/docs/screenflows-wireframes.md`
  - Updated flag execution table to reflect new agent and command routing
  - Enhanced agent prompt to include specific command and documentation context
- **v1.5.0** - Added branch update step before feature branch creation
  - Added Step 1: Branch Update to execute /git:update-branch before creating feature branch
  - Updated orchestration flow to include branch update step
  - Updated command delegation to include branch update operation
  - Renumbered all workflow steps to accommodate new branch update step
  - Enhanced "What This Command Does" section to document branch update process
  - Ensures working directory is clean and up-to-date before starting design workflow
  - Follows best practice of updating branch state before creating new features
- **v1.4.0** - Added automated PR creation to follow standard meta-command workflow
  - Added Step 4: Create Pull Request using /dev:create-pr command
  - Updated summary to mention automated PR creation
  - Updated orchestration flow to include PR creation step
  - Added PR creation to command delegation section
  - Enhanced "What This Command Does" section with PR creation details
  - Follows standard 3-step meta-command pattern: branch → execute → PR
  - PR description dynamically generated based on executed flags
  - Ensures proper integration with development pipeline
- **v1.3.0** - Meta-command compliance update
  - Updated to follow meta-command guidelines from ubuntu-vm/user/docs/agent-complex/claude-command-file-rules.md
  - Added comprehensive flag execution table with modes and dependencies
  - Added Meta Command File Structure section showing orchestration flow
  - Enhanced What This Command Does section with clear delegation patterns
  - Added Error Recovery section for handling failed delegated commands
  - Updated summary to identify as meta-command
  - Improved documentation clarity for command orchestration
- **v1.2.0** - Renamed command from execute-design-dev to run-design-dev
  - Updated all references throughout the file
  - Maintained all existing functionality and flag behavior
  - Version bump to reflect significant naming change
- **v1.1.2** - Clarified flag execution patterns
  - Added distinction between Command-Only and Agent-Only flags
  - Implemented command-only execution path for standalone --config usage
  - Updated documentation to clearly show flag types and actions
- **v1.1.1** - Strict flag operation enforcement
  - Added CRITICAL FLAG BEHAVIOR section emphasizing discrete operations per flag
  - Updated agent prompts to explicitly state "ONLY" for each flag operation
  - Added reminders to prevent agent from performing additional activities
  - Enhanced flag-specific prompts with [--flag] prefixes for clarity
  - Reinforced that flags should not delegate beyond their specific purpose
  - Updated implementation to strictly enforce discrete flag operations
- **v1.1.0** - Flag structure overhaul and configuration management
  - Removed variable placeholders from all flags (e.g., changed `[--config <config-file>]` to `[--config]`)
  - Updated --config flag to directly call the config-designs.md command
  - Converted all flags to boolean switches with clear agent prompts
  - Added Flag Prompts Reference table outlining all flags and their corresponding prompts
  - Updated implementation to handle new flag structure
  - Enhanced agent prompt generation based on enabled flags
  - Improved error handling for new flag system
- **v1.0.1** - Enhanced agent prompting and optimization
  - Removed "Future Script Enhancement Opportunities" section
  - Optimized agent prompt to provide more precise direction
  - Added contextual guidance based on provided files
  - Enhanced agent instructions to align with design-dev capabilities
  - Improved clarity on expected agent outcomes
- **v1.0.0** - Initial implementation
  - Support for all requested options (--config, --philosophy, --screen-flow, --prompt)
  - Custom instructions handling
  - Feature branch creation integration
  - Design-dev agent invocation
  - Comprehensive error handling and validation