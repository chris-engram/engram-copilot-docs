**Purpose**: This document defines the comprehensive rules, patterns, and best practices for creating and maintaining Claude meta command files that orchestrate complex workflows by calling other commands and agents.

## Table of Contents
- [Naming Convention](#naming-convention)
- [Purpose and Benefits](#purpose-and-benefits)
- [Meta Command File Structure](#meta-command-file-structure)
- [Best Practices for Meta Commands](#best-practices-for-meta-commands)
- [Basic Meta-Command Workflow](#basic-meta-command-workflow)
  - [Standard 3-Step Meta-Command Pattern](#standard-3-step-meta-command-pattern)
  - [Workflow Enforcement Rules](#workflow-enforcement-rules)
  - [Example Meta-Command Implementation](#example-meta-command-implementation)
  - [Benefits of Standardized Workflow](#benefits-of-standardized-workflow)
- [Flag-Based Execution](#flag-based-execution)
  - [Flag Table Requirements](#flag-table-requirements)
  - [Flag Execution Patterns](#flag-execution-patterns)
  - [Dependency Management](#dependency-management)
  - [Example Meta Command with Flags](#example-meta-command-with-flags)
- [Example: Project Setup Meta Command](#example-project-setup-meta-command)
- [When to Create Meta Commands](#when-to-create-meta-commands)

---

Meta command files are specialized command files that primarily orchestrate and call other commands and agents. They serve as high-level workflow coordinators, delegating specific tasks to specialized commands and intelligent agents.

## Naming Convention

Meta command files MUST use the `run-*` prefix in the command file name:
- `run-deploy-full-stack.md` - Orchestrates multiple deployment commands
- `run-setup-project.md` - Coordinates project initialization commands  
- `run-daily-maintenance.md` - Runs various maintenance commands
- `figma-make:run-design-dev.md` - Runs design to development workflow

**IMPORTANT**: The `run-*` prefix clearly indicates that this is a meta-command that orchestrates other operations rather than performing direct actions.

## Purpose and Benefits

1. **Workflow Orchestration**: Coordinate complex multi-step processes
2. **Flag-Based Routing**: Use command-line flags to trigger specific routines
3. **Agent Integration**: Seamlessly combine command execution with agent intelligence
4. **Reduced Duplication**: Reuse existing commands and agents instead of reimplementing
5. **Maintainability**: Changes to individual commands automatically propagate
6. **Clarity**: High-level workflow is clear without implementation details
7. **Flexibility**: Easy to modify workflows by changing command calls or agent assignments

## Meta Command File Structure

```markdown
# Args: `<environment>` `[options]`. v0.1.0. Orchestrate full deployment workflow.

## Overview

This meta command coordinates the complete deployment process by calling specialized commands in the correct sequence.

## What This Command Does

1. **Pre-deployment Checks**
   ```bash
   # Validate environment readiness
   /validate-environment <environment>
   ```

2. **Database Migration**
   ```bash
   # Run database migrations
   /migrate-database <environment> --auto-approve
   ```

3. **Deploy Backend Services**
   ```bash
   # Deploy edge functions
   /deploy-edge-functions <environment>
   
   # Deploy API services
   /deploy-api <environment>
   ```

4. **Deploy Frontend**
   ```bash
   # Build and deploy frontend
   /deploy-frontend <environment> --with-preview
   ```

5. **Post-deployment Validation**
   ```bash
   # Run smoke tests
   /run-smoke-tests <environment>
   
   # Update monitoring
   /update-monitoring <environment>
   ```

## Error Recovery

If any step fails, the meta command should:
- Stop execution
- Report which command failed
- Provide recovery instructions
```

## Best Practices for Meta Commands

1. **Minimal Logic**: Meta commands should contain minimal logic - delegate complex operations
2. **Clear Flow**: Document the workflow sequence clearly
3. **Error Propagation**: Handle and report errors from called commands
4. **Status Reporting**: Provide progress updates between command calls
5. **Conditional Execution**: Include logic for skipping steps when appropriate
6. **Flag Documentation**: Always include a comprehensive flag table
7. **Dependency Documentation**: Clearly indicate which flags depend on each other

## Basic Meta-Command Workflow

**CRITICAL**: All meta-commands MUST follow this standardized workflow structure to ensure consistency and proper integration with the development pipeline:

### Standard 3-Step Meta-Command Pattern

Every meta-command should implement this exact workflow pattern:

1. **Create Feature Branch** 🚨 **MANDATORY FIRST STEP** 🚨
   ```bash
   # ALWAYS use create-feature-branch command with dev as base branch
   Task tool: "/git:create-feature-branch dev <feature-name>"
   ```
   
   **Requirements:**
   - Base branch MUST be `dev` (not main)
   - Feature name derived from command context or arguments
   - This step creates the proper branch foundation for all development work

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
   Task tool: "@design-system-agent - Apply design patterns to components"
   Task tool: "@security-audit-agent - Review authentication flow"
   ```
   
   **Option C: Mixed Command + Agent Execution**
   ```bash
   # Combine commands and agents for complex workflows
   Task tool: "/setup-database-schema <schema-file>"
   Task tool: "@data-migration-agent - Migrate user data safely"
   Task tool: "/deploy-backend <environment>"
   ```

3. **Create Pull Request** 🚨 **MANDATORY FINAL STEP** 🚨
   ```bash
   # Create PR with dev as target branch
   Task tool: "/dev:create-pr"
   ```
   
   **Requirements:**
   - Target branch MUST be `dev` (matching the base branch from step 1)
   - PR creation includes issue linking and proper metadata
   - This completes the development workflow cycle

### Workflow Enforcement Rules

**🚨 CRITICAL REQUIREMENTS:**

1. **Step Order**: Steps MUST be executed in exact sequence (1 → 2 → 3)
2. **Branch Consistency**: Base branch in step 1 MUST match target branch in step 3
3. **Dev Branch Standard**: Always use `dev` as the base/target branch (not main)
4. **No Step Skipping**: All three steps are mandatory for every meta-command
5. **Tool Usage**: Use Task tool for all command and agent invocations

### Example Meta-Command Implementation

```markdown
# Args: `<feature-type>` `<scope>`. v0.1.0. Execute feature development workflow.

## What This Command Does

1. **Create Feature Branch from Dev**
   ```bash
   # Extract feature name from arguments
   FEATURE_NAME="${feature-type}-${scope}"
   
   # Create branch using standard command
   Task tool: "/git:create-feature-branch dev $FEATURE_NAME"
   ```

2. **Execute Development Tasks**
   ```bash
   # Mixed execution: commands + agents
   Task tool: "/analyze-requirements $SCOPE"
   Task tool: "@architecture-agent - Design system for $FEATURE_TYPE"
   Task tool: "/implement-feature $FEATURE_NAME $SCOPE"
   ```

3. **Create Pull Request to Dev**
   ```bash
   # Create PR targeting dev branch
   Task tool: "/dev:create-pr"
   ```
```

### Benefits of Standardized Workflow

1. **Consistent Branch Management**: All development follows dev → feature → dev pattern
2. **Proper Integration**: Seamless integration with existing git commands
3. **Quality Assurance**: PR creation ensures code review and testing
4. **Reduced Errors**: Standardized pattern reduces workflow mistakes
5. **Clear Documentation**: Predictable structure improves maintainability

## Flag-Based Execution

Meta commands typically use flags to trigger specific routines. This provides flexibility and allows users to run targeted workflows based on their needs.

### Flag Table Requirements

**CRITICAL**: Every meta command MUST include a flag table that documents:

| Flag | Description | Triggers | Execution Mode | Dependencies |
|------|-------------|----------|----------------|--------------|
| `--config` | Configure project settings | `/configure-settings` command | Serial | None |
| `--design-philosophy` | Apply design patterns | `@agent-design-system` + `/apply-patterns` command | Parallel | Requires `--config` |
| `--deploy` | Deploy to production | `/deploy-backend` + `/deploy-frontend` commands | Serial | Requires `--test` |
| `--test` | Run test suite | `@agent-test-runner` | Serial | None |
| `--full` | Complete workflow | All of the above | Mixed | None |

### Flag Execution Patterns

1. **Single Command Trigger**
   ```bash
   if [[ "$FLAGS" == *"--config"* ]]; then
       /configure-settings $PROJECT_NAME
   fi
   ```

2. **Multiple Commands (Serial)**
   ```bash
   if [[ "$FLAGS" == *"--deploy"* ]]; then
       /deploy-backend $ENVIRONMENT
       /deploy-frontend $ENVIRONMENT
   fi
   ```

3. **Command + Agent (Parallel)**
   ```bash
   if [[ "$FLAGS" == *"--design-philosophy"* ]]; then
       # Execute in parallel
       Task tool: "@agent-design-system - Apply design patterns to $PROJECT"
       /apply-patterns $PROJECT --async
   fi
   ```

4. **Multiple Agents**
   ```bash
   if [[ "$FLAGS" == *"--analyze"* ]]; then
       # Deploy multiple agents
       Task tool: "@agent-code-analyzer - Analyze codebase"
       Task tool: "@agent-security-scanner - Scan for vulnerabilities"
       Task tool: "@agent-performance-analyzer - Check performance"
   fi
   ```

### Dependency Management

When flags have dependencies, validate them upfront:

```bash
# Validate dependencies
if [[ "$FLAGS" == *"--deploy"* ]] && [[ "$FLAGS" != *"--test"* ]]; then
    echo "❌ Error: --deploy requires --test flag"
    echo "Run with: /run-deploy --test --deploy"
    exit 1
fi
```

### Example Meta Command with Flags

```markdown
# Args: `<project-name>` `[flags]`. v1.0.0. Run design-to-development workflow with configurable steps.

## Usage
```bash
/figma-make:run-design-dev my-project --config --design-philosophy
/figma-make:run-design-dev my-project --full
```

## Flag Reference

| Flag | Description | Triggers | Execution | Dependencies |
|------|-------------|----------|-----------|--------------|
| `--config` | Initial configuration | `/configure-figma` command | Serial | None |
| `--design-philosophy` | Apply design system | `@agent-design-system` + `/sync-tokens` | Parallel | `--config` |
| `--generate-components` | Create React components | `/generate-components` + `@agent-component-builder` | Parallel | `--design-philosophy` |
| `--test` | Test generated code | `@agent-test-runner` | Serial | `--generate-components` |
| `--deploy-preview` | Deploy preview | `/deploy-preview` command | Serial | `--test` |
| `--full` | Run complete workflow | All of the above | Mixed | None |

## What This Command Does

Based on the provided flags, this meta-command orchestrates:

1. **Configuration Phase** (`--config`)
   ```bash
   /configure-figma $PROJECT_NAME
   ```

2. **Design System Application** (`--design-philosophy`)
   ```bash
   # Parallel execution
   Task tool: "@agent-design-system - Apply design patterns"
   /sync-tokens $PROJECT_NAME
   ```

3. **Component Generation** (`--generate-components`)
   ```bash
   # Parallel execution
   /generate-components $PROJECT_NAME
   Task tool: "@agent-component-builder - Optimize components"
   ```
```

## Example: Project Setup Meta Command

```markdown
# Args: `<project-name>` `<template>`. v0.1.0. Complete project setup workflow.

## What This Command Does

This meta command orchestrates the complete project setup by calling:

1. **Initialize Repository**
   ```bash
   /init-git-repo <project-name>
   ```

2. **Apply Template**
   ```bash
   /apply-template <template> <project-name>
   ```

3. **Configure Services**
   ```bash
   # Based on template, configure appropriate services
   if [[ "<template>" == "full-stack" ]]; then
       /setup-database <project-name>
       /setup-edge-functions <project-name>
       /setup-frontend <project-name>
   fi
   ```

4. **Setup Development Environment**
   ```bash
   /configure-dev-environment <project-name>
   /install-dependencies <project-name>
   ```

5. **Initial Commit and Push**
   ```bash
   /create-initial-commit <project-name>
   /setup-github-repo <project-name> --private
   ```

## Benefits

By using this meta command instead of running each command individually:
- Ensures correct execution order
- Handles inter-command dependencies
- Provides single entry point for complex workflow
- Maintains consistency across projects
```

## When to Create Meta Commands

Create meta commands when:
1. **Multiple Commands**: Workflow requires 3+ existing commands
2. **Defined Sequence**: Commands must execute in specific order
3. **Common Pattern**: Workflow is repeated frequently
4. **Complex Coordination**: Inter-command dependencies exist
5. **User Simplification**: Abstracting complexity from users