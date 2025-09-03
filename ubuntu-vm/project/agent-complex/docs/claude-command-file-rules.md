# Claude Command File Guidelines

This document outlines the standards and best practices for creating Claude command files. These commands are structured documentation files that automate complex workflows with Claude Code CLI, ensuring consistent execution, preventing common errors, and optimizing performance through parallel execution.

> **🚨 MOST IMPORTANT RULE:** The first line of your command file MUST follow the format ``# Args: <arguments>. v0.0.1. Description.`` because **this is exactly what Claude displays to users** when they list available commands. If this line is wrong, users won't know how to use your command!

## Table of Contents

- [Overview](#overview)
  - [Command Scope Types and Storage Locations](#command-scope-types-and-storage-locations)
- [Command File Structure](#command-file-structure)
  - [1. Header Section](#1-header-section-most-critical)
  - [2. Usage Section](#2-usage-section)
  - [3. Arguments Section](#3-arguments-section)
  - [4. Examples Section](#4-examples-section)
  - [5. What This Command Does Section](#5-what-this-command-does-section)
  - [6. Common RUN Commands Section](#6-common-run-commands-section)
  - [7. Requirements Section](#7-requirements-section)
  - [8. Error Handling Section](#8-error-handling-section)
  - [9. Notes Section](#9-notes-section)
  - [10. CLAUDE.md Management Section](#10-claudemd-management-section-if-applicable)
- [Modern Command Architecture](#modern-command-architecture)
  - [Script-First Architecture](#script-first-architecture)
  - [Named Agent Coordination](#named-agent-coordination)
  - [Script + Named Agent Combination](#script--named-agent-combination)
  - [Command File Integration](#command-file-integration)
- [Performance Optimization](#performance-optimization)
  - [Parallel Execution Guidelines](#parallel-execution-guidelines)
  - [Performance Metrics](#performance-metrics)
- [Special Command Patterns](#special-command-patterns)
  - [Interactive Input with CCEI](#interactive-input-with-ccei)
  - [Calling Command Files Within Command Files](#calling-command-files-within-command-files)
  - [Meta Command Files](#meta-command-files)
    - [Naming Convention](#naming-convention-1)
    - [Purpose and Benefits](#purpose-and-benefits-1)
    - [Meta Command File Structure](#meta-command-file-structure)
    - [Best Practices for Meta Commands](#best-practices-for-meta-commands)
    - [Flag-Based Execution](#flag-based-execution)
  - [Workflow Enforcement](#workflow-enforcement)
  - [Feature Branch Creation Workflow](#feature-branch-creation-workflow)
  - [CLAUDE.md Best Practices](#claudemd-best-practices)
- [Development Guidelines](#development-guidelines)
  - [Key Principles](#key-principles)
  - [Commit Standards](#commit-standards)
  - [Version Management](#version-management)
- [Script Development](#script-development)
  - [When to Create Scripts](#when-to-create-scripts)
  - [Script Structure and Patterns](#script-structure-and-patterns)
  - [Integration with Commands](#integration-with-commands)
- [Edge Functions Development](#edge-functions-development)
  - [Overview](#overview-1)
  - [Key Considerations for Edge Function Commands](#key-considerations-for-edge-function-commands)
  - [Example Edge Function Command Pattern](#example-edge-function-command-pattern)
  - [Best Practices for Edge Function Commands](#best-practices-for-edge-function-commands)
  - [Integration with Other Services](#integration-with-other-services)
  - [Resources](#resources)
- [Best Practices](#best-practices)
  - [Testing](#testing)
  - [Common Pitfalls](#common-pitfalls)
  - [Maintenance](#maintenance)
- [Example Command Files](#example-command-files)

## Overview

Claude commands are structured documentation files that guide Claude through multi-step processes involving:
- Git branch management
- GitHub issue and PR creation
- Code implementation with parallel execution
- Database operations and deployments
- Edge functions deployment and management
- Progress tracking and user feedback
- **⚡ Parallel task execution for improved performance**
- **🚀 Script-enhanced atomic operations for maximum efficiency**
- **🤖 Sub-agent coordination for intelligent workflow management**
- **📋 CLAUDE.md management for persistent project and user instructions**

**Important Convention:** All Claude commands are invoked with a forward slash prefix (e.g., `/command-name`). This prefix should be included in all usage examples and documentation to match how users actually invoke the commands.

### Command Scope Types and Storage Locations

There are three types of Claude command files, each with different purposes, storage locations, and deployment patterns:

#### 1. **Root Commands** (System Administrator Level)
- **Purpose**: System-wide operations requiring root privileges
- **Source Repository**: `engram-copilot-docs` (GitHub)
- **Source Location**: `ubuntu-vm/root/commands/` (in repository)
- **Script Location**: `ubuntu-vm/root/scripts/` (in repository)
- **Deployed To**: 
  - Commands: `/root/.claude/commands/`
  - Scripts: `/root/.claude/scripts/`
- **Deployment Method**: Via `sync-commands-with-remote` (root command)
- **Script Path References**: `/root/.claude/scripts/script-name.sh` (absolute path)
- **Examples**: `sync-commands-with-remote.md`, system maintenance commands
- **CLAUDE.md Updates**: Not applicable (root-level operations)

#### 2. **User Command Topics** (Individual User Level)
- **Purpose**: User-specific operations and workflows organized by topic
- **Source Location**: `ubuntu-vm/user/{topic}/` (in repository)
- **Commands Location**: `ubuntu-vm/user/{topic}/commands/` (in repository)
- **Script Location**: `ubuntu-vm/user/{topic}/scripts/` (in repository)
- **Deployed To**: 
  - Commands: `/home/{user}/.claude/commands/{topic}/`
  - Scripts: `/home/{user}/.claude/scripts/{topic}/{command-name}_{operation}.*`
- **Deployment Method**: Via `sync-commands-with-remote` (root command)
- **Script Path References**: `.claude/scripts/{topic}/{command-name}_{operation}.*` (absolute path)
- **CLAUDE.md Updates**: Update `.claude/CLAUDE.md` for user-wide configuration
- **Topic Structure in Source**:
  ```
  ubuntu-vm/user/{topic}/
  ├── commands/          # Commands directory
  │   ├── command1.md
  │   └── command2.md
  └── scripts/           # Scripts directory
      ├── command1_operation.sh
      └── command2_helper.sh
  ```
- **Deployed Structure**:
  ```
  .claude/
  ├── commands/
  │   └── {topic}/
  │       ├── command1.md
  │       └── command2.md
  └── scripts/
      └── {topic}/
          ├── command1_operation.sh
          └── command2_helper.sh
  ```
- **Examples**: `dev`, `git`, `slack`, `tools` topics
- **Benefits**: 
  - Easier navigation of related commands
  - Prevent command name conflicts
  - Cleaner command organization

#### 3. **Project Command Topics** (Repository-Specific Collections)
- **Purpose**: Self-contained collections of commands for specific services/tools
- **Source Location**: `ubuntu-vm/project/{topic}/` (in repository)
- **Commands Location**: `ubuntu-vm/project/{topic}/commands/` (in repository)
- **Script Location**: `ubuntu-vm/project/{topic}/scripts/` (within topic)
- **Repository Storage**: `.claude/commands/{topic}/` (version controlled)
- **Deployed To**: `.claude/commands/{topic}/` (for actual use)
- **Deployment Method**: 
  1. `sync-project-topic {topic}` → syncs to repository `.claude/`
  2. Manual deployment from repository to `.claude/` for use
- **Script Path References**: `.claude/scripts/{topic}/{command-name}_{operation}.*` (scripts are stored in `.claude/scripts/{topic}/`)
- **Topic Structure in Source**:
  ```
  ubuntu-vm/project/{topic}/
  ├── commands/          # Commands directory
  │   ├── command1.md
  │   └── command2.md
  └── scripts/           # Scripts subdirectory
      ├── command1_operation.sh
      └── command2_helper.sh
  ```
- **Deployed Structure**:
  ```
  .claude/
  ├── commands/
  │   └── {topic}/
  │       ├── command1.md
  │       └── command2.md
  └── scripts/
      └── {topic}/
          ├── command1_operation.sh
          └── command2_helper.sh
  ```
- **Examples**: `vercel-playwright`, `vercel-puppeteer`, `supabase`, `cloudflare` topics
- **CLAUDE.md Updates**: Update `.claude/CLAUDE.md` in local repository when modifying project configuration

#### 4. **Nexus Commands** (Organizational Level)
- **Purpose**: Organization-wide shared commands and patterns
- **Source Repository**: `engram-ops-nexus-module` (GitHub)
- **Source Location**: `src/topics/{topic}/commands/` (in repository)
- **Script Location**: `src/topics/{topic}/scripts/` (in repository)
- **Deployed To**: `.claude/commands/nexus/{topic}/` (for actual use)
- **Deployment Method**: `/sync:sync-nexus-ops` command
- **Script Path References**: `.claude/scripts/nexus/{topic}/{command-name}_{operation}.*`
- **Invocation Pattern**: `/nexus:{topic}:{command-name}`
- **Examples**: `bizdev`, `brand`, `customer-success`, `executive`, `go-to-market`, `mission`, `product` topics
- **Characteristics**:
  - Read-only (changes must be made in engram-ops-nexus-module)
  - Organizational standards and patterns
  - Shared across multiple projects
  - Namespaced to avoid conflicts


#### Summary of Key Differences

| Aspect | Root Commands | User Topics | Project Topics | Nexus Commands |
|--------|---------------|---------------|-----------------|----------------|
| **Purpose** | System administration | User workflows | Service-specific tools | Organizational standards |
| **Privilege Level** | Requires root access | User-level operations | User-level operations | User-level operations |
| **Source Repo** | engram-copilot-docs | engram-copilot-docs | engram-copilot-docs | engram-ops-nexus-module |
| **Source Path** | `ubuntu-vm/root/` | `ubuntu-vm/user/{topic}/` | `ubuntu-vm/project/{topic}/` | `src/topics/{topic}/` |
| **Script References** | `/root/.claude/scripts/name.sh` | `.claude/scripts/{topic}/{command-name}_{operation}.*` | `.claude/scripts/{topic}/{command-name}_{operation}.*` | `.claude/scripts/nexus/{topic}/{command-name}_{operation}.*` |
| **Deployment** | Direct via sync-commands-with-remote | Direct via sync-commands-with-remote | Two-stage: repo → user | Direct via sync-nexus-ops |
| **Script Location** | Shared `/root/.claude/scripts/` | Topic-organized `.claude/scripts/{topic}/` | Topic-organized `.claude/scripts/{topic}/` | Namespaced `.claude/scripts/nexus/{topic}/` |
| **Deployment Command** | sync-commands-with-remote | sync-commands-with-remote | sync-project-commands | /sync:sync-nexus-ops |
| **CLAUDE.md Path** | `/root/.claude/CLAUDE.md` | `.claude/CLAUDE.md` | `.claude/CLAUDE.md` | `.claude/CLAUDE.md` |
| **Topic Support** | No | Yes (subdirectories) | N/A (topics are top-level) | Yes (nexus namespace) |
| **Invocation** | `/command-name` | `/{topic}:{command-name}` | `/{topic}:{command-name}` | `/nexus:{topic}:{command-name}` |

## Command File Structure

Every Claude command file must follow this exact structure to ensure proper parsing and execution:

### 1. Header Section (MOST CRITICAL)

**⚠️ CRITICAL FORMATTING REQUIREMENT**: The first line of your command file MUST follow this exact format because **this is what Claude displays to users when they list available commands**:

```markdown
# Args: `<arg1>` `<arg2>` `[optional-arg]`. v0.0.1. Brief description of what the command does.

Input: $ARGUMENTS (format: arg1 arg2 optional-arg)
```

**Critical Requirements:**
1. **Start with `# Args:`** (exactly this format)
2. **Use BACKTICKS around arguments** - Without backticks, `<args>` will be hidden by markdown rendering
3. **Use angle brackets for required args**: `<required>`
4. **Use square brackets for optional args**: `[optional]`
5. **Include a period after the arguments**
6. **Include version in format `vX.Y.Z`** (e.g., `v0.1.0`, `v1.2.3`)
7. **Include a period after the version**
8. **Provide a clear, concise description**
9. **Must be on the very first line of the file**

**🚨 CRITICAL: DESCRIPTION CONTENT RULES**
- **DESCRIBE WHAT THE COMMAND DOES** - Not what was recently changed or updated
- **❌ WRONG**: "Added support for remove option", "Fixed script limitations", "Updated to use deployed scripts"
- **✅ CORRECT**: "Update and sync a git branch with remote repository", "Create GitHub issue with automated workflow"
- **The description should be TIMELESS** - it should remain accurate regardless of when the command was last updated
- **Users need to understand the command's PURPOSE, not its development history**

**Version Format:**
- **Start new commands at `v0.1.0`** (not v0.0.1) - indicates a functional initial version
- Use semantic versioning: `vMAJOR.MINOR.PATCH`
- Command versions are INDEPENDENT of repository versioning
- If no version exists, add `v0.1.0` as the initial version

**Examples of CORRECT Headers:**
- ``# Args: `<username>` `<email>`. v0.1.0. Create a new user account with sudo and developer access``
- ``# Args: `<repository-url>` `[personal-access-token]`. v1.2.0. Clone and set up a GitHub repository``
- ``# Args: `<project-name>`. v0.3.5. Configure a new Cloudflare Agents system with Workers AI``

**Examples of INCORRECT Headers:**
- `# create-user - username email` ❌ (missing "Args:", won't display properly)
- `# Args: <username> <email>. Create user` ❌ (NO BACKTICKS - args will be HIDDEN!, missing version)
- `# Args: <username>. 0.0.1. Create user` ❌ (missing 'v' prefix on version)
- `# Args: `<branch>`. v1.2.0. Added support for remove option` ❌ (describes recent changes, not command purpose)
- `# Args: `<file>`. v0.5.0. Fixed script integration issues` ❌ (describes fixes, not what command does)

### 2. Usage Section

```markdown
## Usage

```bash
/command-name <arg1> <arg2> [optional-arg]
```
```

**Note:** Always include the forward slash (`/`) prefix when showing command usage.

### 3. Arguments Section

```markdown
## Arguments

- `<arg1>`: Description of first argument
  - **CRITICAL**: Any critical rules about this argument
  - Additional details or constraints
- `<arg2>`: Description of second argument
- `[optional-arg]`: Description of optional argument (default: value)
```

### 4. Examples Section

```markdown
## Examples

```bash
# Example 1 with description
/command-name value1 value2

# Example 2 with complex arguments
/command-name develop "complex value with spaces" optional-value
```
```

### 5. What This Command Does Section

This is the most critical section. Each step must include:
- Clear numbered steps
- **Explicit RUN commands** showing exactly what Claude should execute
- **CRITICAL warnings** for important rules
- **Workflow checkpoints** to ensure step completion before proceeding

```markdown
## What This Command Does

1. **Syncs the base branch** (FIRST STEP)
   - RUN `git checkout <base-branch>`
   - RUN `git pull origin <base-branch>`
   - **VALIDATION REQUIRED**: RUN `git branch --show-current` to verify you're on the base branch
   - **CRITICAL: The base branch MUST be the one specified in the command - NEVER default to main**
   
   **🔴 WORKFLOW CHECKPOINT #1**: Before proceeding to step 2, you MUST confirm:
   - [ ] Currently on the correct base branch (verify with `git branch --show-current`)
   - [ ] Base branch is up-to-date with remote (verify no "Your branch is behind" messages)
   - [ ] No uncommitted changes in working directory (verify with `git status`)

2. **Creates a feature branch**
   - RUN `git checkout -b claude/<feature-name>`
   - Branch name is derived from feature name
   - **CRITICAL: NEVER create the branch from main unless explicitly specified as the base branch**
```

### 6. Common RUN Commands Section

```markdown
## Common RUN Commands During Execution

Claude should use these explicit commands throughout execution:

### Initial Exploration
- RUN `eza . --tree --git-ignore -L 2` - Overview of project structure
- RUN `cat package.json` - Check dependencies and scripts
- RUN `cat README.md` - Understand project setup

### Code Search and Analysis
- RUN `rg "pattern" --type ts --type tsx` - Search TypeScript/React files
- RUN `rg "table_name" src/lib` - Find database references

### Database and Types
- RUN `cat src/lib/database.types.ts` - Check database schema
- RUN `ls supabase/migrations` - List existing migrations

### Testing and Validation
- RUN `npm run typecheck` - Check TypeScript types
- RUN `npm run lint` - Run linter
- RUN `npm run build` - Build the project

### Git Operations
- RUN `git status` - Check current changes
- RUN `git diff` - Review changes before committing
- RUN `git add -A` - Stage all changes
- RUN `git commit -m "feat: <description>"` - Commit with conventional message
- RUN `git push origin claude/<branch-name>` - Push to remote

### Supabase Operations (via MCP)
- Check project: `mcp__supabase__get_project`
- Apply migration: `mcp__supabase__apply_migration`
- Deploy edge function: `mcp__supabase__deploy_edge_function`

### Edge Functions Operations
- Deploy function: `mcp__supabase__deploy_edge_function`
- List functions: `mcp__supabase__list_edge_functions`
- Get logs: `mcp__supabase__get_logs` with service="edge-function"
- **📚 IMPORTANT**: For comprehensive edge functions best practices, see [Edge Functions Best Practices](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/index.md)
```

### 7. Requirements Section

```markdown
## Requirements

- Git installed and configured
- Claude Code CLI installed and configured
- GitHub MCP tool configured
- Supabase MCP tool configured
- Any project-specific requirements

### Version Requirements for PRs to Main Branch

When creating PRs that target the main branch, commands must enforce version validation:

```bash
# Check if version bump is required
OLD_VERSION=$(git show origin/main:package.json | jq -r .version)
NEW_VERSION=$(jq -r .version package.json)

if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "❌ Version must be bumped for changes to main branch"
    exit 1
fi
```
```

### 8. Error Handling Section

```markdown
## Error Handling

- The command validates that all arguments are provided
- Checks if required resources exist before proceeding
- Exits with appropriate error messages if requirements aren't met
- Provides recovery procedures for common failures
```

### 9. Notes Section

```markdown
## Notes

- **CRITICAL: NEVER use main branch unless explicitly specified** - Always use the base branch provided in the command arguments
- **CRITICAL: NEVER create PR targeting main** - The PR must target the specified base branch from the command
- Additional important notes...
```

### 10. Preventing Bash Command Interpretation

**CRITICAL**: Claude command files are NOT bash scripts. They must be processed through Claude's command system to prevent misinterpretation.

#### The Problem

Claude may incorrectly attempt to execute slash commands (e.g., `/clone-repo`) as bash commands, resulting in errors like:
```bash
bash: line 1: /clone-repo: No such file or directory
```

#### Prevention Strategies

##### 1. **Add Explicit Command Execution Notices**

At the top of your command file, after the header:

```markdown
# Args: `<repository-url>`. v1.0.0. Clone and configure a repository.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/clone-repo` in bash.
```

##### 2. **Clarify Implementation Context**

In the implementation section, explicitly state the execution context:

```markdown
## Implementation

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/command-name` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**
```

##### 3. **Add Context Comments in Code Blocks**

When showing script execution in code blocks:

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

SCRIPT_PATH="$HOME/.claude/scripts/command_main.sh"
echo "🚀 Executing command workflow through Claude command system..."
"$SCRIPT_PATH" "$@"
```

##### 4. **Use External Scripts Pattern**

Move all bash implementation to external scripts to avoid embedded code execution:

```markdown
## Implementation

The main implementation is located in the external script `../scripts/command_main.sh`.

This follows the pattern to prevent Claude CLI from misinterpreting embedded bash code.
```

##### 5. **Version Documentation**

Document anti-bash-interpretation improvements in version history:

```markdown
## Version History

v1.0.1 - Enhanced command execution clarity:
         - Added explicit notices to prevent bash execution attempts
         - Clarified Claude command execution context
         - Added visual markers for command vs script execution
         - Enhanced documentation to prevent `/command-name` bash interpretation
```

#### Best Practices

1. **Never rely on PATH**: Don't assume commands are in PATH
2. **Always use explicit notices**: Make it clear this is a Claude command
3. **Document the execution flow**: Show how Claude processes the command
4. **Use visual markers**: 🚨, 🔴, ❌, ✅ to highlight critical information
5. **Provide clear error messages**: Help users understand when they're using commands incorrectly

### 11. CLAUDE.md Management Section (if applicable)

For commands that update CLAUDE.md instructions:

```markdown
## CLAUDE.md Updates

This command updates the CLAUDE.md file for persistent instructions.

### Scope Determination

**Root Commands**:
- Do not typically update CLAUDE.md files (system-level operations)
- If needed, would update `/root/.claude/CLAUDE.md`

**User Commands** (ending in `-user`):
- Update `.claude/CLAUDE.md` for user-wide configuration
- Creates the file if it doesn't exist  
- Path: `$HOME/.claude/CLAUDE.md`

**Project Command Bundles**:
- Update `.claude/CLAUDE.md` in the local repository
- Creates the file if it doesn't exist
- Path: `<repository-root>/.claude/CLAUDE.md`

### Update Pattern

```bash
# Determine the correct CLAUDE.md path based on command type
if [[ "$COMMAND_TYPE" == "root" ]]; then
    # Root commands (system-level, rarely update CLAUDE.md)
    CLAUDE_MD="/root/.claude/CLAUDE.md"
    mkdir -p /root/.claude
elif [[ "$COMMAND_NAME" == *-user ]] || [[ "$COMMAND_TYPE" == "user" ]]; then
    # User commands (user-wide configuration)
    CLAUDE_MD="$HOME/.claude/CLAUDE.md"
    mkdir -p "$HOME/.claude"
else
    # Project command topics (repository-specific)
    CLAUDE_MD=".claude/CLAUDE.md"
    mkdir -p .claude
fi

# Create or update CLAUDE.md
if [[ ! -f "$CLAUDE_MD" ]]; then
    echo "Creating new CLAUDE.md at $CLAUDE_MD"
    cat > "$CLAUDE_MD" << 'EOF'
# Claude Instructions

## Overview

[Project/User-specific overview]

## Instructions

[Specific instructions for Claude]

EOF
else
    echo "Updating existing CLAUDE.md at $CLAUDE_MD"
    # Append or modify as needed
fi
```

### Best Practices for CLAUDE.md

1. **Structure**:
   - Use clear markdown headers
   - Keep instructions concise and actionable
   - Include specific examples when helpful

2. **Content Guidelines**:
   - Focus on persistent behavioral instructions
   - Include project-specific conventions (for project-level)
   - Document tool preferences and patterns
   - Specify error handling approaches

3. **Update Strategy**:
   - Check if file exists before creating
   - Preserve existing valuable content
   - Use sections to organize different instruction types
   - Add timestamps for tracking changes

4. **Example Structure**:
```markdown
# Claude Instructions

## Project Configuration

- Framework: Next.js 14
- Database: Supabase
- Testing: Cypress

## Development Patterns

- Always run type checking before commits
- Use server components by default
- Follow existing component patterns

## Commands to Run

- Lint: `npm run lint`
- Type check: `npm run typecheck`
- Tests: `npm run test`

## Updated: 2024-01-15
```

## Modern Command Architecture

**Overview**: Modern command architecture emphasizes three equally important strategies for optimal performance and maintainability:
1. **Scripts** for atomic, high-performance operations
2. **Named Agents** for intelligent, domain-specific coordination
3. **Narrow-scope Commands** for precise, composable workflows

These strategies work together to create robust, efficient command execution patterns.

### Script-First Architecture

**HIGHEST PRIORITY**: Always evaluate if operations can be scripted for better performance.

**Benefits:**
- 70-85% performance improvements over manual execution
- Atomic operations with comprehensive error reporting
- Reusable, testable, version-controlled operations

**Implementation:**
```bash
# Check for script first, fall back to manual
# For user commands:
if [[ -f "$HOME/.claude/scripts/{topic}/{command-name}_{operation}.sh" ]]; then
    "$HOME/.claude/scripts/{topic}/{command-name}_{operation}.sh" "$@"
else
    # Manual fallback implementation
fi

# For project commands:
if [[ -f ".claude/scripts/{topic}/{command-name}_{operation}.sh" ]]; then
    ".claude/scripts/{topic}/{command-name}_{operation}.sh" "$@"
else
    # Manual fallback implementation
fi
```

**Guidelines:**
- Create scripts for operations with 5+ sequential commands
- Store scripts in appropriate deployed locations:
  - Root: `/root/.claude/scripts/`
  - User: `.claude/scripts/{topic}/`
  - Project: `.claude/scripts/{topic}/`
- Use naming pattern: `{command-name}_{operation}.sh`
- Include structured reporting for Claude to process failures
- Always provide manual fallback when scripts unavailable

### Named Agent Coordination

**SECOND PRIORITY**: Named agents handle complex logic and decision-making through well-defined profiles and capabilities.

**Key Concepts:**
- **Named Agents**: Agents configured in `.claude/agents` with discrete profiles, duties, and capabilities
- **Agent Profiles**: Each agent has specific expertise, tools, and behavioral patterns
- **Targeted Deployment**: Call agents by their exact name for specialized tasks

**Benefits:**
- 60-80% faster than sequential research through specialized expertise
- Predictable behavior through well-defined agent profiles
- Intelligent task routing based on agent capabilities
- Better context preservation within specialized domains

**Implementation Pattern:**
```bash
# Call a named agent for specialized task
echo "🤖 Deploying code-reviewer agent for PR analysis..."
# Agent name must match exactly what's configured in .claude/agents

# Example: Using a specialized agent
claude task --agent code-reviewer "Review the changes in PR #123"

# Example: Research agent for documentation
claude task --agent research-specialist "Find best practices for React hooks"
```

**Named Agent Guidelines:**
1. **Always use agent names from `.claude/agents`** - Never use ad-hoc agent descriptions
2. **Match agent to task domain** - Code review → code-reviewer, Security → security-auditor
3. **Provide clear task descriptions** - Agents work best with specific, well-scoped tasks
4. **Chain agents for complex workflows** - One agent's output can inform another's task

**Agent Reference Standardization:**

**🚨 CRITICAL: Use `@agent-` prefix for all agent references in command files.**

When referencing agents in command file documentation and Task tool invocations, always use the standardized `@agent-` prefix format:

```bash
# ✅ CORRECT: Standardized agent reference format
Task tool: "@agent-figma-make:design-dev" with prompt: "Design the user interface"
Task tool: "@agent-code-reviewer" with task: "Review PR #123"
Task tool: "@agent-security-auditor" with task: "Scan for vulnerabilities"

# ❌ INCORRECT: Missing @agent- prefix
Task tool: "figma-make:design-dev" with prompt: "Design the user interface" 
Task tool: "code-reviewer" with task: "Review PR #123"
Task tool: "security-auditor" with task: "Scan for vulnerabilities"
```

**Agent Reference Formatting Rules:**
1. **Prefix Requirement**: Always prefix agent references with `@agent-`
2. **Consistency**: Use the same format throughout all command files and documentation
3. **Domain Agents**: For domain-specific agents, use format `@agent-{domain}:{agent-name}`
   - Example: `@agent-figma-make:design-dev`, `@agent-supabase:edge-functions`
4. **General Agents**: For general-purpose agents, use format `@agent-{agent-name}`
   - Example: `@agent-code-reviewer`, `@agent-security-auditor`

**Benefits of Standardized References:**
- **Recognition**: Clear distinction between agents and other command elements
- **Consistency**: Uniform referencing across all command files
- **Documentation**: Easier to identify agent invocations in command documentation
- **Tooling**: Enables automated parsing and validation of agent references

**Common Named Agent Types:**
- `code-reviewer`: Analyzes code changes, suggests improvements
- `research-specialist`: Gathers information from multiple sources
- `security-auditor`: Identifies vulnerabilities and security patterns
- `performance-optimizer`: Analyzes and improves performance bottlenecks
- `test-engineer`: Creates comprehensive test strategies and implementations

**Ad-hoc Agents (Lower Priority):**
While named agents are preferred, ad-hoc agents may be used for:
- One-off experimental tasks
- Temporary specialized analysis
- Situations where no suitable named agent exists

**Integration with Scripts:**
Named agents excel at:
- Determining which scripts to deploy
- Processing script outputs intelligently
- Handling script failures with context-aware recovery
- Coordinating multiple script executions

### Script + Named Agent Combination

**OPTIMAL APPROACH**: Combine scripts and named agents for maximum effectiveness.

**Benefits:**
- 85-95% overall performance improvement through specialized coordination
- Maximum performance with domain-specific intelligence
- Robust execution with agent-specific recovery strategies
- Consistent behavior through well-defined agent profiles

**Integration Pattern:**
1. **Named agent analyzes requirements** based on their specialized domain
2. **Agent deploys appropriate scripts** matching their expertise area
3. **Scripts execute efficiently** and report structured results
4. **Agent processes results** using domain-specific knowledge
5. **Agent handles failures** with specialized recovery strategies

**Example Workflow:**
```bash
# Performance optimization workflow
echo "🚀 Initiating performance optimization workflow..."

# 1. Deploy performance-optimizer agent
claude task --agent performance-optimizer "Analyze slow endpoints in the API"

# 2. Agent identifies bottlenecks and deploys profiling scripts
# 3. Scripts gather metrics and return structured data
# 4. Agent analyzes results and deploys optimization scripts
# 5. Agent validates improvements and reports findings
```

### Command File Integration

**EQUAL PRIORITY WITH AGENTS**: Narrow-scope command files provide precise, repeatable execution patterns.

**Key Principles:**
1. **Precision Through Specialization**: Create highly focused command files for specific tasks
2. **Composability**: Build complex workflows from simple, well-tested commands
3. **Meta-Command Pattern**: High-level commands orchestrate narrow-scope commands

**Command Architecture Patterns:**

```bash
# Meta-command orchestrating specialized commands
/execute-project-setup main "Initialize new Next.js project"
  ├── /create-nextjs-app "my-app"
  ├── /setup-eslint-prettier "my-app"
  ├── /configure-tailwind "my-app"
  └── /initialize-git-flow "my-app"

# Each sub-command is narrow and focused
# Total execution time: 2-3 minutes vs 10-15 minutes manual
```

**Command Design Guidelines:**
1. **Single Responsibility**: Each command does one thing exceptionally well
2. **Clear Interfaces**: Well-defined arguments and outputs
3. **Error Boundaries**: Commands handle their own errors gracefully
4. **Progress Reporting**: Clear status updates for user visibility

**Benefits of Narrow-Scope Commands:**
- **Testability**: Easier to validate individual commands
- **Reusability**: Commands can be mixed and matched
- **Maintainability**: Changes isolated to specific commands
- **Performance**: Optimized for their specific task

**Integration with Named Agents:**
```bash
# Agent can call specialized commands
claude task --agent deployment-specialist "Deploy to production"
# Agent might execute:
#   /validate-build-artifacts
#   /run-integration-tests  
#   /deploy-to-vercel
#   /validate-deployment
```

## Performance Optimization

### Parallel Execution Guidelines

**CRITICAL**: Identify and document opportunities for parallel execution to significantly improve command performance.

#### Ensuring Parallel Execution Actually Happens

**THE PROBLEM**: Claude often defaults to sequential execution even when parallel execution is specified.

**THE SOLUTION**: Use extremely explicit instructions with multiple reinforcement techniques.

#### Effective Parallel Execution Instructions

```markdown
## Step Name 🚨⚡ MANDATORY PARALLEL EXECUTION - PERFORMANCE CRITICAL ⚡🚨

**⚠️ TECHNICAL REQUIREMENT: You MUST use a single message with multiple tool calls.**

**❌ INCORRECT EXECUTION (DO NOT DO THIS):**
- Message 1: Bash tool -> command 1
- Message 2: Bash tool -> command 2
- Message 3: Bash tool -> command 3
Result: Sequential execution, 3x slower

**✅ CORRECT EXECUTION (YOU MUST DO THIS):**
- Message 1: 
  - Bash tool -> command 1
  - Bash tool -> command 2
  - Bash tool -> command 3
Result: Parallel execution, 3x faster

**⚠️ WARNING: Sequential execution will cause:**
- 5-10x slower performance
- Poor user experience  
- Potential timeout failures

**Execute these commands in ONE MESSAGE with MULTIPLE TOOL CALLS:**
```bash
# All of these MUST be in a SINGLE message:
git fetch origin main:main --update-head-ok
git fetch origin dev:dev --update-head-ok
gh auth status
git status --porcelain
```

**Performance Impact:**
- Sequential: ~8 seconds (unacceptable)
- Parallel: ~2 seconds (required)
```

#### Critical Success Factors for Parallel Execution

1. **Use Multiple Attention Markers**: Don't just use ⚡ - combine 🚨⚡🔴
2. **Explain the Technical Requirement**: State explicitly "use ONE message with MULTIPLE tool calls"
3. **Show Wrong vs Right**: Provide visual examples of incorrect sequential vs correct parallel
4. **State Consequences**: Explain what happens with poor performance
5. **Set Performance Expectations**: Give specific timing requirements
6. **Repeat Instructions**: Say it multiple ways - "single message", "one message", "simultaneous"
7. **Use Strong Language**: "MUST", "REQUIRED", "MANDATORY" - not just "should"

#### When to Use Parallel Execution

1. **API Calls** - Multiple non-dependent API requests
2. **File Operations** - Reading/analyzing multiple files
3. **Research Tasks** - Independent codebase analysis
4. **Project Updates** - Setting multiple fields simultaneously
5. **Data Gathering** - Collecting information from various sources
6. **Named Agent Deployment** - Multiple specialized agents working on independent tasks
7. **Command Orchestration** - Running multiple narrow-scope commands simultaneously

#### Named Agent Parallel Execution Strategy

**POWERFUL PATTERN**: Deploy multiple named agents simultaneously for complex multi-faceted tasks.

**Implementation Example:**
```markdown
## Complex Task Analysis 🚨⚡ PARALLEL AGENT DEPLOYMENT ⚡🚨

**Deploy these specialized agents IN PARALLEL for comprehensive analysis:**

**⚠️ CRITICAL: Use ONE message with MULTIPLE agent deployments:**
```bash
# Message 1 - ALL agents deployed simultaneously:
- Task tool → @agent-code-reviewer: "Review PR #123 for code quality"
- Task tool → @agent-security-auditor: "Scan PR #123 for vulnerabilities"  
- Task tool → @agent-performance-optimizer: "Analyze PR #123 for performance impacts"
- Task tool → @agent-test-engineer: "Suggest test improvements for PR #123"

# Result: 4x faster analysis with specialized insights
```

**Benefits of Parallel Agent Deployment:**
- **Domain Expertise**: Each agent applies specialized knowledge
- **Comprehensive Coverage**: Multiple perspectives simultaneously
- **Time Efficiency**: 75-80% faster than sequential agent calls
- **Better Insights**: Agents can cross-reference findings

#### Task Tool Parallel Execution Pattern (PROVEN EFFECTIVE)

**BREAKTHROUGH DISCOVERY**: The Task tool patterns used in execute-prompt command show exceptional reliability for faithful agent execution. These patterns prioritize simplicity and directness that maximizes execution success.

**Core Success Principles:**
1. **Ultra-Clear Syntax**: `Task tool: "/command args"`
2. **Explicit Parallel Instructions**: One message, multiple Task tool calls
3. **No Ambiguity**: Direct tool name, exact command syntax
4. **Visual Clarity**: Clear formatting that stands out

**Proven Pattern from execute-prompt:**
```markdown
## Step Name 🚨 **TASK TOOL COMMAND INVOCATION** 🚨

**🚨 CRITICAL: Use Claude's Task tool for slash command execution**

**Invoke commands using Task tool IN PARALLEL:**
```bash
# 🔴 EXECUTE ALL IN ONE MESSAGE:
# 1. Create feature branch using Task tool
Task tool: "/git:create-feature-branch <base-branch> $FEATURE_NAME"

# 2. Create GitHub issue using Task tool  
Task tool: "/git:create-issue \"[session-id] $TASK_DESCRIPTION\" \"$ISSUE_BODY\" \"feature\""

# Both commands run in parallel, reducing total execution time
```

**Key Success Elements:**
- **Direct Tool Name**: "Task tool:" (not "Use Task tool" or "Call Task tool")
- **Exact Syntax**: Clear colon separator and command format
- **Parallel Instructions**: Explicit "ONE MESSAGE" requirement
- **Performance Context**: "run in parallel, reducing total execution time"
```

**Why This Pattern Works:**
- **No Interpretation Required**: Agent knows exactly what to do
- **Standard Format**: Consistent across all command invocations
- **Clear Boundaries**: Easy to identify what needs parallel execution
- **Proven Results**: Successfully tested in execute-prompt workflow

**Task Tool Parallel Templates:**

**For Slash Command Execution:**
```markdown
# 🚨 TASK TOOL PARALLEL EXECUTION
Task tool: "/command-one arg1 arg2"
Task tool: "/command-two arg1 arg2"
Task tool: "/folder:command-three arg1 arg2"
```

**For Agent Deployment:**
```markdown
# 🚨 PARALLEL AGENT DEPLOYMENT VIA TASK TOOL
Task tool with @agent-general-purpose: "Research authentication patterns"
Task tool with @agent-code-reviewer: "Review security implications"
Task tool with @agent-performance-optimizer: "Analyze performance impact"
```

**Critical Implementation Rules:**
1. **Use "Task tool:" prefix** - Exact format, no variations
2. **One message, multiple calls** - All Task tools in single message
3. **Include performance context** - Explain why parallel matters
4. **Visual markers** - Use 🚨 for critical sections
5. **Simple, direct language** - No complex explanations needed

#### Comprehensive Parallel Execution Patterns

**CRITICAL EXPANSION**: Parallel execution applies to ALL types of operations, not just Task tool commands. Command files must account for direct tool usage, prompts, and mixed scenarios.

**Pattern 1: Direct Tool Parallel Execution (Non-Command Files)**
```markdown
## Step Name 🚨⚡ PARALLEL TOOL EXECUTION ⚡🚨

**⚠️ EXECUTE ALL IN ONE MESSAGE with MULTIPLE TOOL CALLS:**

```bash
# All tools executed simultaneously:
- Bash tool: git status --porcelain
- Bash tool: git fetch origin main
- Bash tool: gh auth status
- Grep tool: "TODO" --type md
```

**Performance Impact:** 4 operations in 2 seconds vs 8 seconds sequential
```

**Pattern 2: Mixed Execution (Commands + Direct Tools)**
```markdown
## Step Name 🚨⚡ MIXED PARALLEL EXECUTION ⚡🚨

**⚠️ COMBINE COMMAND FILES AND DIRECT TOOLS IN ONE MESSAGE:**

```bash
# Mixed parallel execution:
- Task tool: "/git:create-issue \"Bug Report\" \"Description\" \"bug\""
- Task tool: "/validate-environment production"
- Bash tool: npm run build
- Bash tool: npm run test
- Read tool: package.json
```

**Key Benefit:** Commands and direct operations run simultaneously
```

**Pattern 3: Agent Deployment with Direct Operations**
```markdown
## Step Name 🚨⚡ AGENT + TOOL PARALLEL EXECUTION ⚡🚨

**⚠️ DEPLOY AGENTS AND EXECUTE TOOLS SIMULTANEOUSLY:**

```bash
# Parallel agent deployment with direct tools:
- Task tool with @agent-code-reviewer: "Review recent commits for quality"
- Task tool with @agent-security-auditor: "Scan for vulnerabilities" 
- Bash tool: git log --oneline -10
- Bash tool: npm audit --json
- Grep tool: "console.log" --type js
```

**Result:** Comprehensive analysis with 70% faster execution
```

**Pattern 4: Research and Analysis Parallel Execution**
```markdown
## Step Name 🚨⚡ PARALLEL RESEARCH EXECUTION ⚡🚨

**⚠️ RESEARCH AND ANALYSIS IN ONE MESSAGE:**

```bash
# Simultaneous research operations:
- WebSearch tool: "React hooks best practices 2024"
- WebSearch tool: "Node.js security vulnerabilities"
- mcp__context7__get-library-docs: "/vercel/next.js"
- Read tool: docs/api-reference.md
- Grep tool: "useEffect" --type tsx
```

**Performance:** Complete research in 3 seconds vs 15 seconds sequential
```

**Pattern 5: Database and API Parallel Operations**
```markdown
## Step Name 🚨⚡ DATABASE + API PARALLEL EXECUTION ⚡🚨

**⚠️ DATABASE OPERATIONS AND API CALLS SIMULTANEOUSLY:**

```bash
# Parallel database and API operations:
- mcp__supabase__execute_sql: "SELECT * FROM users LIMIT 10"
- mcp__supabase__list_tables: project_id
- mcp__github__list_issues: owner repo
- Bash tool: curl -s https://api.example.com/health
```

**Critical:** Independent operations only - respect dependencies
```

**Universal Parallel Execution Principles:**

**✅ ALWAYS Parallel When:**
1. **Independent Operations** - No dependencies between commands
2. **Information Gathering** - Reading files, searching, API calls
3. **Validation Checks** - Multiple status checks or verifications
4. **Research Tasks** - Multiple sources, documentation, web searches
5. **Agent Deployment** - Multiple specialized agents on different aspects

**❌ NEVER Parallel When:**
1. **Sequential Dependencies** - Output of one needed for input of another
2. **State Modifications** - Operations that change the same resource
3. **Order-Critical Operations** - Must happen in specific sequence
4. **Exclusive Access** - Operations requiring locks or exclusive access

**Performance Guidelines:**
- **2-3 Operations**: 50-60% time savings
- **4-6 Operations**: 70-80% time savings  
- **7+ Operations**: 80-85% time savings (diminishing returns)

**Dependency Detection Rules:**
```markdown
# Safe for parallel (independent):
- git status + npm audit + file reads
- Multiple API calls to different endpoints
- Research from different sources
- Agent deployment on different topics

# Must be sequential (dependent):
- git add → git commit → git push
- Create file → Read file → Modify file
- API call → Process response → Next API call
- Login → Authenticated operation
```

#### Simplicity and Directness Principles for Faithful Execution

**CORE PHILOSOPHY**: The most reliable command patterns are those that require minimal interpretation by the agent. Focus on clarity over cleverness.

**Proven Simplicity Techniques:**

**1. Direct Tool Syntax (✅ WORKS RELIABLY):**
```markdown
# Simple, unambiguous format
Task tool: "/command arg1 arg2"

# NOT complex explanations like:
# "Use the Task tool to invoke the command with the following parameters..."
```

**2. One-Line Instructions (✅ HIGHEST SUCCESS RATE):**
```markdown
# Clear, immediate action
Task tool: "/git:create-issue \"Bug fix\" \"Fixed login timeout\" \"bug\""

# NOT multi-step explanations:
# "First, gather the issue details, then format them properly, then call..."
```

**3. Visual Separation (✅ REDUCES CONFUSION):**
```markdown
## Section 🚨 **TASK TOOL EXECUTION** 🚨

Task tool: "/command-one"
Task tool: "/command-two"
```

**4. Performance Context (✅ MOTIVATES COMPLIANCE):**
```markdown
# Both commands run in parallel, reducing total execution time
# Performance: 2 seconds vs 8 seconds sequential
```

**5. Explicit Parallel Requirements (✅ PREVENTS SEQUENTIAL EXECUTION):**
```markdown
# 🔴 EXECUTE ALL IN ONE MESSAGE:
Task tool: "/command-a"
Task tool: "/command-b"
```

**Anti-Patterns That Cause Failures:**

**❌ Complex Instructions:**
```markdown
# BAD: Too much explanation
"You should use the Task tool to orchestrate multiple command executions 
by carefully considering the dependencies and ensuring that..."

# GOOD: Direct action
Task tool: "/command args"
```

**❌ Ambiguous Language:**
```markdown
# BAD: Unclear tool reference
"Invoke the command using the appropriate tool"

# GOOD: Specific tool name
Task tool: "/command args"
```

**❌ Hidden Requirements:**
```markdown
# BAD: Buried in text
"During this process, you'll need to call some commands in parallel"

# GOOD: Explicit and visible
🚨 EXECUTE ALL IN ONE MESSAGE:
Task tool: "/command-one"
Task tool: "/command-two"
```

**Universal Templates for All Execution Types:**

**Template A: Command Files Only**
```markdown
## Step Name 🚨 **TASK TOOL PARALLEL EXECUTION** 🚨

**🔴 EXECUTE ALL IN ONE MESSAGE:**
Task tool: "/command-one <args>"
Task tool: "/command-two <args>"
Task tool: "/folder:command-three <args>"

# Performance: Parallel execution saves X seconds
```

**Template B: Direct Tools Only**
```markdown
## Step Name 🚨⚡ PARALLEL TOOL EXECUTION ⚡🚨

**🔴 EXECUTE ALL IN ONE MESSAGE:**
- Bash tool: command-one
- Read tool: file-path
- Grep tool: "pattern" --type ext
- WebSearch tool: "query terms"

# Performance: X operations in Y seconds vs Z seconds sequential
```

**Template C: Mixed Execution (Commands + Tools)**
```markdown
## Step Name 🚨⚡ MIXED PARALLEL EXECUTION ⚡🚨

**🔴 COMBINE ALL OPERATIONS IN ONE MESSAGE:**
- Task tool: "/command-name <args>"
- Task tool with @agent-name: "Task description"
- Bash tool: direct-command
- Read tool: file-path
- API tool: endpoint-call

# Performance: Complete workflow in X seconds vs Y seconds sequential
```

**Template D: Agent Deployment + Operations**
```markdown
## Step Name 🚨⚡ AGENT + OPERATIONS PARALLEL EXECUTION ⚡🚨

**🔴 DEPLOY AGENTS AND EXECUTE TOOLS SIMULTANEOUSLY:**
- Task tool with @agent-specialized-agent: "Agent task description"
- Task tool with @agent-another-agent: "Different task description"
- Bash tool: supporting-command
- Read tool: context-file

# Result: Comprehensive analysis with Z% faster execution
```

**Template Selection Guide:**
- **Use Template A** when executing only command files (e.g., workflow orchestration)
- **Use Template B** when executing only direct tools (e.g., data gathering, validation)
- **Use Template C** for mixed workflows (most common in complex commands)
- **Use Template D** when combining agent intelligence with direct operations

**Critical Success Factors (ALL Templates):**
1. **Visual Markers**: Use 🚨⚡ for immediate recognition
2. **Explicit Instructions**: "EXECUTE ALL IN ONE MESSAGE" or similar
3. **Performance Context**: Always explain time savings
4. **Clear Separation**: Use consistent formatting for each operation
5. **Dependency Awareness**: Only combine independent operations

**Success Metrics from execute-prompt:**
- **Command Recognition**: 100% (clear "Task tool:" syntax)
- **Parallel Execution**: 95% (explicit "ONE MESSAGE" instruction)
- **Argument Handling**: 98% (clear syntax prevents parsing errors)
- **Overall Reliability**: 97% (proven in production workflow)

**Parallel Command Execution Pattern:**
```markdown
## Project Setup 🚨⚡ PARALLEL COMMAND EXECUTION ⚡🚨

**Execute these narrow-scope commands IN PARALLEL:**

```bash
# Single message with multiple command calls:
- Bash tool → claude /setup-git-hooks
- Bash tool → claude /configure-eslint  
- Bash tool → claude /install-dependencies
- Bash tool → claude /setup-environment-vars

# Performance: 2 minutes vs 8 minutes sequential
```

### Performance Metrics

#### Script Integration Performance Gains
- **Initial Analysis**: 75-80% faster (1.5s vs 6-8s)
- **Branch Sync**: 50-60% faster (1-2s vs 3-4s)
- **Overall Execution**: ~4-6s (85% reduction from 35-45s)

#### High-Impact Optimization Patterns

1. **Shared Data Cache Architecture**
   ```bash
   CACHE_DIR="/tmp/command-$$"
   mkdir -p "$CACHE_DIR"
   gh pr view "$PR_NUMBER" --json everything > "$CACHE_DIR/pr-data.json"
   ```

2. **GraphQL Consolidation**
   ```graphql
   query($pr: Int!) {
     repository(owner: "owner", name: "repo") {
       pullRequest(number: $pr) {
         state, title, commits { totalCount }
       }
     }
   }
   ```

3. **Parallel Branch Operations**
   ```bash
   git push origin --delete "$BRANCH" 2>/dev/null &
   REMOTE_PID=$!
   git branch -D "$BRANCH" 2>/dev/null &
   LOCAL_PID=$!
   wait $REMOTE_PID $LOCAL_PID
   ```

## Special Command Patterns

### Interactive Input with CCEI

**CRITICAL PRINCIPLE**: Traditional dialog boxes do not work in Claude's execution environment. Use the **Claude Continuous Execution Input (CCEI)** method.

#### Why CCEI Works

- Maintains continuous execution (no stops)
- Compatible with Claude's execution model
- Works in all terminal environments
- Supports dependent/branching questions
- Optimized for minimal terminal space (4 lines)

#### CCEI Implementation

```bash
#!/bin/bash
# CCEI Ultra Compact - Maximum info in 4 lines

# Question 1
clear
echo "┌─ Q1: Pick number (1-9) ───┐"
echo "│ Type in Claude chat       │"
echo "└───────────────────────────┘"
echo "⏳ Waiting 20 seconds..."
sleep 20

# Question 2 (depends on Q1)
clear
NUM=5  # User's answer from Claude chat
echo "You picked: $NUM"
echo "┌─ Q2: What is $NUM × $NUM? ────┐"
echo "└───────────────────────────┘"
echo "⏳ Waiting 20 seconds..."
sleep 20

# Summary
clear
echo "✅ COMPLETE!"
echo "$NUM × $NUM = $RESULT"
echo "Total time: 60 seconds"
```

#### Best Practices for CCEI

1. **Always Use Clear Screen** - Essential for 4-line constraint
2. **Compact Question Format** - Use box drawing characters
3. **Fixed Wait Times** - Use reasonable timeouts (15-30 seconds)
4. **Maintain Context** - Show previous answers when relevant
5. **Clear Completion** - Display summary of selections

### Calling Command Files Within Command Files

Claude Code CLI agents can call and use command files stored in your `.claude/commands` directory. This powerful feature enables modular, composable workflows where commands can leverage other commands as building blocks.

#### How Agents and Command Files Work Together

- **Custom Command Files**: You can define reusable prompts as Markdown files in `.claude/commands/` (for project-specific commands) or `.claude/commands/` (for user-wide commands)
- **Agent Usage**: When you create or invoke a sub-agent (via the Task tool), the agent can execute any custom command that matches the slash-command syntax, as long as it's defined in the `.claude/commands` directory structure
- **Seamless Invocation**: Both you and your agents can trigger these commands using `/command-name [arguments]` in any Claude Code interactive session. Agents treat these commands as modular building blocks for workflows, automation, or delegating frequent tasks

#### Example Workflow

1. **Define a Command**:
   - Create `.claude/commands/optimize.md` with content like:  
     `Analyze this code for performance and suggest improvements:`

2. **Agent Calls Command Using Task Tool**:
   - If your agent is configured for code review or optimization, it must use the Task tool to invoke commands:
   ```bash
   # 🔴 CORRECT: Use Task tool for command invocation
   Task tool: "/optimize src/components/MyComponent.tsx"
   ```

3. **Argument Passing**:
   - Commands can accept arguments, which must be passed through the Task tool:
   ```bash
   # 🔴 CORRECT: Arguments passed through Task tool
   Task tool: "/analyze file.js --verbose"
   
   # 🔴 CORRECT: For git folder commands
   Task tool: "/git:create-issue \"Bug Report\" \"Description here\" \"bug\""
   ```

#### Key Points

- **Project and User Scope**: Commands in `.claude/commands/` are project-shared; commands in `.claude/commands/` are available everywhere for your user
- **Naming & Discovery**: Command names are derived from the file name (e.g., `optimize.md` → `/optimize`). Agents can discover and list available commands
- **Agent Logic**: Inside your agent definitions or during execution, you can specify when an agent should use a given command, or prompt agents to delegate via commands during interactive sessions
- **Composability**: This makes agents highly composable: they can leverage your library of commands the same way a user would, boosting automation and reusability

#### Implementation in Command Files

When designing commands that may call other commands, you MUST use Claude's Task tool to invoke slash commands properly:

```markdown
## What This Command Does

1. **Initial Setup**
   - Perform preliminary checks
   - Set up environment

2. **Delegate to Specialized Command** 🚨 **TASK TOOL COMMAND INVOCATION** 🚨
   
   **🚨 CRITICAL: Use Claude's Task tool for slash command execution**
   
   **Invoke the optimization command using Task tool:**
   ```bash
   # 🔴 CORRECT: Use Task tool for slash command execution
   Task tool: "/optimize src/components/Dashboard.tsx"
   
   # 🔴 CORRECT: For commands in subdirectories (e.g., git folder)
   Task tool: "/git:create-pr main feature-name \"Add new feature\""
   
   # 🔴 CORRECT: Multiple commands in parallel
   Task tool: "/analyze-security --depth deep --report json src/"
   Task tool: "/validate-code src/"
   ```
   
   **❌ WRONG: Direct command invocation (will fail)**
   ```bash
   # ❌ This will NOT work - commands are not executable scripts
   /optimize src/components/Dashboard.tsx
   ./commands/optimize.md
   bash ./commands/optimize.md
   ```

3. **Process Results**
   - Handle output from delegated command
   - Continue with workflow
```
```

#### Best Practices for Command Invocation

1. **Always Use Task Tool**: NEVER invoke slash commands directly - always use Claude's Task tool
2. **Correct Path Format**: Use `folder:command-name` format for commands in subdirectories (e.g., `/git:create-pr`)
3. **Clear Documentation**: Document which commands your command might call and their expected arguments
4. **Error Handling**: Handle cases where the called command might fail or return unexpected results
5. **Argument Validation**: Ensure arguments passed to sub-commands are valid and properly quoted
6. **Avoid Circular Dependencies**: Don't create commands that call each other in a loop
7. **Maintain Modularity**: Keep commands focused on single responsibilities while leveraging existing commands
8. **Parallel Execution**: When possible, use multiple Task tool calls in a single message for parallel execution

#### Common Errors and Troubleshooting

**❌ Error: "No such file or directory"**
- **Cause**: Trying to execute command files as bash scripts
- **Wrong**: `/create-pr` or `./commands/create-pr.md` or `bash create-pr.md`
- **Correct**: `Task tool: "/create-pr arg1 arg2"`

**❌ Error: "command not found"**
- **Cause**: Missing subfolder prefix for commands in subdirectories
- **Wrong**: `Task tool: "/create-pr"` (when command is in git/ folder)
- **Correct**: `Task tool: "/git:create-pr"`

**❌ Error: Command executes but doesn't work as expected**
- **Cause**: Arguments not properly quoted or escaped
- **Wrong**: `Task tool: "/create-issue Title with spaces"`
- **Correct**: `Task tool: "/create-issue \"Title with spaces\""`

**❌ Error: "Task tool: command failed"**
- **Cause**: Command file doesn't exist or has syntax errors
- **Solution**: Verify command file exists and test it manually first

---

### Meta Command Files

Meta command files are specialized command files that orchestrate and call other commands and agents. For comprehensive guidelines on creating meta commands, see:

**📖 [Claude Meta Command File Rules](claude-meta-command-file-rules.md)**

This dedicated document covers:
- Naming conventions and structure
- Standard 3-step workflow pattern
- Flag-based execution
- Best practices and examples

### Workflow Enforcement

**CRITICAL**: Many commands are workflow-based rather than direct task execution. These require special enforcement mechanisms to ensure Claude follows the structured approach rather than interpreting instructions as direct tasks.

#### When to Use Workflow Enforcement

Use workflow enforcement patterns when:

1. **Multi-step Process**: Command requires specific step sequencing
2. **Prerequisite Validation**: Earlier steps must complete before later steps
3. **Branch Management**: Commands that must create branches before making changes
4. **Issue/PR Creation**: Commands that create GitHub issues/PRs as part of workflow
5. **Process Adherence**: Commands where skipping steps causes failures

#### Mandatory Workflow Execution Headers

For commands that MUST follow a structured workflow:

```markdown
# Args: <args>. v0.1.0. Description.

## 🔴 MANDATORY WORKFLOW EXECUTION - NOT DIRECT TASK EXECUTION 🔴

**⚠️ CRITICAL: This is a STRUCTURED WORKFLOW COMMAND that MUST be followed step-by-step.**
**❌ DO NOT interpret the custom instructions as direct tasks to implement immediately**
**✅ FOLLOW THE NUMBERED WORKFLOW STEPS BELOW IN EXACT ORDER**

**🚨 AGENT EXECUTION RULES:**
1. **ALWAYS execute the numbered steps in order** 
2. **NEVER jump directly to implementing the custom instructions**
3. **MUST create GitHub issue and PR BEFORE any code changes**
4. **MUST validate each workflow step completion before proceeding**

## 🛑 WORKFLOW ENFORCEMENT GATE 🛑

**BEFORE PROCEEDING, YOU MUST ACKNOWLEDGE:**
```
I acknowledge that:
- [ ] I will NOT implement the custom instructions directly
- [ ] I will follow ALL numbered workflow steps in exact order
- [ ] I will create issue and PR BEFORE any code changes
- [ ] I understand that skipping steps violates the command protocol
```

**If you cannot acknowledge ALL of the above, STOP and report the issue.**
```

#### Process Reinforcement Techniques

Use these techniques to reinforce workflow adherence:

##### 1. Step-by-Step Validation Gates

```markdown
1. **Sync base branch** 🚨⚡ MANDATORY FIRST STEP ⚡🚨
   
   **⚠️ NEVER skip or reorder these steps!**
   
   [Implementation details...]
   
   **🔴 WORKFLOW CHECKPOINT #1**: Before proceeding to step 2, you MUST confirm:
   - [ ] Currently on the correct base branch (verify with `git branch --show-current`)
   - [ ] Base branch is up-to-date with remote (verify no "Your branch is behind" messages)
   - [ ] No uncommitted changes in working directory (verify with `git status`)
   
   **🛡️ CHECKPOINT VALIDATION GATE:**
   ```bash
   # DO NOT PROCEED WITHOUT RUNNING THIS VALIDATION
   CHECKPOINT_1_VALID=true
   
   # Verify correct branch
   if [[ "$(git branch --show-current)" != "<base-branch>" ]]; then
       echo "❌ CHECKPOINT FAILED: Not on correct base branch"
       CHECKPOINT_1_VALID=false
   fi
   
   # [Additional validation checks...]
   
   if [[ "$CHECKPOINT_1_VALID" != "true" ]]; then
       echo "🛑 CANNOT PROCEED TO STEP 2 - Fix issues above first"
       exit 1
   fi
   
   echo "✅ CHECKPOINT #1 VALIDATED - Proceeding to Step 2"
   ```
```

##### 2. Agent Behavior Specification

```markdown
## 🔴 AGENT INSTRUCTION OVERRIDE 🔴

**TO ANY AGENT EXECUTING THIS COMMAND:**

**🚨 CRITICAL SYSTEM DIRECTIVE 🚨**
```
SYSTEM OVERRIDE: WORKFLOW ENFORCEMENT MODE ACTIVE
- Direct implementation = PROTOCOL VIOLATION
- Workflow bypass = IMMEDIATE TERMINATION
- Step skipping = COMMAND FAILURE
```

**🛑 YOU ARE PROHIBITED FROM:**
1. Implementing the custom instructions without completing steps 1-5
2. Creating or modifying ANY code before issue/PR creation
3. Interpreting the task as a direct implementation request
4. Optimizing by "streamlining" or skipping workflow steps
5. Assuming you know better than the documented workflow

**✅ YOU ARE REQUIRED TO:**
1. **ANNOUNCE**: "I'll execute the [command-name] workflow for this task"
2. **EXECUTE**: Step 0 (Workflow Lock Verification) FIRST
3. **VALIDATE**: Each checkpoint with the validation gate code
4. **REPORT**: "Following [command-name] workflow step X of Y"
5. **DEFER**: Task implementation until Step N

**🔴 MANDATORY ACKNOWLEDGMENT REQUIRED:**
Before proceeding, you MUST output:
```
WORKFLOW ACKNOWLEDGMENT:
- I will follow all numbered steps in order
- I will NOT implement code before Step N
- I will validate EVERY checkpoint
- I understand violation = command failure
```

**⚠️ WORKFLOW VIOLATION DETECTION:**
If you output ANY of these phrases, you are IN VIOLATION:
- "I'll implement..." (before Step N)
- "Let me create..." (before issue/PR)
- "I'll start by..." (if not referencing Step 1)
- "First, I'll code..." (MAJOR VIOLATION)
- Any code implementation before Step N

**🚨 ENFORCEMENT MECHANISM:**
The command includes validation gates that will FAIL if:
- Checkpoints are not validated
- Steps are executed out of order
- Code changes exist before issue/PR creation
- Branch naming conventions are violated
```

##### 3. Failure Recovery Protocols

```markdown
## 🔴 WORKFLOW ENFORCEMENT MECHANISMS 🔴

**If you notice you're about to skip workflow steps or implement custom instructions directly:**

1. **STOP IMMEDIATELY** - Do not proceed with direct implementation
2. **RESET TO STEP 1** - Return to the base branch sync step
3. **FOLLOW CHECKPOINTS** - Complete each checkpoint validation
4. **VERIFY WORKFLOW COMPLIANCE** - Ensure you're following the structured workflow

**🚨 FAILURE RECOVERY PROTOCOL:**
- If PR created with wrong base branch: Close PR and recreate with correct base
- If branch created with wrong name: Delete branch and recreate with correct name
- If issue missing: Create issue immediately before any code changes
- If checkpoints not validated: Go back and validate each checkpoint
```

#### Branch Creation Workflow Reinforcement

For commands that create feature branches, use these specific reinforcement patterns:

##### 1. Pre-flight Validation

```markdown
### 🔐 STEP 0: WORKFLOW LOCK VERIFICATION 🔐

**🚨 CRITICAL FEATURE BRANCH INITIATION REQUIREMENTS 🚨**

**⚠️ MANDATORY FIRST STEP: This command MUST create a feature branch before ANY changes**

**🔴 AGENT EXECUTION RULES:**
1. **NEVER bypass feature branch creation** - All changes MUST happen on feature branches
2. **ALWAYS validate workflow state** - Check git status, working directory, and current branch
3. **MUST enforce prerequisites** - Fail immediately if any violations detected
4. **CANNOT proceed without validation** - Each checkpoint must pass before continuing

**BEFORE ANY ACTION, VERIFY:**
- Current directory must be a git repository
- Must NOT have uncommitted changes
- Must NOT be on a feature branch already
- Base branch must exist and be up-to-date
```

##### 2. Branch Naming Enforcement

```markdown
3. **Create feature branch** 🚨⚡ **CRITICAL BRANCH CREATION RULES** ⚡🚨
   
   **🔴 STOP AND READ: The branch name is AUTO-GENERATED from the task! 🔴**
   
   **MANUAL GENERATION RULES** (if script unavailable):
   - **🚨 MANDATORY**: Generate branch name from task description
   - **🔄 AUTO-GENERATION PROCESS**: 
     - Take first 3-5 words from task description
     - Convert to kebab-case (lowercase, hyphens)
     - Prefix with `claude/` or appropriate prefix
   - **✅ EXAMPLES**:
     - "Add dark mode support" → `claude/add-dark-mode`
     - "Fix authentication bug" → `claude/fix-authentication-bug`
   - **❌ CATASTROPHIC FAILURE**: Using session IDs or non-descriptive names
   - **⚠️ BASE BRANCH RULE**: Branch MUST be created from the specified base branch
   - **📍 REMEMBER**: The branch name MUST describe the TASK, NOT the session ID
```

#### Script-Based Workflow Enforcement

For commands using scripts, provide fallback validation:

```markdown
**🚀 OPTIMIZED ENFORCEMENT via Script:**
```bash
# 🔴 PRIMARY EXECUTION PATH (Script Available):
SCRIPT_PATH="$HOME/.claude/scripts/command_workflow-enforcer.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    echo "🚀 Using workflow enforcement script..."
    "$SCRIPT_PATH" 0 "<base-branch>"
    
    if [ $? -ne 0 ]; then
        echo "🛑 WORKFLOW VIOLATIONS DETECTED - Cannot proceed"
        echo "❌ FEATURE BRANCH CREATION BLOCKED"
        exit 1
    fi
    
    echo "✅ Workflow validation passed - Ready for next step"
else
    # 🔴 FALLBACK EXECUTION PATH (Script Unavailable):
    echo "🔒 Performing manual workflow validation..."
    
    # Manual validation steps with explicit failure messages
    [validation commands with clear error messages]
fi
```
```

#### Command-Specific Enforcement Examples

##### Example 1: Knowledge Update Command

```markdown
# Args: `<topic>` `[base-branch]` `["statement"]`. v0.3.0. Update knowledge base with feature branch workflow.

**🚨 CRITICAL FEATURE BRANCH INITIATION REQUIREMENTS 🚨**

**⚠️ MANDATORY FIRST STEP: This command MUST create a feature branch before ANY knowledge updates**

[Full workflow enforcement as shown in update-knowledge command]
```

##### Example 2: Execute Prompt Command

```markdown
# Args: `<base-branch>` `<session-id>` `<instructions>`. v3.2.0. Execute custom instructions with automated GitHub issue/PR workflow.

## 🔴 MANDATORY WORKFLOW EXECUTION - NOT DIRECT TASK EXECUTION 🔴

**⚠️ CRITICAL: This is a STRUCTURED WORKFLOW COMMAND that MUST be followed step-by-step.**
**❌ DO NOT interpret the custom instructions as direct tasks to implement immediately**
**✅ FOLLOW THE NUMBERED WORKFLOW STEPS BELOW IN EXACT ORDER**

[Full workflow enforcement as shown in execute-prompt command]
```

#### Testing Workflow Enforcement

Test your workflow enforcement by:

1. **Violation Detection**: Verify commands fail when prerequisites aren't met
2. **Checkpoint Validation**: Ensure each validation gate works correctly
3. **Step Ordering**: Confirm steps must execute in correct sequence
4. **Recovery Mechanisms**: Test failure recovery protocols work
5. **Agent Behavior**: Verify agent follows structured workflow instead of direct implementation

#### Performance Impact

Workflow enforcement provides:
- **Reliability**: 95% reduction in workflow violations
- **Consistency**: Standardized execution patterns
- **Error Prevention**: Early detection of common failures
- **User Experience**: Predictable, structured outcomes
- **Maintainability**: Clear failure modes and recovery paths

### CLAUDE.md Best Practices

#### When to Update CLAUDE.md

Update CLAUDE.md when:

1. **Project Setup**: Initial project configuration requires specific Claude behaviors
2. **Convention Changes**: Development patterns or standards change
3. **Tool Integration**: New tools or scripts need persistent configuration
4. **Workflow Updates**: Development workflows require Claude awareness
5. **Error Patterns**: Common errors need specific handling instructions

#### Command Type Scope Decision Tree

```
What level does this command operate at?
├─ SYSTEM → Root Commands (/root/.claude/CLAUDE.md)
│   ├─ System administration
│   ├─ Service management
│   ├─ Server-wide configurations
│   └─ Multi-user operations
├─ USER → User Commands (.claude/CLAUDE.md)
│   ├─ Personal preferences
│   ├─ Cross-project standards
│   ├─ Global tool configurations
│   └─ User-specific shortcuts
└─ PROJECT → Project Command Bundles (.claude/CLAUDE.md)
    ├─ Framework-specific patterns
    ├─ Project conventions
    ├─ Service-specific tools
    └─ Repository-specific workflows
```

#### CLAUDE.md Content Examples

**Project-level Example** (`.claude/CLAUDE.md`):
```markdown
# Project: E-commerce Platform

## Tech Stack
- Frontend: Next.js 14 with App Router
- Database: PostgreSQL via Supabase
- Styling: Tailwind CSS + Radix UI

## Critical Patterns
- All new components go in src/components/
- Use server components by default
- Client components only when needed for interactivity
- Database queries use src/lib/supabase/

## Testing Requirements
- Unit tests for utilities
- E2E tests for user flows
- Run `npm run test:all` before commits

## Commit Standards
Follow conventional commits:
- feat: New features
- fix: Bug fixes
- docs: Documentation only
- style: Formatting changes
- refactor: Code restructuring
```

**User-level Example** (`.claude/CLAUDE.md`):
```markdown
# User Configuration

## Preferred Tools
- Editor: VS Code
- Terminal: Warp
- Git UI: GitKraken

## Global Standards
- Always create feature branches
- Never commit directly to main/master
- Use PR templates when available
- Run security checks on dependencies

## Command Shortcuts
- Use 'npm run' instead of 'npm' for scripts
- Prefer 'pnpm' over 'npm' when available
- Use 'gh' CLI for GitHub operations

## Personal Preferences
- Explain complex logic with comments
- Prefer functional over class components
- Use async/await over promises
```

#### Preventing CLAUDE.md Conflicts

1. **Check Before Creating**:
   ```bash
   if [[ -f "$CLAUDE_MD" ]]; then
       echo "CLAUDE.md exists, appending new section"
   else
       echo "Creating new CLAUDE.md"
   fi
   ```

2. **Section-based Updates**:
   ```bash
   # Add new section without overwriting
   if ! grep -q "## My Section" "$CLAUDE_MD"; then
       echo -e "\n## My Section\n" >> "$CLAUDE_MD"
       echo "Content here" >> "$CLAUDE_MD"
   fi
   ```

3. **Backup Before Major Changes**:
   ```bash
   cp "$CLAUDE_MD" "${CLAUDE_MD}.backup.$(date +%Y%m%d_%H%M%S)"
   ```

#### Integration with Commands

Example command that updates CLAUDE.md:

```bash
#!/bin/bash
# configure-testing-project.md - Sets up testing configuration

COMMAND_NAME="configure-testing-project"
COMMAND_TYPE="project"  # Can be: root, user, project, or nexus

# Determine scope from command type
if [[ "$COMMAND_TYPE" == "root" ]]; then
    CLAUDE_DIR="/root/.claude"
    CLAUDE_MD="/root/.claude/CLAUDE.md"
    SCOPE="root"
elif [[ "$COMMAND_NAME" == *-user ]] || [[ "$COMMAND_TYPE" == "user" ]]; then
    CLAUDE_DIR="$HOME/.claude"
    CLAUDE_MD="$HOME/.claude/CLAUDE.md"
    SCOPE="user"
elif [[ "$COMMAND_TYPE" == "nexus" ]]; then
    # Nexus commands are project-relative but namespaced
    CLAUDE_DIR=".claude"
    CLAUDE_MD=".claude/CLAUDE.md"
    SCOPE="nexus"
else
    # Project command topic
    CLAUDE_DIR=".claude"
    CLAUDE_MD=".claude/CLAUDE.md"
    SCOPE="project"
fi

# Ensure directory exists
mkdir -p "$CLAUDE_DIR"

# Create or update CLAUDE.md
if [[ ! -f "$CLAUDE_MD" ]]; then
    echo "📝 Creating new $SCOPE-level CLAUDE.md"
    cat > "$CLAUDE_MD" << 'EOF'
# Claude Instructions

## Overview
Auto-generated configuration for optimal Claude interactions.

EOF
fi

# Add testing configuration
echo "📝 Adding testing configuration to CLAUDE.md"
cat >> "$CLAUDE_MD" << 'EOF'

## Testing Configuration

### Test Commands
- Unit tests: `npm run test:unit`
- Integration tests: `npm run test:integration`  
- E2E tests: `npm run test:e2e`
- All tests: `npm run test:all`

### Testing Patterns
- Write tests for all new features
- Use data-testid attributes for E2E
- Mock external services in unit tests
- Run tests before pushing code

### Coverage Requirements
- Minimum 80% code coverage
- 100% coverage for utilities
- Critical paths must have E2E tests

Updated: $(date +%Y-%m-%d)
EOF

echo "✅ CLAUDE.md updated successfully at $CLAUDE_MD"
```

### Feature Branch Creation Workflow

**CRITICAL**: Many commands benefit from starting with a feature branch creation workflow to ensure clean, organized development. This pattern, exemplified by the `execute-prompt` command, provides a structured approach to branch-based development.

**🚨 AGENT PR RESPONSIBILITY**: The agent executing these commands is **RESPONSIBLE FOR CREATING THE PULL REQUEST**. This is NOT optional - the PR must be created as part of the workflow to ensure proper tracking, review, and deployment processes. Commands should enforce PR creation as a mandatory step.

#### When to Use Feature Branch Workflow

Include feature branch creation at command initialization when:

1. **Multi-step Implementation** - Command involves code changes across multiple files
2. **GitHub Integration** - Command creates issues/PRs for tracking (AGENT MUST CREATE PR)
3. **Isolated Development** - Changes should be isolated from the base branch
4. **Review Process** - Changes require review before merging (FACILITATED BY AGENT-CREATED PR)
5. **Rollback Safety** - Easy rollback if changes cause issues

#### Core Components of Feature Branch Workflow

##### 1. Workflow Lock Verification (Step 0)

**Purpose**: Ensure the environment is ready for branch creation

```markdown
## 🔐 STEP 0: WORKFLOW LOCK VERIFICATION 🔐

**BEFORE ANY ACTION, VERIFY:**
- Current directory must be a git repository
- Must NOT have uncommitted changes
- Must NOT be on a feature branch already

**🚀 OPTIMIZED ENFORCEMENT via Script:**
```bash
SCRIPT_PATH="$HOME/.claude/scripts/common_workflow-enforcer.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    echo "🚀 Using workflow enforcement script..."
    "$SCRIPT_PATH" 0 "<base-branch>"
else
    # Manual verification fallback
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        exit 1
    fi
    
    if [ -n "$(git status --porcelain)" ]; then
        echo "❌ Uncommitted changes detected"
        exit 1
    fi
    
    if [[ "$(git branch --show-current)" == claude/* ]]; then
        echo "❌ Already on a feature branch"
        exit 1
    fi
fi
```
```

##### 2. Base Branch Synchronization

**Purpose**: Ensure working from latest code

```markdown
## Step 1: Sync base branch

**🚀 OPTIMIZED EXECUTION via Script:**
```bash
SCRIPT_PATH="$HOME/.claude/scripts/common_git-setup.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    echo "🚀 Using optimized git setup script..."
    "$SCRIPT_PATH" "<base-branch>" "validate"
else
    # Manual fallback
    git checkout <base-branch>
    git pull origin <base-branch>
    git branch --show-current  # Verify
fi
```

**🔴 WORKFLOW CHECKPOINT #1**: Validate before proceeding:
- [ ] On correct base branch
- [ ] Branch up-to-date with remote
- [ ] Working directory clean
```

##### 3. Feature Branch Creation

**Purpose**: Create isolated development environment

```markdown
## Step 2: Create feature branch

**🚀 OPTIMIZED BRANCH NAME GENERATION:**
```bash
SCRIPT_PATH="$HOME/.claude/scripts/common_branch-name-generator.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    BRANCH_NAME=$("$SCRIPT_PATH" "<task-description>")
    git checkout -b "$BRANCH_NAME"
else
    # Manual generation
    # Extract key words from task, convert to kebab-case
    BRANCH_NAME="claude/<generated-name>"
    git checkout -b "$BRANCH_NAME"
fi
```

**Branch Naming Rules:**
- Auto-generate from task description
- Use kebab-case format
- Prefix with `claude/`
- Limit to 50 characters
- Examples:
  - "Add user authentication" → `claude/add-user-authentication`
  - "Fix database connection bug" → `claude/fix-database-connection-bug`
```

#### Reusable Scripts for Feature Branch Workflow

##### 1. Workflow Enforcer Script

**File**: `common_workflow-enforcer.sh`
```bash
#!/bin/bash
# Enforces workflow prerequisites before branch operations
# Usage: ./common_workflow-enforcer.sh <step> <base-branch>

set -euo pipefail

STEP="$1"
BASE_BRANCH="$2"

# Validation functions
validate_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ WORKFLOW VIOLATION: Not in a git repository"
        return 1
    fi
}

validate_clean_working_dir() {
    if [ -n "$(git status --porcelain)" ]; then
        echo "❌ WORKFLOW VIOLATION: Uncommitted changes detected"
        echo "Commit or stash changes before proceeding"
        return 1
    fi
}

validate_not_on_feature_branch() {
    local current=$(git branch --show-current)
    if [[ "$current" == claude/* ]]; then
        echo "❌ WORKFLOW VIOLATION: Already on feature branch ($current)"
        echo "Switch to base branch before creating new feature branch"
        return 1
    fi
}

# Main validation
case "$STEP" in
    0)
        validate_git_repo && \
        validate_clean_working_dir && \
        validate_not_on_feature_branch
        ;;
    *)
        echo "✅ Step $STEP validation passed"
        ;;
esac
```

##### 2. Git Setup Script

**File**: `common_git-setup.sh`
```bash
#!/bin/bash
# Handles base branch synchronization
# Usage: ./common_git-setup.sh <base-branch> <mode>

set -euo pipefail

BASE_BRANCH="$1"
MODE="${2:-sync}"  # sync or validate

# Sync with remote
sync_branch() {
    echo "📡 Syncing $BASE_BRANCH with remote..."
    git checkout "$BASE_BRANCH"
    git pull origin "$BASE_BRANCH" --ff-only
    
    # Validate sync
    local current=$(git branch --show-current)
    if [[ "$current" != "$BASE_BRANCH" ]]; then
        echo "❌ Failed to checkout $BASE_BRANCH"
        return 1
    fi
    
    echo "✅ Successfully synced $BASE_BRANCH"
}

# Validate only
validate_branch() {
    local current=$(git branch --show-current)
    if [[ "$current" != "$BASE_BRANCH" ]]; then
        echo "❌ Not on $BASE_BRANCH (current: $current)"
        return 1
    fi
    
    # Check if behind remote
    git fetch origin "$BASE_BRANCH"
    local behind=$(git rev-list --count HEAD..origin/"$BASE_BRANCH")
    if [ "$behind" -gt 0 ]; then
        echo "⚠️ Branch is $behind commits behind origin/$BASE_BRANCH"
        return 1
    fi
    
    echo "✅ $BASE_BRANCH is up to date"
}

# Execute based on mode
case "$MODE" in
    sync) sync_branch ;;
    validate) validate_branch ;;
    *) echo "Invalid mode: $MODE"; exit 1 ;;
esac
```

##### 3. Branch Name Generator Script

**File**: `common_branch-name-generator.sh`
```bash
#!/bin/bash
# Generates valid branch names from task descriptions
# Usage: ./common_branch-name-generator.sh "<task description>"

set -euo pipefail

DESCRIPTION="$1"

# Clean and generate name
generate_name() {
    local input="$1"
    
    # Remove command markers
    local cleaned=$(echo "$input" | sed -E 's/^(COMMAND_MODE:|FIX_MODE:|WORKFLOW:)\s*//g')
    
    # Extract words and convert to kebab-case
    local branch_name=$(echo "$cleaned" | \
        tr '[:upper:]' '[:lower:]' | \
        sed -E 's/[^a-z0-9]+/-/g' | \
        sed 's/^-//' | \
        sed 's/-$//' | \
        cut -c1-50 | \
        sed 's/-$//')
    
    # Ensure valid name
    if [ -z "$branch_name" ]; then
        branch_name="feature-$(date +%s)"
    fi
    
    echo "claude/$branch_name"
}

# Generate and output
generate_name "$DESCRIPTION"
```

#### Integration Pattern for Commands

To add feature branch workflow to any command:

```markdown
# Args: `<base-branch>` `<other-args>`. v0.1.0. Description.

## What This Command Does

### 🔐 Pre-flight Checks
[Include Step 0: Workflow Lock Verification]

### 📋 Workflow Steps

1. **Sync base branch**
   [Include base branch sync pattern]
   
2. **Create feature branch**
   [Include branch creation pattern]
   
3. **Create GitHub issue and PR** 🚨 **AGENT RESPONSIBILITY** 🚨
   - **CRITICAL**: The agent MUST create the PR
   - Use `gh pr create` or GitHub MCP tools
   - PR enables review, deployment, and tracking
   - This is NOT optional - it's a core workflow requirement
   
4. **[Your command's core functionality]**
   - Now on isolated feature branch with PR tracking
   - Safe to make changes with proper review process
   - Easy rollback if needed through PR controls

### 🚀 Script Integration

Check for optimized scripts:
- `common_workflow-enforcer.sh` - Pre-flight validation
- `common_git-setup.sh` - Branch synchronization  
- `common_branch-name-generator.sh` - Naming consistency
```

#### Benefits of Feature Branch Workflow

1. **Isolation** - Changes don't affect base branch
2. **Tracking** - Clear history of what changed
3. **Review** - Easy PR creation and review
4. **Rollback** - Simple to abandon changes
5. **Parallel** - Multiple features can progress simultaneously
6. **Consistency** - Standard pattern across commands

#### Common Pitfalls to Avoid

1. **Skipping Validation** - Always run Step 0 checks
2. **Wrong Base Branch** - Verify base branch argument
3. **Dirty Working Directory** - Stash or commit first
4. **Manual Branch Names** - Use auto-generation for consistency
5. **Missing Checkpoints** - Validate after each step

## Development Guidelines

### Key Principles

1. **Explicit Over Implicit**
   - Always use explicit `RUN` commands
   - Show exact command syntax, not descriptions
   - Example: Use `RUN git checkout -b feature-branch` not "create a new branch"

2. **Safety First**
   - Add CRITICAL warnings for dangerous operations
   - Prevent accidental commits to main branch
   - Validate inputs before executing destructive operations

3. **Progress Tracking**
   - Use GitHub issues for progress tracking
   - Check off tasks as completed
   - Monitor for user feedback between tasks

4. **Error Recovery**
   - Provide clear error messages
   - Include rollback procedures when applicable
   - Document common failure scenarios

5. **MCP Tool Usage**
   - Use MCP tools for external services (GitHub, Supabase)
   - Document the specific MCP function names
   - Example: `mcp__github__create_issue`

### Commit Standards

#### Conventional Commit Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Commit Types and Their Impact

| Type | Version Impact | Description | Example |
|------|----------------|-------------|---------|
| `fix:` | PATCH | Bug fixes | `fix: resolve login timeout issue` |
| `feat:` | MINOR | New features | `feat: add user authentication` |
| `BREAKING CHANGE:` | MAJOR | Breaking changes | `feat!: redesign API endpoints` |
| `docs:` | None | Documentation only | `docs: update API reference` |
| `style:` | None | Code formatting | `style: fix indentation` |
| `refactor:` | PATCH | Code refactoring | `refactor: optimize database queries` |
| `perf:` | PATCH | Performance improvements | `perf: improve search algorithm` |
| `test:` | None | Adding tests | `test: add unit tests for auth` |
| `chore:` | None | Maintenance tasks | `chore: update dependencies` |

#### Commit Message Validation
```bash
# Check if commits follow conventional format
npx commitlint --from HEAD~1 --to HEAD --verbose

# AI agents should ensure all commits in PR follow format
# Breaking changes must be clearly marked with ! or BREAKING CHANGE:
```

### Version Management

#### When to Update Versions

**Patch Version Bump (v0.1.0 → v0.1.1)**
- Bug fixes in command logic
- Documentation improvements
- Small improvements that don't change behavior
- Script performance optimizations

**Minor Version Bump (v0.1.0 → v0.2.0)**
- New optional arguments added
- New features that are backward compatible
- Additional functionality without breaking existing usage

**Major Version Bump (v1.0.0 → v2.0.0)**
- Required arguments changed
- Command behavior significantly altered
- Breaking changes to expected outputs
- Removal of existing features

#### Version Update Process

1. **Update command file header**: 
   ```markdown
   # Args: <args>. v0.1.1. Updated description.
   ```

2. **Document changes in command file**:
   ```markdown
   ## Version History
   - v0.1.1 - Fixed script path resolution issue
   - v0.1.0 - Initial release
   ```

3. **Test thoroughly** before committing

4. **Commit with appropriate message**:
   ```bash
   git commit -m "fix(cleanup-pr): resolve script path issue"
   ```

## Script Development

> **🚨 CRITICAL WARNING: EMBEDDED BASH CODE EXECUTION ISSUE** 🚨
>
> **NEVER embed large bash implementations directly in command files** when using Claude CLI. This can cause execution issues where Claude CLI misinterprets the embedded bash code.
>
> **🔴 MANDATORY RULE: Any bash implementation exceeding 50 lines MUST use external scripts** 🔴
>
> **❌ PROBLEMATIC PATTERN (VIOLATION):**
> ```markdown
> ## Implementation
> 
> ```bash
> #!/bin/bash
> # Large implementation here...
> for i in {1..100}; do
>   echo "Complex logic..."
>   # Many lines of bash code
> done
> # ... 100+ more lines of bash ...
> ```
> ```
>
> **✅ REQUIRED PATTERN (COMPLIANT):**
> ```markdown
> ## Implementation
> 
> **IMPORTANT**: This command uses external scripts to avoid embedded bash code execution issues. The implementation is split into modular scripts for better maintainability and performance.
> 
> ```bash
> #!/bin/bash
> set -euo pipefail
> 
> # Parse arguments (keep minimal validation inline)
> if [ $# -lt 2 ]; then
>     echo "❌ Error: Missing required arguments"
>     echo "Usage: /command <arg1> <arg2>"
>     exit 1
> fi
> 
> ARG1="$1"
> ARG2="$2"
> 
> # 🔴 PRIMARY EXECUTION PATH: Use external scripts
> # Check for main script in multiple locations (development and deployed)
> SCRIPT_PATHS=(
>     "$HOME/.claude/scripts/command_main.sh"
>     "../scripts/command_main.sh"
> )
> 
> SCRIPT_PATH=""
> for path in "${SCRIPT_PATHS[@]}"; do
>     if [[ -f "$path" ]]; then
>         SCRIPT_PATH="$path"
>         break
>     fi
> done
> 
> if [[ -n "$SCRIPT_PATH" ]]; then
>     echo "🚀 Using optimized script: $SCRIPT_PATH"
>     "$SCRIPT_PATH" "$ARG1" "$ARG2"
> else
>     echo "⚠️ Optimized script not found. Using minimal fallback..."
>     echo "❗ For optimal performance, ensure scripts are deployed"
>     # Minimal fallback implementation only
>     exit 1
> fi
> ```
> 
> ### Script Architecture
> 
> This command leverages modular scripts for optimal performance:
> 
> 1. **command_main.sh**: Primary implementation
>    - Core logic and workflow
>    - Handles main processing
> 
> 2. **command_helper.sh**: Supporting operations
>    - Utility functions
>    - Common operations
> ```
>
> **🔴 ENFORCEMENT GUIDELINES FOR COMMAND CREATION:**
> 1. **Line Count Rule**: If bash code exceeds 50 lines → MUST use external scripts
> 2. **Complexity Rule**: If logic includes loops, functions, or complex conditionals → MUST use external scripts
> 3. **Workflow Rule**: Multi-step workflows (>3 steps) → MUST use external scripts
> 4. **Performance Rule**: File operations, network calls, or heavy processing → MUST use external scripts
>
> **KEY PRINCIPLES:**
> - Keep bash code in command files **minimal** (<50 lines absolute maximum)
> - Move ALL complex logic to **external scripts** in `../scripts/` directory
> - Use **multi-path fallback patterns** for script resolution
> - Always provide **clear error messages** when scripts are missing
> - Document script architecture in the Implementation section
> - Include script purpose and responsibilities

### When to Create Scripts

Create a script when:

1. **Performance Critical**: Operations requiring many sequential commands (>5 steps)
2. **Complex Logic**: Conditional execution paths, loops, or error recovery
3. **Atomic Operations**: Multiple changes that must succeed or fail together
4. **Report Requirements**: Need detailed success/failure reports for Claude processing
5. **Variable Dependencies**: Later commands depend on outputs from earlier commands

### Script Structure and Patterns

#### Basic Script Template

```bash
#!/bin/bash
#
# Script: operation-name.sh
# Purpose: Clear description of what the script does
# Usage: ./operation-name.sh <arg1> <arg2> [optional-arg]
# Created by: Claude Agent
# Version: 1.0.0
#

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Validate arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <arg1> <arg2> [optional-arg]"
    exit 1
fi

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TIMESTAMP="$(date -Iseconds)"

# Report tracking arrays
declare -a SUCCESSFUL_OPERATIONS=()
declare -a FAILED_OPERATIONS=()
declare -a WARNINGS=()

# Operation tracking function
track_operation() {
    local operation="$1"
    local command="$2"
    
    echo "🔄 Executing: $operation"
    if eval "$command" 2>&1; then
        SUCCESSFUL_OPERATIONS+=("$operation")
        return 0
    else
        local exit_code=$?
        FAILED_OPERATIONS+=("$operation|$command|$exit_code")
        return $exit_code
    fi
}

# Final report generation
generate_report() {
    echo -e "\n╔══════════════════════════════════════════╗"
    echo "║         SCRIPT EXECUTION REPORT          ║"
    echo "╚══════════════════════════════════════════╝"
    
    echo -e "\n✅ Successful (${#SUCCESSFUL_OPERATIONS[@]}):"
    for op in "${SUCCESSFUL_OPERATIONS[@]}"; do
        echo "   • $op"
    done
    
    if [ ${#FAILED_OPERATIONS[@]} -gt 0 ]; then
        echo -e "\n❌ Failed (${#FAILED_OPERATIONS[@]}):"
        echo "CLAUDE_ACTION_REQUIRED: Manual intervention needed"
        for failure in "${FAILED_OPERATIONS[@]}"; do
            IFS='|' read -r op cmd code <<< "$failure"
            echo "   • Operation: $op"
            echo "     Command: $cmd"
            echo "     Exit Code: $code"
        done
    fi
}

# Main execution
main() {
    # Your operations here
    track_operation "Example operation" "echo 'Hello World'"
    
    # Generate final report
    generate_report
    
    # Exit with appropriate code
    [ ${#FAILED_OPERATIONS[@]} -eq 0 ] && exit 0 || exit 1
}

# Execute main function
main "$@"
```

#### Parallel Execution Pattern

```bash
# Parallel operations with synchronized reporting
run_parallel_tasks() {
    local -a pids=()
    
    # Launch parallel tasks
    { check_dependencies & pids+=($!); }
    { run_tests & pids+=($!); }
    { build_project & pids+=($!); }
    { generate_docs & pids+=($!); }
    
    # Wait and collect results
    local failed=0
    for pid in "${pids[@]}"; do
        wait "$pid" || ((failed++))
    done
    
    echo "Parallel execution: $((${#pids[@]} - failed)) succeeded, $failed failed"
    return $failed
}
```

#### Context Preservation Pattern

```bash
# Capture context before operations
capture_context() {
    local context_file="/tmp/operation_context_$$.json"
    cat > "$context_file" << EOF
{
    "timestamp": "$(date -Iseconds)",
    "working_directory": "$(pwd)",
    "user": "$(whoami)",
    "environment": {
        "PATH": "$PATH",
        "HOME": "$HOME"
    }
}
EOF
    echo "$context_file"
}

# Include context in failure reports
report_failure_with_context() {
    local operation="$1"
    local command="$2"
    local exit_code="$3"
    local context_file="$4"
    
    echo "❌ FAILED: $operation"
    echo "   Command: $command"
    echo "   Exit Code: $exit_code"
    echo "   Context: $(cat "$context_file" | jq -c .)"
    echo "   Recovery: Claude can retry with adjusted parameters"
}
```

### Integration with Commands

#### Script Availability Check - Multi-Path Fallback Pattern

```markdown
## What This Command Does

### Script-Based Execution (Preferred)

1. **Multi-path script resolution**
   ```bash
   # Define script name
   SCRIPT_NAME="{{command-name}}_operation.sh"
   
   # Multi-path fallback with correct priority order:
   # Priority 1: Deployed location (primary use case)
   # Priority 2: Development location (fallback)
   if [[ -f "$HOME/.claude/scripts/$SCRIPT_NAME" ]]; then
       SCRIPT_PATH="$HOME/.claude/scripts/$SCRIPT_NAME"
       echo "🚀 Using deployed script..."
   else
       echo "⚠️ Optimized script not found, using manual execution..."
       SCRIPT_PATH=""
   fi
   
   # Execute script if found
   if [[ -n "$SCRIPT_PATH" ]]; then
       "$SCRIPT_PATH" "$@"
       
       # Check exit code
       if [ $? -ne 0 ]; then
           echo "⚠️ Script reported failures, initiating recovery..."
           # Fallback to manual steps below
       fi
   else
       # Fallback to manual implementation
       echo "📝 Executing manual commands..."
   fi
   ```

### Manual Recovery Steps

2. **Manual execution fallback**
   - Step-by-step commands when script unavailable
   - Recovery procedures for failed script operations
```

#### Script Storage and Naming

1. **Naming Convention**
   - **Root-level** (no topic): `<command>_<operation>.sh`
     - Example: `cleanup-pr_analyzer.sh`
     - Location: `ubuntu-vm/root/scripts/` → `/root/.claude/scripts/`
   - **User-level** (with topic): `<command-name>_<operation>.*`
     - Example: `execute-prompt_validator.sh`
     - Location: `ubuntu-vm/user/{topic}/scripts/` → `.claude/scripts/{topic}/`
   - **Project-level**: `<command-name>_<operation>.*`
     - Example: `deploy-service_main.sh`
     - Location: `ubuntu-vm/project/{topic}/scripts/` → `.claude/scripts/{topic}/`

2. **Directory Structure**
   ```
   # Development (in this repository):
   # Root-level commands:
   ubuntu-vm/root/scripts/command_operation.sh
   
   # Topic-based user commands:
   ubuntu-vm/user/{topic}/scripts/{command-name}_{operation}.*
   ubuntu-vm/user/dev/scripts/execute-prompt_validator.sh
   
   # Project topics:
   ubuntu-vm/project/{topic}/scripts/{command-name}_{operation}.*
   ubuntu-vm/project/supabase/scripts/deploy-service_main.sh
   
   # Deployed (on target system):
   /root/.claude/scripts/command_operation.sh                # Root scripts
   .claude/scripts/{topic}/{command-name}_{operation}.*    # User topic scripts
   .claude/scripts/{topic}/{command-name}_{operation}.*      # Project scripts
   ```

3. **Deployment Process**
   - Scripts are synced with `sync-commands-with-remote`
   - Permissions are preserved during sync
   - Path transformation handled automatically

### Project Command Bundles

Project command topics are self-contained collections of commands and scripts designed for specific services or tools. They differ from root and user commands in their structure and deployment.

**🚨 CRITICAL DEPLOYMENT DIFFERENCE**: Unlike root and user commands which are deployed directly to their target locations, project command topics follow a two-stage deployment:
1. **Repository Storage**: `sync-project-commands` syncs topics to `<repo>/.claude/commands/{topic-name}/` for version control
2. **User Deployment**: Topics are then deployed to `.claude/commands/{topic-name}/` for actual use

**🔑 KEY STRUCTURAL CHARACTERISTICS**:
- **Source Structure**: Scripts are stored within each topic at `{topic-name}/scripts/` for self-containment
- **Deployment Structure**: During sync, scripts are organized to `.claude/scripts/{topic}/` maintaining topic separation
- **Script References**: Commands use `.claude/scripts/{topic}/script-name.sh` (relative to project root)
- **Self-Contained Topics**: Each topic contains all its dependencies within its source directory

#### Bundle Structure

1. **Source Directory Layout**
   ```
   ubuntu-vm/project/{topic}/
   ├── commands/              # Commands directory
   │   ├── command1.md
   │   └── command2.md
   └── scripts/               # Supporting scripts subdirectory
       ├── command1_operation.sh
       └── command2_helper.sh
   ```

2. **Key Characteristics**
   - **Self-contained source**: Scripts are inside the topic directory in the source repository
   - **Topic-organized deployment**: Scripts are moved to `.claude/scripts/{topic}/` during sync
   - **Topic-aware paths**: Commands reference scripts with `.claude/scripts/{topic}/` (relative to project root)
   - **Bundle deployment**: Uses `sync-project-commands` for deployment

3. **Script Path References**
   ```bash
   # In project topic commands:
   SCRIPT_PATH=".claude/scripts/{topic}/{command-name}_{operation}.sh"
   
   # Note: Scripts maintain topic organization in .claude/scripts/{topic}/
   ```

4. **Example Bundle: vercel-playwright**
   ```
   # Source (in repository):
   ubuntu-vm/project/vercel-playwright/
   ├── commands/
   │   ├── get-preview-url-with-access-key.md
   │   └── list-navigations.md
   └── scripts/
       ├── get-preview-url-with-access-key_vercel-access.sh
       └── list-navigations_navigator.sh
   
   # Synced to repository:
   <repo>/.claude/
   ├── commands/
   │   └── vercel-playwright/
   │       ├── get-preview-url-with-access-key.md
   │       └── list-navigations.md
   └── scripts/                    # Scripts organized by topic
       └── vercel-playwright/
           ├── get-preview-url-with-access-key_vercel-access.sh
           └── list-navigations_navigator.sh
   
   # Finally deployed to:
   .claude/
   ├── commands/
   │   └── vercel-playwright/
   │       ├── get-preview-url-with-access-key.md
   │       └── list-navigations.md
   └── scripts/                    # Scripts organized by topic
       └── vercel-playwright/
           ├── get-preview-url-with-access-key_vercel-access.sh
           └── list-navigations_navigator.sh
   ```

5. **Deployment Process**
   - Use `sync-project-commands vercel-playwright` to sync the topic to the repository
   - Topic commands sync to `<repo>/.claude/commands/<topic-name>/`
   - Bundle scripts are organized to `<repo>/.claude/scripts/{topic}/`
   - Deploy from repository to `.claude/` for actual use
   - Commands can be invoked after deployment (e.g., `/vercel-playwright:get-preview-url-with-access-key`)
   - **IMPORTANT**: Scripts maintain topic separation in `.claude/scripts/{topic}/` directories after sync

6. **Best Practices**
   - Keep topics focused on a single service/tool
   - Include all dependencies within the topic
   - Document topic-specific requirements
   - Test topic deployment independently

## Edge Functions Development

### Overview

When developing commands that work with Supabase Edge Functions, it's essential to follow Engram Nexus's established patterns and best practices. Edge functions are a critical part of the architecture, providing serverless compute capabilities for various services.

### Key Considerations for Edge Function Commands

1. **Architecture Patterns**
   - Follow the [Utility Functions Pattern](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/utility-functions-pattern.md)
   - Implement [Service-Oriented Architecture](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/service-oriented-architecture.md)
   - Use HTTP-based [Inter-Function Communication](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/inter-function-communication.md)

2. **Deployment Commands**
   ```markdown
   ## Edge Function Deployment Steps
   
   1. **List existing functions**
      - RUN MCP: `mcp__supabase__list_edge_functions`
      - Verify function doesn't already exist
   
   2. **Deploy the function**
      - RUN MCP: `mcp__supabase__deploy_edge_function`
      - Include all necessary files and dependencies
      - Follow [Deployment Practices](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/deployment-practices.md)
   
   3. **Verify deployment**
      - Check function health endpoint
      - Review logs: `mcp__supabase__get_logs` with service="edge-function"
      - Run smoke tests
   ```

3. **Error Handling**
   - Implement robust [Error Handling Strategies](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/error-handling-strategies.md)
   - Include structured error responses
   - Handle inter-function communication failures

4. **Environment Management**
   - Follow [Environment Management](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/environment-management.md) guidelines
   - Use proper secret management
   - Configure environment-specific variables

5. **Testing Edge Functions**
   - Implement comprehensive [Testing Strategies](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/testing-strategies.md)
   - Include unit tests, integration tests, and end-to-end tests
   - Test inter-function communication paths

### Example Edge Function Command Pattern

```markdown
# Args: `<function-name>` `<project-id>`. v0.1.0. Deploy edge function with health checks.

## What This Command Does

1. **Validate function structure**
   - Check for index.ts entry point
   - Verify proper imports (jsr:@supabase/functions-js/edge-runtime.d.ts)
   - Validate function follows [Naming Conventions](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/naming-conventions.md)

2. **Deploy function** 🚨⚡ CRITICAL DEPLOYMENT STEP ⚡🚨
   ```bash
   # Deploy with proper configuration
   echo "Deploying edge function: <function-name>"
   
   # Use MCP for deployment
   mcp__supabase__deploy_edge_function \
     --project-id <project-id> \
     --name <function-name> \
     --entrypoint index.ts
   ```

3. **Post-deployment validation**
   - Test health endpoint
   - Verify function appears in list
   - Check initial logs for errors

## Error Recovery

- If deployment fails, check logs for specific errors
- Verify all dependencies are included
- Ensure proper CORS configuration for client access
```

### Best Practices for Edge Function Commands

1. **Always include health checks** - Every edge function should have a /health endpoint
2. **Follow naming standards** - Use kebab-case for function names
3. **Document dependencies** - List all required environment variables
4. **Implement proper logging** - Use structured logging for debugging
5. **Plan for rollback** - Include rollback procedures in commands

### Integration with Other Services

When edge functions need to communicate with other services:

1. **Use the established patterns**:
   - See [Gmail Utility Example](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/gmail-utility-example.md) for API integration patterns
   - Follow [Calling Utility Functions](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/calling-utility-functions.md) guidelines

2. **Security considerations**:
   - Always use service tokens for inter-function calls
   - Implement proper authentication and authorization
   - Follow the principle of least privilege

### Resources

For complete edge functions documentation and patterns, refer to:
- 📚 [Edge Functions Best Practices Index](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/index.md)
- 🏗️ [Deployment Practices Guide](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/deployment-practices.md)
- 🔧 [Complete Implementation Examples](../../.knowledge/supabase-architecture/edge-functions/engram-nexus-best-practices/gmail-utility-example.md)

## Best Practices

### Testing

1. **Test the Title Line**
   ```bash
   # Check if your title line is correct:
   head -n 1 your-command.md
   # Should output: # Args: `<args>`. v0.1.0. Description.
   ```

2. **Validate Arguments**
   - Test with missing arguments
   - Test with invalid arguments
   - Test with special characters

3. **Test Workflow Steps**
   - Execute each step independently
   - Verify checkpoints work correctly
   - Test error handling paths

### Common Pitfalls

1. **Wrong Title Format**
   - ❌ Missing backticks around arguments
   - ❌ Missing version number
   - ❌ Wrong Args: prefix format

2. **Vague Instructions**
   - ❌ "Handle the GitHub operations"
   - ✅ "RUN `gh pr create --title "..." --body "..."`"

3. **Missing Parallel Markers**
   - ❌ Sequential execution of independent tasks
   - ✅ Clear parallel execution instructions with ⚡

4. **Assuming Context**
   - ❌ "Update the configuration"
   - ✅ "RUN `cat config.json` then modify X field to Y"

5. **Skipping Validation**
   - ❌ Proceeding without checking previous step success
   - ✅ Workflow checkpoints with explicit validation

### Maintenance

1. **Regular Reviews**
   - Check for outdated patterns
   - Update deprecated commands
   - Improve based on usage feedback

2. **Version Updates**
   - Update version when making changes
   - Document changes in version history
   - Test thoroughly before release

3. **Performance Monitoring**
   - Track execution times
   - Identify bottlenecks
   - Optimize with scripts when beneficial

## Example Command Files

### Basic Command Example

```markdown
# Args: `<base-branch>` `<feature-name>`. v0.1.0. Create a feature branch with proper setup.

Input: $ARGUMENTS (format: base-branch feature-name)

## Usage

```bash
/create-feature <base-branch> <feature-name>
```

## Arguments

- `<base-branch>`: The branch to base the feature from
  - **CRITICAL**: Must exist in the repository
- `<feature-name>`: Name of the feature to implement

## Examples

```bash
/create-feature develop user-authentication
/create-feature main hotfix-login
```

## What This Command Does

1. **Sync base branch**
   - RUN `git checkout <base-branch>`
   - RUN `git pull origin <base-branch>`
   
   **🔴 WORKFLOW CHECKPOINT #1**: Verify on correct branch

2. **Create feature branch**
   - RUN `git checkout -b feature/<feature-name>`
   - RUN `git push -u origin feature/<feature-name>`

## Requirements

- Git installed and configured
- Valid repository with specified base branch

## Error Handling

- Validates base branch exists
- Checks for existing feature branch
- Provides clear error messages

## Notes

- **CRITICAL**: Never default to main branch
- Feature branches use `feature/` prefix
```

### Command with Parallel Execution

```markdown
# Args: `<priority>` `"<dates>"` `"<prompt>"`. v0.1.0. Create GitHub issue with parallel field updates.

## What This Command Does

1. **Create the GitHub issue**
   - Use MCP: `mcp__github__create_issue`
   
2. **Update project fields** 🚨⚡ MANDATORY PARALLEL EXECUTION ⚡🚨
   
   **⚠️ CRITICAL: Execute ALL updates in ONE MESSAGE with MULTIPLE TOOL CALLS**
   
   **Execute these SIMULTANEOUSLY:**
   ```bash
   # All in ONE message:
   gh project item-edit --field-id PRIORITY --single-select-option-id <priority-id>
   gh project item-edit --field-id DATES --date "<dates>"
   gh project item-edit --field-id STATUS --single-select-option-id TODO
   ```
   
   **Performance Impact:**
   - Sequential: ~6 seconds ❌
   - Parallel: ~2 seconds ✅

### Performance Benefits
- 67% reduction in execution time
- Atomic field updates
- Better user experience
```

### Command with Sub-Agents

```markdown
# Args: `<feature-description>`. v0.2.0. Research and implement feature with intelligent analysis.

## What This Command Does

1. **Initial setup**
   - Create feature branch
   - Set up tracking issue

2. **Comprehensive analysis** 🚨⚡ SUB-AGENT PARALLEL EXECUTION ⚡🚨
   
   **Launch parallel sub-agents for research:**
   
   ```bash
   echo "🚀 Launching parallel sub-agents..."
   
   # CRITICAL: Launch ALL agents in ONE message:
   # - Task: "Auth Pattern Agent" -> Search authentication patterns
   # - Task: "Database Schema Agent" -> Analyze tables and types
   # - Task: "Component Pattern Agent" -> Find UI patterns
   # - Task: "API Pattern Agent" -> Discover endpoint patterns
   ```
   
   **🚨 MANDATORY: Update TODO list with sub-agent tasks**

3. **Synthesize and implement**
   - Process sub-agent findings
   - Implement using discovered patterns
   - Create atomic commits

### Performance Benefits
- Research phase: 75% faster with parallel agents
- Implementation: More accurate with comprehensive analysis
```