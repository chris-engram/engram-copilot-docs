# Args: `<base-branch>` `<figma-export-path>` `[custom-instructions]`. v0.3.0. Insert Figma Make generated code into existing applications by delegating conversion to the design:convert-to-react agent and validation to vercel:validate-deployment agent.

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
- [ ] I will follow ALL workflow steps in exact order
- [ ] I will create issue and PR BEFORE any code changes
- [ ] I understand that skipping steps violates the command protocol
```

**If you cannot acknowledge ALL of the above, STOP and report the issue.**

## 🔴 CRITICAL BRANCH NAMING ALERT 🔴

**CRITICAL BRANCH NAMING RULES:**
- Branch name is automatically generated from the custom instructions
- Uses kebab-case format (e.g., "apply-figma-header-styles", "update-button-components")
- Generated from the first few words of the custom instructions or default to "apply-figma-styles"
- **NEVER** use random identifiers for branch naming

**REMEMBER: Git branch = `claude/` + auto-generated name from instructions!**

Input: dev design/figma-export.zip "Apply header and navigation styling from Figma" (format: base-branch figma-export-path "custom instructions")

## Usage

```bash
# Insert Figma code into existing app
/insert-design-code main design/header-export.zip "Insert header component code"
#                       ↑                ↑                        ↑
#                       │                │                        │
#                  base branch      zip file path          instructions
#                                                 │
#                                                 └─→ Auto-generated branch: claude/insert-header-component-code ✅

# Update button components with Figma code
/insert-design-code develop design/buttons.zip "Update all button components with new Figma code"
#                       ↑               ↑                              ↑
#                       │               │                              │
#                  base branch     zip file path                  instructions
#                                                       │
#                                                       └─→ Auto-generated branch: claude/update-all-button-components ✅
```

## Arguments

- `<base-branch>`: The branch to sync from and PR target (e.g., `main`, `develop`)
  - **🎯 CRITICAL**: This is BOTH the source branch AND the PR target
  - **🔴 BASE BRANCH = Where your PR will be merged INTO**
  - **⚠️ NEVER** default to main - use exact branch specified
- `<figma-export-path>`: Relative path from repo root to the Figma Make exported zip file
  - Example: `design/header-export.zip`
  - Example: `ui/figma-exports/dashboard.zip`
- `[custom-instructions]`: Optional specific instructions for code insertion
  - Default: "Insert Figma Make code into existing application"
  - **🚨 CRITICAL**: Branch name is auto-generated from these instructions
  - **🔄 AUTO-GENERATION**: First few words converted to kebab-case

## Examples

```bash
# Insert header component code from Figma export
/insert-design-code main design/header.zip "Insert header and navigation components"

# Update button components across the app
/insert-design-code develop ui/exports/buttons.zip "Update all button variants with Figma code"

# Insert dashboard layout code
/insert-design-code feature/dashboard design/dashboard-export.zip
```

## What This Command Does

**🚨 CRITICAL: This is a COMMAND WORKFLOW, not direct task execution! Follow these steps EXACTLY in order:**

## 🔐 STEP 0: WORKFLOW LOCK VERIFICATION 🔐

**BEFORE ANY ACTION, VERIFY:**
- Current directory must be a git repository
- Must NOT have uncommitted changes
- Must NOT be on a feature branch already

**RUN THESE CHECKS FIRST:**

```bash
# 🔴 PRIMARY EXECUTION PATH (Script Available):
SCRIPT_PATH="../scripts/insert-design-code_workflow-enforcer.sh"
if [[ -f "$SCRIPT_PATH" ]]; then
    echo "🚀 Using workflow enforcement script..."
    "$SCRIPT_PATH" 0 "<base-branch>"
    
    if [ $? -ne 0 ]; then
        echo "🛑 WORKFLOW VIOLATIONS DETECTED - Cannot proceed"
        exit 1
    fi
else
    # 🔴 FALLBACK EXECUTION PATH (Script Unavailable):
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ WORKFLOW VIOLATION: Not in a git repository"
        exit 1
    fi
    
    if [ -n "$(git status --porcelain)" ]; then
        echo "❌ WORKFLOW VIOLATION: Uncommitted changes detected"
        exit 1
    fi
    
    CURRENT_BRANCH=$(git branch --show-current)
    if [[ "$CURRENT_BRANCH" == claude/* ]]; then
        echo "❌ WORKFLOW VIOLATION: Already on a feature branch ($CURRENT_BRANCH)"
        exit 1
    fi
fi
```

### Workflow Steps

1. **Sync base branch** 🚨⚡ MANDATORY FIRST STEP ⚡🚨
   
   **🚀 OPTIMIZED EXECUTION via Script:**
   ```bash
   SCRIPT_PATH="../scripts/insert-design-code_git-setup.sh"
   if [[ -f "$SCRIPT_PATH" ]]; then
       echo "🚀 Using optimized git setup script..."
       "$SCRIPT_PATH" "<base-branch>" "validate"
   else
       # Fallback to manual commands
       git checkout <base-branch>
       git pull origin <base-branch>
       git branch --show-current
       git status
   fi
   ```

2. **Create feature branch from synced base** 🚨⚡ **CRITICAL BRANCH CREATION** ⚡🚨
   
   **🚀 OPTIMIZED BRANCH NAME GENERATION via Script:**
   ```bash
   SCRIPT_PATH="../scripts/insert-design-code_branch-generator.sh"
   if [[ -f "$SCRIPT_PATH" ]]; then
       BRANCH_NAME=$("$SCRIPT_PATH" "<custom-instructions>")
       git checkout -b "$BRANCH_NAME"
   else
       # Manual generation from instructions
       BRANCH_NAME="claude/apply-figma-styles"
       git checkout -b "$BRANCH_NAME"
   fi
   ```

3. **Create GitHub issue and PR** 🚨 **REQUIRED BEFORE ANY CODE CHANGES** 🚨
   
   - Create issue with task checklist
   - Create PR immediately targeting base branch
   - Link issue and PR

4. **Delegate conversion to design agent** 🚨⚡ AGENT DELEGATION ⚡🚨
   
   **🚀 INVOKE CONVERT-TO-REACT AGENT for conversion:**
   ```bash
   echo "🤖 Delegating Figma Make conversion to specialized agent..."
   
   # Prepare agent invocation
   FIGMA_EXPORT_PATH="<figma-export-path>"
   CUSTOM_INSTRUCTIONS="<custom-instructions>"
   
   # Use Task tool to invoke the design:convert-to-react agent
   echo "📋 Invoking design:convert-to-react agent with:"
   echo "   - Export path: $FIGMA_EXPORT_PATH"
   echo "   - Instructions: $CUSTOM_INSTRUCTIONS"
   ```
   
   **Agent will handle:**
   - Extract and analyze Figma export structure
   - Identify styling patterns and design tokens
   - Map components to existing app structure
   - Apply styles selectively while preserving functionality
   - Test visual changes and ensure pixel-perfect accuracy
   
   **Note**: The design:convert-to-react agent follows the comprehensive methodology documented in:
   - `ubuntu-vm/project/design/docs/convert-to-react-vite.md`
   - Agent system prompt at: `ubuntu-vm/project/design/agents/convert-to-react.md`

5. **Validate local build** 🚨⚡ VERCEL BUILD VALIDATION ⚡🚨
   
   **After agent completes conversion, validate build locally:**
   ```bash
   echo "🔍 Delegating local build validation to vercel:validate-deployment agent..."
   
   # Use Task tool to invoke the vercel:validate-deployment agent
   echo "📋 Invoking vercel:validate-deployment agent for local build check"
   echo "   - Mode: Local build validation"
   echo "   - Target: Current branch changes"
   ```
   
   **Agent will verify:**
   - Build completes without errors
   - No TypeScript/ESLint issues
   - Bundle size is acceptable
   - All tests pass (if configured)

6. **Commit and push changes** 🚨⚡ ATOMIC COMMITS ⚡🚨
   
   **After successful local validation:**
   ```bash
   # Review changes made by agent
   git status
   git diff --stat
   
   # Commit changes
   git add -A
   git commit -m "feat: apply Figma styles from <figma-export-path>"
   git push origin HEAD
   ```

7. **Update PR and validate deployment** 🚨⚡ VERCEL DEPLOYMENT VALIDATION ⚡🚨
   
   - Update PR description with changes made by agent
   - Add before/after screenshots if applicable
   
   **After PR is created, validate Vercel deployment:**
   ```bash
   echo "🚀 Delegating Vercel deployment validation to vercel:validate-deployment agent..."
   
   # Use Task tool to invoke the vercel:validate-deployment agent
   echo "📋 Invoking vercel:validate-deployment agent for deployment check"
   echo "   - Mode: Vercel preview deployment validation"
   echo "   - Target: PR preview URL"
   ```
   
   **Agent will verify:**
   - Vercel deployment succeeds
   - Preview URL is accessible
   - No runtime errors in deployment
   - Visual changes match expectations

## Common RUN Commands

### Initial Setup
- RUN `git checkout <base-branch>` - Switch to base
- RUN `git pull origin <base-branch>` - Sync branch
- RUN `git checkout -b claude/<auto-generated>` - Create feature branch

### Agent Invocation
- Invoke `design:convert-to-react` agent with export path
- Agent handles extraction and analysis automatically
- Agent applies conversion methodology from docs
- Monitor agent progress and output

### Post-Conversion Validation
- Invoke `vercel:validate-deployment` agent for local build validation
- Agent verifies build, lint, and type checking automatically
- RUN `git status` - Review changes made by agents
- RUN `git diff --stat` - Check file changes summary

### Git Operations
- RUN `git add -A` - Stage all changes
- RUN `git commit -m "feat: apply Figma styles"` - Commit
- RUN `git push origin HEAD` - Push changes

### Deployment Validation
- Invoke `vercel:validate-deployment` agent for PR deployment check
- Agent monitors Vercel preview deployment
- Agent validates deployment success and runtime errors
- Review deployment URL provided by agent

## Requirements

- Git configured with push access
- Node.js and npm installed
- GitHub CLI (`gh`) or GitHub MCP configured
- `unzip` utility installed
- Valid Figma Make export zip file

## Error Handling

- **Missing zip file**: Verify path is relative to repo root
- **Invalid zip format**: Ensure file is valid Figma Make export
- **Style conflicts**: Carefully merge with existing styles
- **Build failures**: Review imported styles for syntax errors
- **Component mismatches**: Map only compatible components

## Notes

- **Agent delegation**: This command delegates the actual conversion to the `design:convert-to-react` agent
- **Comprehensive methodology**: The agent follows the detailed conversion guide in `convert-to-react-vite.md`
- **Preserve functionality**: Agent ensures existing component logic is maintained during integration
- **Incremental updates**: Can be run multiple times with different exports
- **Visual testing**: Agent validates visual changes, but manual verification is recommended

## Agent Support

This command delegates to multiple specialized agents:

### design:convert-to-react Agent
#### Conversion Capabilities
- Extracts and analyzes Figma Make exports
- Identifies styling patterns and design tokens
- Maps components to React structure
- Applies styles selectively
- Validates visual accuracy

#### Documentation
- Agent prompt: `ubuntu-vm/project/design/agents/convert-to-react.md`
- Methodology: `ubuntu-vm/project/design/docs/convert-to-react-vite.md`
- Includes shadcn/ui integration strategies

### vercel:validate-deployment Agent
#### Validation Capabilities
- **Local Build Validation**:
  - Runs build commands and checks for errors
  - Validates TypeScript compilation
  - Runs ESLint and other linters
  - Checks bundle size constraints
  - Executes test suites if configured
- **Deployment Validation**:
  - Monitors Vercel preview deployments
  - Validates deployment success status
  - Checks for runtime errors
  - Verifies preview URL accessibility
  - Reports deployment metrics

## Version History

- v0.3.0 - Added vercel:validate-deployment agent for build and deployment validation
- v0.2.0 - Refactored to delegate conversion to design:convert-to-react agent
- v0.1.0 - Initial release with basic Figma style application workflow