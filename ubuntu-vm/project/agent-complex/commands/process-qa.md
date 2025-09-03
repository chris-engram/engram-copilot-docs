# Args: `<type>` `[description]`. v2.0.0. Process comprehensive quality assurance: deploy QA agent → run all check commands → generate quality report

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/run-qa` in bash.

## Summary

This command processes comprehensive quality assurance for agent complexes, commands, scripts, and documentation. It deploys the specialized QA agent to systematically run all available check commands, analyze results, and provide actionable recommendations for improving quality, performance, and deployment readiness. Git workflow management (branches, commits, PRs) should be handled separately.

## Usage

```bash
/agent-complex:process-qa <type> [description]
```

## Arguments

- `<type>`: Type of components to audit (REQUIRED)
  - Accepts: 'root', 'user', 'project', or 'nexus'
  - Purpose: Determines which components and patterns to audit
  - **'root'**: Root-level commands and scripts
    - Audit scope: `/root/.claude/commands/`, `/root/.claude/scripts/`
    - Focus: System-level operations, administrative tasks
  - **'user'**: Topic-based user commands and agents  
    - Audit scope: `~/.claude/commands/{topic}/`, `~/.claude/scripts/{topic}/`
    - Focus: User workflows, automation tasks
  - **'project'**: Project-specific commands and configurations
    - Audit scope: `.claude/commands/{topic}/`, `.claude/scripts/{topic}/`
    - Focus: Project-specific operations, deployment workflows
  - **'nexus'**: Nexus-namespaced commands and configurations
    - Audit scope: `.claude/commands/nexus/{topic}/`, `.claude/scripts/nexus/{topic}/`
    - Focus: Nexus-specific operations, organizational workflows
- `[description]`: Context description for QA analysis (OPTIONAL)
  - Default: "comprehensive quality audit"
  - Examples: "agent complex components", "recent command updates", "deployment preparation"
  - Purpose: Provides context for QA analysis and reporting

## Examples

```bash
# Run comprehensive QA audit on user-level components
/agent-complex:process-qa user "agent complex components for quality review"

# Audit nexus-specific components
/agent-complex:process-qa nexus "authentication and authorization workflows"

# Audit project-specific components before deployment
/agent-complex:process-qa project "deployment preparation quality checks"

# Quick QA check on root-level system commands
/agent-complex:process-qa root

# Audit recent changes with descriptive context
/agent-complex:process-qa user "recent dev topic updates requiring quality validation"

# Pre-commit QA validation for project components
/agent-complex:process-qa project "staged changes ready for quality assessment"

# QA audit for nexus components
/agent-complex:process-qa nexus "nexus authentication and security patterns"
```

### Quick Reference: QA Scope by Type

| Type | Components Audited | Primary Focus | Quality Checks |
|------|-------------------|---------------|----------------|
| **Root** | System commands, root scripts | Administrative operations | Security, reliability, error handling |
| **User** | Topic-based commands, user agents | User workflows | Performance, pattern compliance |
| **Project** | Project commands, deployments | Project-specific automation | Deployment readiness, integration |

### Common QA Scenarios

**Pre-Deployment Quality Checks:**
```bash
# Before deploying user components
/agent-complex:process-qa user "pre-deployment quality validation"

# Before deploying project-specific changes
/agent-complex:process-qa project "final deployment quality checks"
```

**Post-Implementation QA:**
```bash
# After building agent complexes
/agent-complex:process-qa user "new agent complex quality assessment"

# After major command updates
/agent-complex:process-qa user "updated command files requiring QA review"
```

**Continuous Quality Monitoring:**
```bash
# Regular quality audits
/agent-complex:process-qa user "routine quality maintenance check"

# Performance optimization reviews
/agent-complex:process-qa project "performance optimization opportunities"
```

## What This Command Does

### QA Processing Workflow

This command follows a specialized QA workflow:

1. **Deploy QA Agent** 🚨 **QUALITY EXPERT DEPLOYMENT** 🚨
   ```bash
   # Deploy specialized QA agent for comprehensive analysis
   Task tool: "agent-complex:qa - Conduct comprehensive quality assurance audit on <type> components. Context: <description>. Run all available check commands systematically and provide detailed quality report with actionable recommendations."
   ```
   
   **QA Agent Operations:**
   - Analyzes git working directory for changed files
   - Categorizes components by type and scope
   - Executes systematic quality check workflow
   - Provides comprehensive quality assessment

2. **Systematic Quality Check Execution** 🚨 **COMPREHENSIVE ANALYSIS** 🚨
   
   The QA agent executes checks in this priority order:
   
   **Priority 1: Deployment Readiness (CRITICAL)**
   ```bash
   # Always execute first - deployment path validation
   /agent-complex:check-paths <type> "<description>"
   ```
   - Validates all paths work in deployed context
   - Ensures scripts exist and follow naming conventions
   - Verifies documentation references use correct format
   - Checks for hardcoded non-deployment paths

   **Priority 2: Performance Optimization (HIGH)**
   ```bash
   # Always execute second - performance analysis
   /agent-complex:check-performance-optimizations <type> "<description>"
   ```
   - Identifies serial operations that can be parallelized
   - Detects commands that should use external scripts
   - Finds command reuse opportunities
   - Analyzes agent coordination efficiency

   **Priority 3: Future Quality Checks (EXTENSIBLE)**
   ```bash
   # Framework for additional quality checks as they're developed:
   # /agent-complex:check-security <type> "<description>"
   # /agent-complex:check-documentation <type> "<description>"
   # /agent-complex:check-testing <type> "<description>"
   # /agent-complex:check-dependencies <type> "<description>"
   ```

3. **Quality Report Generation** 🚨 **COMPREHENSIVE REPORTING** 🚨
   ```bash
   # QA agent aggregates all check results into comprehensive report
   # Including:
   # - Critical issues requiring immediate attention
   # - Performance optimization opportunities
   # - Pattern compliance validation results
   # - Integration quality assessment
   # - Actionable recommendations with specific fixes
   ```

4. **Issue Prioritization and Recommendations** 🚨 **ACTIONABLE GUIDANCE** 🚨
   ```bash
   # QA agent provides:
   # - Severity classification (critical, warning, info)
   # - Specific file locations and line numbers
   # - Exact fixes with code examples
   # - Performance impact estimates
   # - Implementation guidance
   ```

## Quality Check Framework

### Core Quality Checks (Always Executed)

1. **Deployment Readiness Validation**
   - Path accuracy for deployed context
   - Script existence and naming conventions
   - Documentation reference format compliance
   - Cross-script reference validation
   - Hardcoded path detection and removal

2. **Performance Optimization Analysis**
   - Script migration opportunities (>50 lines embedded code)
   - Parallel execution opportunities
   - Task tool parallelization potential
   - Agent coordination efficiency
   - Command reuse opportunities

### Extensible Quality Framework

The QA system is designed to easily accommodate additional check commands:

```bash
# Future quality checks will integrate seamlessly:
# 
# Security Auditing:
# /agent-complex:check-security <type> "<description>"
# - Scans for security vulnerabilities
# - Validates input sanitization
# - Checks for secure coding practices
# 
# Documentation Completeness:
# /agent-complex:check-documentation <type> "<description>"
# - Verifies all required documentation exists
# - Validates documentation accuracy
# - Checks for proper AI optimization
# 
# Testing Coverage:
# /agent-complex:check-testing <type> "<description>"
# - Analyzes test coverage completeness
# - Validates test quality and patterns
# - Checks for proper test organization
# 
# Dependency Analysis:
# /agent-complex:check-dependencies <type> "<description>"
# - Identifies circular dependencies
# - Validates dependency versions
# - Checks for missing dependencies
```

### Quality Metrics and Reporting

The QA agent provides comprehensive metrics:

- **Deployment Readiness Score**: Percentage of components ready for deployment
- **Performance Optimization Score**: Rating based on efficiency opportunities
- **Pattern Compliance Score**: Adherence to established guidelines
- **Integration Quality Score**: Component interaction reliability
- **Overall Quality Grade**: Aggregate quality assessment

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🔍 PROCESS-QA COMPREHENSIVE QUALITY ASSURANCE"
echo "═══════════════════════════════════════════════════════════════════"

# Parse arguments
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required type argument"
    echo "Usage: /agent-complex:process-qa <type> [description]"
    echo "  type: 'root', 'user', or 'project'"
    echo "  description: Optional context for QA analysis"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-comprehensive quality audit}"

# Validate type argument
if [ "$TYPE" != "root" ] && [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'root', 'user', or 'project'"
    exit 1
fi

echo ""
echo "📋 QA Configuration:"
echo "  - Type: $TYPE"
echo "  - Description: $DESCRIPTION"
echo "  - Scope: $(if [ "$TYPE" = "root" ]; then echo "Root-level system components"; elif [ "$TYPE" = "user" ]; then echo "User-level workflow components"; else echo "Project-specific components"; fi)"
echo ""

# Step 1: Deploy QA Agent for Comprehensive Analysis
echo "1️⃣ Deploying QA Agent for Quality Assessment"
echo "───────────────────────────────────────────────"
echo "🤖 Agent: agent-complex:qa"
echo "🎯 Mission: Comprehensive quality assurance audit"
echo "📊 Scope: $TYPE components"
echo "📝 Context: $DESCRIPTION"
echo ""

Task tool: "agent-complex:qa - Conduct comprehensive quality assurance audit on $TYPE components. Context: $DESCRIPTION. 

Execute the complete QA workflow:

1. DEPLOYMENT READINESS (Priority 1 - Critical):
   - Run /agent-complex:check-paths $TYPE \"$DESCRIPTION\"
   - Validate all paths work in deployed context
   - Ensure script references and naming conventions
   - Verify documentation format compliance

2. PERFORMANCE OPTIMIZATION (Priority 2 - High):  
   - Run /agent-complex:check-performance-optimizations $TYPE \"$DESCRIPTION\"
   - Identify parallelization opportunities
   - Detect script migration needs
   - Find command reuse opportunities

3. QUALITY ANALYSIS:
   - Analyze all check results comprehensively
   - Identify patterns and systemic issues
   - Generate actionable recommendations
   - Provide specific fixes with examples

4. COMPREHENSIVE REPORTING:
   - Create detailed quality assessment report
   - Include severity classifications and priorities
   - Provide performance impact estimates
   - Generate specific implementation guidance

Focus on actionable recommendations that improve deployment readiness, performance, and compliance with agent-complex-rules.md patterns."

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ QA WORKFLOW COMPLETED"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📊 QA Summary:"
echo "  - QA Agent deployed successfully"
echo "  - Comprehensive quality checks executed"
echo "  - Deployment readiness validated"
echo "  - Performance optimization analyzed"
echo "  - Quality report generated with recommendations"
echo ""
echo "🎯 Review the detailed QA report above for specific action items"
echo "💡 Address critical issues before deployment"
echo "⚡ Implement performance optimizations for better efficiency"
```

## Quality Assurance Benefits

### Comprehensive Coverage
- **All Components Analyzed**: Agents, commands, scripts, documentation
- **Multiple Quality Dimensions**: Deployment, performance, patterns, integration
- **Systematic Approach**: Consistent methodology across all audits
- **Extensible Framework**: Easy to add new quality checks

### Actionable Intelligence
- **Specific Issues Identified**: File locations, line numbers, exact problems
- **Concrete Solutions Provided**: Code examples, implementation steps
- **Priority Guidance**: Critical, high, and low priority classifications
- **Performance Impact Estimates**: Expected improvements from fixes

### Quality Improvement
- **Pattern Compliance**: Ensures adherence to established guidelines
- **Best Practices Enforcement**: Promotes optimal implementation patterns
- **Continuous Monitoring**: Regular quality assessments over time
- **Trend Analysis**: Identification of systemic quality issues

## Requirements

- Git repository (QA checks analyze working directory)
- Access to QA agent: `agent-complex:qa`
- Access to check commands:
  - `/agent-complex:check-paths`
  - `/agent-complex:check-performance-optimizations`
- Valid type specification (root/user/project)
- Read access to agent-complex documentation

## Error Handling

### Common Errors

- **Missing Arguments**: Clear usage instructions with examples
- **Invalid Type**: Validation with accepted type values
- **QA Agent Unavailable**: Graceful fallback with manual check guidance
- **Check Command Failures**: Individual check error reporting
- **Repository Issues**: Git working directory validation

### Error Recovery

The command provides comprehensive error handling:
- Individual check failures don't stop the entire QA process
- Partial results are reported when some checks fail
- Clear guidance for resolving common issues
- Fallback instructions when automation isn't available

## Notes

- **Systematic Approach**: Always executes checks in priority order
- **Comprehensive Reporting**: Aggregates results from all available checks
- **Actionable Recommendations**: Focus on specific, implementable fixes
- **Extensible Design**: Framework easily accommodates new quality checks
- **Integration Ready**: Works seamlessly with existing implementation workflows
- **Performance Focused**: Identifies optimization opportunities systematically
- **Quality Standards**: Enforces compliance with agent-complex patterns

## Usage in Implementation Workflow

### Pre-Commit QA
```bash
# Before committing changes
/agent-complex:process-qa user "pre-commit quality validation"
# Review QA report and address issues
# Then commit manually when satisfied
```

### Post-Implementation QA
```bash
# After building agent complexes
/agent-complex:process-qa user "new agent complex quality assessment"
# Address issues based on QA report
```

### Deployment Preparation
```bash
# Before deployment
/agent-complex:process-qa project "deployment readiness validation"
# Ensure all critical issues resolved
# Use reverse-sync workflow for deployment
```

## Related Commands

- `/agent-complex:check-paths <type> [description]` - Validate deployment paths (Priority 1)
- `/agent-complex:check-performance-optimizations <type> [description]` - Analyze performance (Priority 2)
- `/agent-complex:update-agent <base> <type:topic> <name> <desc>` - Update agents with QA feedback
- `/agent-complex:update-command <base> <type:topic> <name> <desc>` - Update commands with QA feedback

## Related Documentation

- `.claude/docs/agent-complex/agent-complex-rules.md` - Core quality standards and patterns
- `.claude/docs/agent-complex/claude-agent-file-rules.md` - Agent implementation quality guidelines
- `.claude/docs/agent-complex/claude-command-file-rules.md` - Command quality requirements
- `.claude/docs/agent-complex/claude-meta-command-file-rules.md` - Meta-command orchestration patterns
- `.claude/docs/agent-complex/qa-patterns.md` - QA workflow patterns and best practices

## Version History

- **v2.0.0** - Removed git workflow management
  - Renamed from run-qa to process-qa
  - Removed PR creation operations
  - Focus on quality assessment only
  - Git workflows now handled separately via reverse-sync
- **v1.0.0** - Initial release
  - Comprehensive QA workflow orchestration
  - Integration with existing check commands
  - Systematic quality assessment methodology
  - Extensible framework for future quality checks
  - Detailed reporting and recommendation generation
  - Priority-based check execution order