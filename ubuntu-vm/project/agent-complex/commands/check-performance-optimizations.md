# Args: `<type>` `[description]`. v1.1.0. Analyzes command files for performance optimization opportunities. Identifies serial operations that can be parallelized, scripts that should be used for complex operations, Phase/Todo items that can be executed in parallel, and existing commands that can be reused instead of recapitulating tasks. Provides specific recommendations to improve command execution speed and efficiency.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/check-performance-optimizations` in bash.

## Summary

**PERFORMANCE ANALYSIS**: Analyzes command files in the current working directory to identify performance optimization opportunities. This command examines Claude command files (.md) and their scripts to detect patterns that can be optimized for faster execution. It focuses on four key areas: script usage over embedded Claude instructions, parallel execution of independent operations, parallel execution of Phase/Todo items using Tasks, and command reuse instead of task recapitulation.

## Usage

```bash
/agent-complex:check-performance-optimizations <type> [description]
```

## Arguments

- `<type>`: Type of commands to analyze (REQUIRED)
  - Accepts: 'root', 'user', or 'project'
  - Purpose: Determines which command patterns and optimization strategies to apply
  - **'root'**: Root-level commands
    - Analysis scope: `/root/.claude/commands/`, `/root/.claude/scripts/`
    - Focus: System-level operations, administrative tasks
  - **'user'**: Topic-based user commands  
    - Analysis scope: `~/.claude/commands/{topic}/`, `~/.claude/scripts/{topic}/`
    - Focus: Development workflows, user automation
  - **'project'**: Project-specific commands
    - Analysis scope: `.claude/commands/{topic}/`, `.claude/scripts/{topic}/`
    - Focus: Project-specific operations, deployment workflows
- `[description]`: Description of files/context to analyze (OPTIONAL)
  - Default: "working directory changes" (analyzes current git working directory)
  - Examples: "staged changes", "recent commits", "dev topic commands", "deployment workflows"
  - Purpose: Provides context for which files to analyze for performance opportunities
  - The actual files analyzed are determined by git status regardless of description

## Examples

```bash
# Analyze root-level user commands for performance opportunities
/agent-complex:check-performance-optimizations root

# Analyze topic-based user commands with context
/agent-complex:check-performance-optimizations user "dev topic commands"

# Analyze project-level commands for deployment optimization
/agent-complex:check-performance-optimizations project "deployment workflows"

# Analyze user commands with specific focus
/agent-complex:check-performance-optimizations user "modified command files needing optimization"

# Analyze project commands for specific topic
/agent-complex:check-performance-optimizations project "supabase edge function commands"
```

### Quick Reference: Performance Optimization Patterns

| Optimization Type | Pattern | Performance Gain | When to Apply |
|------------------|---------|------------------|---------------|
| **Script Usage** | Replace embedded bash with external scripts | 70-85% faster | Operations >50 lines, complex logic |
| **Parallel Tasks** | Multiple Task tool calls in one message | 2-5x faster | Independent operations |
| **Parallel Bash** | Background processes with wait | 3-8x faster | Independent bash commands |
| **Agent Coordination** | Parallel agent deployment | 4-10x faster | Multiple domain-specific analyses |
| **Command Reuse** | Call existing commands vs recapitulation | 60-90% faster | Common workflows like PR creation |

### Common Optimization Scenarios

**Development Workflow Commands:**
```bash
# Detect serial operations that can be parallelized
/agent-complex:check-performance-optimizations user "development workflow commands"

# Focus on git operations that can be optimized
/agent-complex:check-performance-optimizations user "git topic commands needing optimization"
```

**Deployment Optimization:**
```bash
# Analyze deployment commands for parallel opportunities
/agent-complex:check-performance-optimizations project "deployment command optimization"

# Check Supabase commands for edge function deployment efficiency
/agent-complex:check-performance-optimizations project "supabase deployment workflows"
```

**Command File Refactoring:**
```bash
# Analyze recently modified commands for optimization opportunities
/agent-complex:check-performance-optimizations user "recent command modifications"

# Check staged changes for performance improvements before commit
/agent-complex:check-performance-optimizations user "staged changes ready for performance review"
```

## What This Command Does

**IDENTIFIES PERFORMANCE BOTTLENECKS**: Systematically analyzes command files to identify specific optimization opportunities that can significantly improve execution speed and efficiency.

### Key Analysis Areas

1. **Script Migration Opportunities**
   
   **Pattern Detection**: Commands with >50 lines of embedded bash code
   - **Issue**: Large embedded bash blocks execute slowly in Claude
   - **Solution**: Extract to external scripts for 70-85% performance improvement
   - **Detection**: Analyzes bash code blocks for complexity metrics
   - **Recommendation**: Specific script patterns and naming conventions
   
   **Examples of Script Migration Candidates:**
   ```bash
   # DETECTED: Large embedded bash block (>50 lines)
   # FILE: execute-deployment.md
   # ISSUE: 85 lines of embedded bash for git operations
   # RECOMMENDATION: Extract to ../scripts/execute-deployment_git-operations.sh
   ```

2. **Parallel Execution Opportunities**
   
   **Pattern Detection**: Sequential operations that can run in parallel
   - **Independent Bash Commands**: Commands that don't depend on each other
   - **Multiple Task Tool Calls**: Separate Tool calls that can be combined
   - **Agent Coordination**: Multiple agents that can run simultaneously
   - **File Operations**: Independent file reads, writes, or processing
   
   **Performance Impact Analysis:**
   ```bash
   # DETECTED: Sequential bash commands
   # CURRENT: 3 commands × 2 seconds = 6 seconds total
   # OPTIMIZED: 3 commands in parallel = 2 seconds total
   # IMPROVEMENT: 3x faster execution
   ```

3. **Phase/Todo Parallel Execution**
   
   **Pattern Detection**: Todo phases that can execute simultaneously
   - **Independent Research Tasks**: Multiple agents researching different aspects
   - **Validation Operations**: Parallel quality checks and validations
   - **Deployment Steps**: Independent deployment operations
   - **Analysis Tasks**: Multiple analysis tools running concurrently
   
   **Task Tool Optimization:**
   ```bash
   # DETECTED: Sequential Todo phases
   # CURRENT: 4 sequential Task tool calls
   # OPTIMIZED: Single message with 4 parallel Task tool calls
   # IMPROVEMENT: 4x faster with better resource utilization
   ```

4. **Agent Coordination Efficiency**
   
   **Pattern Detection**: Serial agent deployment vs parallel coordination
   - **Multiple Domain Experts**: Agents with different specializations
   - **Research Coordination**: Parallel information gathering
   - **Code Analysis**: Multiple perspectives on code quality
   - **Validation Teams**: Parallel quality assurance processes

5. **Command Reuse Opportunities**
   
   **Pattern Detection**: Tasks that duplicate existing command functionality
   - **Issue**: Recapitulating complex workflows that already exist as commands
   - **Solution**: Call existing commands directly for 60-90% performance improvement
   - **Detection**: Identifies patterns matching existing command capabilities
   - **Rules**: Command calling hierarchy based on type:
     - **Root commands**: Can only call other root commands
     - **User commands**: Can call commands in same topic or other user topics (commonly git, dev)
     - **Project commands**: Can call same-topic commands or any user commands
   
   **Examples of Command Reuse Candidates:**
   ```bash
   # DETECTED: Task recapitulation
   # FILE: execute-deployment.md
   # ISSUE: 25 lines outlining PR creation steps
   # RECOMMENDATION: Call /dev:create-pr instead
   # PERFORMANCE: 85% faster, more reliable
   ```
   
   **Common Reusable Commands:**
   - `/dev:create-pr` - Pull request creation with metadata
   - `/git:update-branch` - Branch synchronization with stash handling
   - `/git:create-feature-branch` - Feature branch creation and setup
   - `/agent-complex:update-command` - Command file creation/updates
   - `/agent-complex:check-paths` - Path validation and QA

### Analysis Process

1. **Git-Based File Discovery**: Identifies command files in working directory using git status
2. **Command File Parsing**: Analyzes .md files for bash blocks, Tool calls, and agent references
3. **Pattern Recognition**: Applies optimization pattern detection algorithms
4. **Command Reuse Analysis**: Identifies tasks that match existing command capabilities
5. **Performance Impact Calculation**: Estimates time savings and efficiency gains
6. **Script Analysis**: Evaluates existing scripts for optimization opportunities
7. **Dependency Analysis**: Identifies truly independent operations for parallelization
8. **Recommendation Generation**: Provides specific, actionable optimization suggestions
9. **Implementation Guidance**: Offers code examples and refactoring patterns

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from the agent-complex documentation regarding external script usage for complex analysis.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/check-performance-optimizations` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**

**🔴 MANDATORY RULE: If your implementation exceeds 50 lines of bash code, you MUST use external scripts** 🔴

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

#!/bin/bash
set -euo pipefail

# Parse arguments (keep minimal validation inline)
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required type argument"
    echo "Usage: /agent-complex:check-performance-optimizations <type> [description]"
    echo "  type: 'root', 'user', or 'project'"
    echo "  description: Optional context for analysis"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-working directory changes}"

# Validate type argument
if [ "$TYPE" != "root" ] && [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'root', 'user', or 'project'"
    exit 1
fi

# Display analysis context
echo "🚀 Analyzing performance optimization opportunities..."
echo "📋 Context: $DESCRIPTION"
echo "🎯 Goal: Identify patterns that can improve execution speed and efficiency"
echo "📂 Scope: $(if [ "$TYPE" = "root" ]; then echo "Root-level commands"; elif [ "$TYPE" = "user" ]; then echo "User-level commands"; else echo "Project-level commands"; fi)"

# 🔴 DECISION POINT: Complex analysis requires external scripts
# This command analyzes command files, detects patterns, calculates performance impacts
# Following the >50 lines rule from claude-command-file-rules.md

# Define script paths based on type
if [ "$TYPE" = "user" ]; then
    SCRIPT_PATHS=(
        "../scripts/check-performance-optimizations_analyzer.sh"
        ".claude/scripts/agent-complex/check-performance-optimizations_analyzer.sh"
    )
else
    SCRIPT_PATHS=(
        "../scripts/check-performance-optimizations_analyzer.sh"
        ".claude/scripts/agent-complex/check-performance-optimizations_analyzer.sh"
    )
fi

SCRIPT_PATH=""
for path in "${SCRIPT_PATHS[@]}"; do
    if [[ -f "$path" ]]; then
        SCRIPT_PATH="$path"
        break
    fi
done

if [[ -n "$SCRIPT_PATH" ]]; then
    echo "🚀 Using performance analyzer script: $SCRIPT_PATH"
    "$SCRIPT_PATH" "$TYPE" "$DESCRIPTION"
else
    echo "⚠️ Performance analyzer script not found. Using basic fallback..."
    echo "📋 Would analyze command files for performance optimization opportunities"
    echo "📂 Type: $TYPE"
    echo "📝 Context: $DESCRIPTION"
    echo "📝 Script should be created at: ../scripts/check-performance-optimizations_analyzer.sh"
    echo "⚠️ CRITICAL: Cannot perform comprehensive performance analysis without analyzer script"
    exit 1
fi
```

### Script Architecture (If Using External Scripts)

This command requires external scripts due to complex analysis operations:

1. **check-performance-optimizations_analyzer.sh**: Primary implementation
   - Git file discovery and command file parsing
   - Performance pattern detection algorithms
   - Bash code complexity analysis
   - Task tool parallelization opportunities detection
   - Agent coordination efficiency analysis
   - Command reuse opportunity detection
   - Performance impact calculations
   - Detailed recommendation generation

**Script Patterns:**
- User commands: `~/.claude/scripts/agent-complex/check-performance-optimizations_*.sh`
- Project commands: `.claude/scripts/agent-complex/check-performance-optimizations_*.sh`
- Development location: `../scripts/check-performance-optimizations_*.sh`

## Performance Considerations

- **Script Usage**: Use external scripts for complex analysis operations (>50 lines)
- **Parallel Analysis**: Analyze multiple files simultaneously where possible
- **Efficient Pattern Matching**: Use optimized regex and awk patterns for file analysis
- **Memory Management**: Stream large files rather than loading entirely into memory
- **Cache Results**: Cache analysis results for repeated operations on same files

## Optimization Recommendations Generated

### 1. Script Migration Recommendations
```bash
# Example output format:
🔧 SCRIPT MIGRATION OPPORTUNITY
File: ~/.claude/commands/dev/execute-prompt.md
Issue: 78 lines of embedded bash code (threshold: 50 lines)
Performance Impact: 70-80% faster execution
Recommended Script: ../scripts/execute-prompt_main-workflow.sh
Complexity Score: High (multiple git operations, file processing)
```

### 2. Parallel Execution Opportunities
```bash
# Example output format:
⚡ PARALLEL EXECUTION OPPORTUNITY
File: ~/.claude/commands/git/cleanup-pr.md
Current: 4 sequential bash commands (estimated 8 seconds)
Optimized: 4 parallel bash commands (estimated 2 seconds)
Performance Gain: 4x faster
Pattern: Independent git status, branch check, remote sync, validation
```

### 3. Task Tool Parallelization
```bash
# Example output format:
🚨 TASK TOOL OPTIMIZATION
File: ~/.claude/commands/dev/execute-deployment.md
Current: 3 separate messages with Task tool calls
Optimized: Single message with 3 parallel Task tool calls
Performance Gain: 3x faster, better resource utilization
Implementation: Use ONE message with MULTIPLE tool calls
```

### 4. Agent Coordination Efficiency
```bash
# Example output format:
🤖 AGENT COORDINATION OPPORTUNITY
File: .claude/commands/supabase/deploy-edge-function.md
Current: Sequential agent deployment
Optimized: Parallel agent coordination pattern
Agents: @agent-code-reviewer, @agent-security-auditor, @agent-performance-optimizer
Performance Gain: 3-5x faster analysis with specialized insights
```

### 5. Command Reuse Recommendations
```bash
# Example output format:
♻️ COMMAND REUSE OPPORTUNITY
File: ~/.claude/commands/dev/deploy-with-pr.md
Current: 30 lines describing PR creation workflow
Optimized: Call /dev:create-pr command directly
Performance Gain: 85% faster, consistent metadata
Command Type Rules:
  - Current: user command in dev topic
  - Can call: Any user command (dev:create-pr ✅)
  - Cannot call: Root commands (❌)
```

## Requirements

- Git repository (command must be run within a git repository)
- Access to agent-complex documentation for performance optimization patterns
- Read access to command files and scripts in the repository
- Basic shell utilities (grep, awk, find) for file analysis
- Understanding of Claude command execution patterns

## Error Handling

### Common Errors

- **Missing Arguments**: Validates all required arguments are provided
- **Invalid Type**: Ensures type is one of 'root', 'user', or 'project'
- **Repository Requirements**: Verifies git repository context
- **File Access**: Handles permission issues for command file analysis
- **Script Dependencies**: Manages missing analyzer script scenarios

### Error Messages

The command provides clear, actionable error messages with:
- Description of optimization opportunity
- Performance impact estimates
- Specific implementation guidance
- Code examples for optimization patterns

## Related Commands

- `/agent-complex:check-paths` - Validates deployment path accuracy
- `/agent-complex:update-command` - Create or update command files with optimal patterns
- `/agent-complex:update-doc` - Create documentation for performance best practices

## Related Documentation

- `.claude/docs/agent-complex/claude-command-file-rules.md` - Performance optimization guidelines (MANDATORY READING)
- `.claude/docs/agent-complex/agent-complex-rules.md` - Core principles for efficient agent complexes
- `.claude/docs/agent-complex/claude-agent-file-rules.md` - Agent development performance patterns

## Notes

- **Performance Focus**: Specifically targets execution speed and efficiency improvements
- **Pattern Recognition**: Uses proven optimization patterns from claude-command-file-rules.md
- **Actionable Recommendations**: Provides specific code examples and implementation guidance
- **Comprehensive Analysis**: Covers scripts, parallel execution, Task tools, agent coordination, and command reuse
- **Type-Aware Analysis**: Adapts optimization strategies based on command type (root/user/project)
- **Integration with Workflows**: Designed to work within existing development and deployment workflows

## Version History

- **v1.1.0** - Added command reuse optimization
  - Command reuse opportunity detection
  - Type-aware command calling rules
  - Common reusable command patterns
  - Task recapitulation identification
- **v1.0.0** - Initial version
  - Core performance analysis functionality
  - Script migration opportunity detection
  - Parallel execution pattern recognition
  - Task tool optimization analysis
  - Agent coordination efficiency evaluation
  - Basic performance impact calculations
  - Comprehensive recommendation generation system