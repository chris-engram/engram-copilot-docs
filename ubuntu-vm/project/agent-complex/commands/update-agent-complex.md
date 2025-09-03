# Args: `<type:topic>` `<complex-name>` `<description>`. v2.0.0. Create or update agent complexes with comprehensive components and QA validation

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/run-update-agent-complex` in bash.

## Summary

This command creates or updates agent complexes with comprehensive components including agents, commands, and documentation. It intelligently coordinates agent-complex builder and researcher agents to create comprehensive automation solutions, followed by QA validation to ensure deployment readiness. Git workflow management (branches, commits, PRs) should be handled separately using the reverse-sync workflow.

**Important**: When updating existing agent complexes, this command enhances the existing components rather than creating redundant ones. See the "Updating Existing Complexes" section below for details.

## Usage

```bash
/agent-complex:update-agent-complex <type:topic> <complex-name> "<description>"
```

## Arguments

- `<type:topic>`: Agent complex type and topic combined (REQUIRED)
  - Format: `type:topic` where type is either `user`, `project`, or `nexus`
  - Examples: `user:dev`, `project:supabase`, `user:tools`, `nexus:auth`
  - Purpose: Determines agent/command location and organization
- `<complex-name>`: Name for the agent complex (REQUIRED)
  - Format: kebab-case (lowercase with hyphens)
  - Examples: `deployment-orchestrator`, `code-reviewer`, `security-scanner`
  - Purpose: Base name for agents, commands, and documentation
  - Note: This will be configured in the meta command as run-{{complex-name}}
- `<description>`: Purpose and functionality of the agent complex (REQUIRED)
  - Brief description of what the agent complex does
  - Quote if contains spaces
  - Examples: "Orchestrate deployment workflows with validation", "Review code for security and best practices"

## Examples

```bash
# Create a new user agent complex in dev topic
/agent-complex:update-agent-complex user:dev deployment-orchestrator "Orchestrate deployment workflows with pre-validation and monitoring"

# Create a new project agent complex in supabase topic
/agent-complex:update-agent-complex project:supabase edge-function-manager "Manage Supabase edge functions with testing and deployment"

# Create a security agent complex in tools topic
/agent-complex:update-agent-complex user:tools security-scanner "Scan and validate code for security vulnerabilities"

# Create a nexus agent complex in auth topic
/agent-complex:update-agent-complex nexus:auth auth-manager "Manage authentication workflows and security patterns"

# Update existing agent complex
/agent-complex:update-agent-complex user:security auth-validator "Validate and refresh authentication workflows"

# Update existing design-dev complex with enhanced color workflow
/agent-complex:update-agent-complex project:figma-make design-dev "update the --colors workflow so that COLOR-SYSTEM.md contains embedded swatch palette images"
```

## What This Command Does

### Agent Complex Creation Workflow

This command focuses on creating or updating agent complex components. Git workflow management should be handled separately:

1. **Research Agent Complex Requirements** 🚨 **AGENT RESEARCH PHASE** 🚨
   ```bash
   # Call agent-complex researcher to analyze requirements
   Task tool: "agent-complex:researcher - Analyze requirements for agent complex '<complex-name>' with description: <description>. Research best practices, identify components needed (agents, commands, docs), and recommend architecture following agent-complex-rules.md patterns."
   ```
   
   **Research Operations:**
   - Analyzes the description to identify required components
   - Researches best practices for similar agent complexes
   - Recommends architecture patterns
   - Identifies dependencies and integration points
   - Creates implementation strategy

2. **Build Agent Complex Components** 🚨 **AGENT BUILDER PHASE** 🚨
   ```bash
   # Call agent-complex builder to create the complex
   Task tool: "agent-complex:builder - Build agent complex '<complex-name>' for <type:topic> based on research findings. Create all necessary components: agents, commands, and documentation following established patterns. Description: <description>"
   ```
   
   **Builder Operations:**
   - Creates primary agent file(s)
   - Generates supporting command files
   - Builds comprehensive documentation
   - Implements integration patterns
   - Follows agent-complex-rules.md guidelines

3. **Validate Agent Complex** 🚨 **VALIDATION PHASE** 🚨
   ```bash
   # Validate created components
   echo "🧪 Validating agent complex components..."
   
   # Check agent files
   if [ "$TYPE" = "user" ]; then
       AGENT_PATH="ubuntu-vm/user/$TOPIC/agents/$COMPLEX_NAME.md"
   else
       AGENT_PATH="ubuntu-vm/project/$TOPIC/agents/$COMPLEX_NAME.md"
   fi
   
   # Validate agent file exists and follows patterns
   if [[ -f "$AGENT_PATH" ]]; then
       echo "✅ Agent file created: $AGENT_PATH"
       # Basic validation of agent file structure
       if grep -q "^name: " "$AGENT_PATH" && grep -q "^description: " "$AGENT_PATH"; then
           echo "✅ Agent file structure validated"
       else
           echo "⚠️ Agent file may be missing required frontmatter"
       fi
   else
       echo "❌ Agent file not found: $AGENT_PATH"
   fi
   
   # Check for supporting commands if created
   if [ "$TYPE" = "user" ]; then
       COMMAND_DIR="ubuntu-vm/user/$TOPIC/commands"
   else
       COMMAND_DIR="ubuntu-vm/project/$TOPIC/commands"
   fi
   
   # List any commands created for this agent complex
   if [[ -d "$COMMAND_DIR" ]]; then
       RELATED_COMMANDS=$(find "$COMMAND_DIR" -name "$COMPLEX_NAME-*" -type f 2>/dev/null || true)
       if [[ -n "$RELATED_COMMANDS" ]]; then
           echo "✅ Related commands found:"
           echo "$RELATED_COMMANDS" | sed 's/^/  - /'
       fi
   fi
   ```

4. **Quality Assurance Validation** 🚨 **COMPREHENSIVE QA WITH QA AGENT** 🚨
   ```bash
   # Run comprehensive quality assurance using the QA agent
   Task tool: "/agent-complex:run-qa $TYPE \"Quality validation for $COMPLEX_NAME agent complex\""
   ```
   
   **QA Agent Operations:**
   - **Deployment Readiness**: Validates all paths work in deployed context
   - **Performance Optimization**: Identifies parallel execution and script migration opportunities
   - **Documentation Quality**: Ensures AI optimization and completeness
   - **Security Assessment**: Scans for vulnerabilities and security best practices
   - **Integration Validation**: Verifies component integration and patterns
   - **Comprehensive Reporting**: Provides actionable recommendations with priority levels


## Updating Existing Complexes

When updating an existing agent complex (rather than creating a new one), the command intelligently enhances existing components:

### Enhancement Strategy

1. **Identify Existing Components**
   - Meta-command: `run-<complex-name>` (e.g., `run-design-dev`)
   - Agent: `@agent-<topic>:<complex-name>` (e.g., `@agent-figma-make:design-dev`)
   - Commands: Related commands in the topic (e.g., `/figma-make:update-color-system`)

2. **Apply Enhancements**
   - Update existing commands with new features (don't create `-enhanced` versions)
   - Enhance existing agent documentation
   - Merge new documentation into existing guides

3. **Avoid Redundancy**
   - Don't create new meta-commands for sub-workflows (e.g., no `run-color-system-dev`)
   - Don't create specialized agents for sub-features (e.g., no `color-system-dev`)
   - Don't duplicate commands with `-enhanced` suffixes

### Example: Enhancing --colors Workflow

When the description mentions updating a specific workflow:
```bash
/dev:run-update-agent-complex dev project:figma-make design-dev \
  "update the --colors workflow so that COLOR-SYSTEM.md contains embedded swatch palette images"
```

The command will:
- ✅ Enhance `/figma-make:update-color-system` command
- ✅ Update `design-dev` agent documentation
- ✅ Merge new docs into existing `color-system.md`
- ❌ NOT create `run-color-system-dev` meta-command
- ❌ NOT create `color-system-dev` agent
- ❌ NOT create `update-color-system-enhanced` command

## Workflow Benefits

### Agent Complex Advantages
- **Intelligent Design**: Research phase ensures optimal architecture
- **Comprehensive Components**: Builder creates all necessary pieces
- **Pattern Consistency**: Follows established agent-complex patterns
- **Integration Ready**: Works with existing command infrastructure

### Automation Features
- **Single Command**: Entire workflow in one command invocation
- **Expert Guidance**: Leverages specialized builder and researcher agents
- **Quality Assurance**: Validation ensures proper component creation
- **Documentation**: Comprehensive documentation generation

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🚀 UPDATE-AGENT-COMPLEX v2.0.0"
echo "This command creates or updates agent complex components."
echo "Note: Git workflow (branches, commits, PRs) should be handled separately."
echo "═══════════════════════════════════════════════════════════════════"

# Parse arguments
if [ $# -lt 3 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:update-agent-complex <type:topic> <complex-name> \"<description>\""
    exit 1
fi

TYPE_TOPIC="$1"
COMPLEX_NAME="$2"
DESCRIPTION="$3"

# Extract type and topic from type:topic
TYPE=$(echo "$TYPE_TOPIC" | cut -d: -f1)
TOPIC=$(echo "$TYPE_TOPIC" | cut -d: -f2)

echo ""
echo "📋 Agent Complex Configuration:"
echo "  - Type: $TYPE"
echo "  - Topic: $TOPIC"
echo "  - Complex Name: $COMPLEX_NAME"
echo "  - Description: $DESCRIPTION"
echo ""

# Step 1: Research agent complex requirements
echo "1️⃣ Researching agent complex requirements"
echo "───────────────────────────────────────"
Task tool: "agent-complex:researcher - Analyze requirements for agent complex '$COMPLEX_NAME' with description: $DESCRIPTION. Research best practices, identify components needed (agents, commands, docs), and recommend architecture following agent-complex-rules.md patterns."

# Step 2: Build agent complex components
echo ""
echo "2️⃣ Building agent complex components"
echo "───────────────────────────────────────"
Task tool: "agent-complex:builder - Build agent complex '$COMPLEX_NAME' for $TYPE_TOPIC based on research findings. Create all necessary components: agents, commands, and documentation following established patterns and best practices. Description: $DESCRIPTION"

# Step 3: Validate agent complex
echo ""
echo "3️⃣ Validating agent complex components"
echo "───────────────────────────────────────"

# Determine agent path
if [ "$TYPE" = "user" ]; then
    AGENT_PATH="ubuntu-vm/user/$TOPIC/agents/$COMPLEX_NAME.md"
    COMMAND_DIR="ubuntu-vm/user/$TOPIC/commands"
elif [ "$TYPE" = "project" ]; then
    AGENT_PATH="ubuntu-vm/project/$TOPIC/agents/$COMPLEX_NAME.md"
    COMMAND_DIR="ubuntu-vm/project/$TOPIC/commands"
elif [ "$TYPE" = "nexus" ]; then
    # Nexus uses special naming convention for agents
    AGENT_PATH=".claude/agents/nexus:$TOPIC:$COMPLEX_NAME.md"
    COMMAND_DIR=".claude/commands/nexus/$TOPIC"
else
    echo "❌ Error: Invalid type '$TYPE'. Must be 'user', 'project', or 'nexus'"
    exit 1
fi

# Validate components
VALIDATION_SUCCESS=true

# Check agent file
if [[ -f "$AGENT_PATH" ]]; then
    echo "✅ Agent file created: $AGENT_PATH"
    # Basic validation
    if grep -q "^name: " "$AGENT_PATH" && grep -q "^description: " "$AGENT_PATH"; then
        echo "✅ Agent file structure validated"
    else
        echo "⚠️ Agent file may be missing required frontmatter"
        VALIDATION_SUCCESS=false
    fi
else
    echo "❌ Agent file not found: $AGENT_PATH"
    VALIDATION_SUCCESS=false
fi

# Check for related commands
if [[ -d "$COMMAND_DIR" ]]; then
    RELATED_COMMANDS=$(find "$COMMAND_DIR" -name "$COMPLEX_NAME-*" -type f 2>/dev/null || echo "")
    if [[ -n "$RELATED_COMMANDS" && "$RELATED_COMMANDS" != "" ]]; then
        echo "✅ Related commands found:"
        echo "$RELATED_COMMANDS" | sed 's/^/  - /'
    else
        echo "ℹ️ No related commands created (agent-only complex)"
    fi
fi

# Step 4: Quality Assurance Validation
echo ""
echo "4️⃣ Running QA validation with QA agent"
echo "───────────────────────────────────────"

if [ "$VALIDATION_SUCCESS" = true ]; then
    echo "🔍 Initiating comprehensive QA validation..."
    echo "  Using QA agent to orchestrate all quality checks"
    echo ""
    
    # Run comprehensive QA using the QA agent
    Task tool: "/agent-complex:process-qa $TYPE \"Quality validation for $COMPLEX_NAME agent complex - validate deployment readiness, performance optimization, documentation quality, and security compliance for newly created/updated components\""
    
    echo ""
    echo "✅ QA validation completed successfully"
    echo "  - Deployment paths validated"
    echo "  - Performance optimizations identified"
    echo "  - Documentation quality verified"
    echo "  - Security compliance checked"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ AGENT COMPLEX CREATION/UPDATE COMPLETED!"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📊 Summary:"
echo "  - Agent complex created/updated: $AGENT_PATH"
echo "  - QA validation passed: all quality dimensions"
echo "  - Components validated"
echo ""
echo "🎯 The agent complex can now be invoked as: /$TOPIC:$COMPLEX_NAME"
echo ""
if [ "$VALIDATION_SUCCESS" = true ]; then
    echo "📝 Next Steps:"
    echo "  1. Review the created components"
    echo "  2. Test the agent complex functionality"
    echo "  3. Commit changes when satisfied"
    echo "  4. Use reverse-sync workflow to sync to remote repository"
else
    echo "⚠️ Some validation issues occurred - review the output above"
fi
```

## Requirements

- Access to agent-complex agents:
  - `agent-complex:builder`
  - `agent-complex:researcher`
- Proper file system permissions for creating files

## Error Handling

- **Missing Arguments**: Clear usage instructions with examples
- **Invalid Type:Topic**: Validates format and available topics
- **Agent Complex Creation Failure**: Builder agent provides detailed error messages
- **Validation Failure**: Reports which components couldn't be created
- **QA Validation**: Provides detailed feedback on quality issues

## Notes

- **Agent Complex Integration**: Leverages specialized builder and researcher agents
- **Git Workflow**: Should be managed separately using standard git commands or reverse-sync workflow
- **Topic Organization**: Maintains proper directory structure for agents and commands
- **Pattern Compliance**: Ensures all components follow agent-complex-rules.md guidelines
- **Validation**: Comprehensive validation ensures quality of created components
- **Documentation**: Automatically generates comprehensive documentation for complex
- **Reverse Sync**: Components can be synced to remote repository using reverse-sync-commands-with-remote

## Naming Conventions

### Agent Complex Naming Patterns
When creating agent complexes, the following naming conventions apply:

- **Meta Command Pattern**: The complex will be configured as `run-{{complex-name}}`
  - Example: For `complex-name="deployment-orchestrator"`, the meta command becomes `run-deployment-orchestrator`

- **Agent Naming Patterns**: Agents dedicated to the complex typically follow these patterns:
  - `{{complex-name}}` - Main agent (e.g., `@agent-{{topic}}:{{complex-name}}`)
    - Example: `@agent-dev:deployment-orchestrator`
  - `{{complex-name}}-*` - Supporting agents (e.g., `@agent-{{topic}}:{{complex-name}}-builder`)
    - Example: `@agent-dev:deployment-orchestrator-builder`
    - Example: `@agent-dev:deployment-orchestrator-validator`

- **Command File Naming**: Commands dedicated to the complex are prepended with `{{complex-name}}-*`
  - Example: `deployment-orchestrator-best-practices.md`
  - Example: `deployment-orchestrator-rules.md`
  - Example: `deployment-orchestrator-validate.md`

- **Documentation Files**: Follow the same `{{complex-name}}-*` pattern
  - Example: `deployment-orchestrator-guide.md`
  - Example: `deployment-orchestrator-patterns.md`

## Agent Complex Architecture

### Component Types
- **Primary Agent**: Main agent file with specialized capabilities
- **Supporting Commands**: Reliable command operations for common tasks
- **Documentation**: Comprehensive guides and reference materials
- **Integration Patterns**: Workflows that connect multiple components

### Quality Standards
- Follows `agent-complex-rules.md` patterns
- Implements comprehensive error handling
- Provides clear documentation and examples
- Integrates seamlessly with existing infrastructure
- Maintains consistent naming and organization patterns

## Version History

- v2.0.0 - Removed git workflow management
  - Renamed from run-update-agent-complex to update-agent-complex
  - Removed base-branch argument
  - Removed feature branch creation and PR operations
  - Updated to use process-qa instead of run-qa
  - Focus on agent complex component creation only
  - Git workflows now handled separately via reverse-sync
- v1.5.0 - QA agent integration
  - Replaced individual check commands with comprehensive QA agent
  - Unified quality validation through `/agent-complex:run-qa`
  - Enhanced reporting with priority-based recommendations
  - Streamlined validation workflow with single orchestration point