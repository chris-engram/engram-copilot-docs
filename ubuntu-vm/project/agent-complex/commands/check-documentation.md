# Args: `<type>` `[description]`. v1.0.0. Analyzes documentation completeness, accuracy, and AI optimization for agent complexes. Validates that all required documentation exists, uses proper formatting, follows established patterns, and provides actionable content optimized for AI consumption.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/check-documentation` in bash.

## Summary

**DOCUMENTATION QUALITY ANALYSIS**: Validates documentation completeness, accuracy, and AI optimization for agent complexes, commands, scripts, and workflows. This command systematically analyzes documentation files to ensure they exist, follow established patterns, provide actionable content, and are properly optimized for AI agent consumption.

## Usage

```bash
/agent-complex:check-documentation <type> [description]
```

## Arguments

- `<type>`: Type of documentation to analyze (REQUIRED)
  - Accepts: 'root', 'user', or 'project'
  - Purpose: Determines which documentation patterns and requirements to validate
  - **'root'**: Root-level documentation
    - Analysis scope: `/root/.claude/docs/`
    - Focus: System administration, root-level operations
  - **'user'**: Topic-based user documentation  
    - Analysis scope: `~/.claude/docs/{topic}/`
    - Focus: Development workflows, user automation patterns
  - **'project'**: Project-specific documentation
    - Analysis scope: `.claude/docs/{topic}/`
    - Focus: Project-specific operations, deployment guides
- `[description]`: Context description for documentation analysis (OPTIONAL)
  - Default: "documentation quality assessment"
  - Examples: "agent complex docs", "command documentation", "workflow guides"
  - Purpose: Provides context for analysis scope and reporting

## Examples

```bash
# Analyze user-level documentation completeness
/agent-complex:check-documentation user "agent complex documentation review"

# Check project-specific documentation quality
/agent-complex:check-documentation project "deployment guide documentation"

# Validate root-level system documentation
/agent-complex:check-documentation root

# Analyze documentation for specific workflow
/agent-complex:check-documentation user "dev topic workflow documentation"

# Pre-commit documentation validation
/agent-complex:check-documentation project "staged documentation changes"
```

### Quick Reference: Documentation Standards

| Quality Aspect | Requirement | Validation Method | Priority |
|----------------|-------------|-------------------|----------|
| **Existence** | All referenced docs exist | File system verification | Critical |
| **Format** | Markdown with proper structure | Pattern validation | Critical |
| **AI Optimization** | Structured for AI consumption | Content analysis | High |
| **Completeness** | All required sections present | Template compliance | High |
| **Accuracy** | Content matches implementation | Cross-reference validation | Medium |
| **Examples** | Practical demonstrations included | Example verification | Medium |

## What This Command Does

**VALIDATES DOCUMENTATION ECOSYSTEM**: Systematically analyzes documentation files to ensure comprehensive, accurate, and AI-optimized knowledge bases that support agent complex operations.

### Key Analysis Areas

1. **Documentation Existence Validation**
   
   **Pattern Detection**: Missing or orphaned documentation files
   - **Critical Check**: All referenced documentation exists
   - **Cross-Reference**: Validate links between documents
   - **Completeness**: Ensure required documentation coverage
   - **Organization**: Verify proper topic-based structure
   
   **Examples of Documentation Existence Issues:**
   ```bash
   # DETECTED: Missing referenced documentation
   # FILE: agents/complex-agent.md
   # ISSUE: References .claude/docs/complex/workflow-guide.md (NOT FOUND)
   # RECOMMENDATION: Create missing workflow-guide.md or update reference
   ```

2. **AI Optimization Analysis**
   
   **Pattern Detection**: Documentation structure and content optimization
   - **Structure**: Clear headings, consistent formatting
   - **Actionable Content**: Focus on "how-to" rather than "what-is"  
   - **Examples**: Concrete demonstrations and code samples
   - **Decision Trees**: Clear decision-making frameworks
   - **Cross-References**: Proper linking and navigation
   
   **AI Optimization Standards:**
   ```bash
   # DETECTED: Poor AI optimization
   # FILE: docs/workflow-guide.md
   # ISSUE: Missing actionable structure, no examples
   # RECOMMENDATION: Add step-by-step procedures, code examples
   # IMPACT: Agents cannot effectively use this documentation
   ```

3. **Content Completeness Validation**
   
   **Pattern Detection**: Missing required sections and information
   - **Agent Documentation**: Critical Context, Available Commands tables
   - **Command Documentation**: Usage examples, error handling
   - **Workflow Guides**: Step-by-step procedures, troubleshooting
   - **Reference Material**: Comprehensive coverage of topic
   
   **Required Documentation Sections:**
   ```bash
   # For Agent Files:
   # - Critical Context section with document loading instructions
   # - Available Commands table with complete usage information
   # - Core Competencies with practical focus
   # - Methodology with step-by-step approach
   
   # For Workflow Guides:
   # - Overview with clear objectives
   # - Prerequisites and requirements
   # - Step-by-step procedures
   # - Common issues and troubleshooting
   # - Examples and demonstrations
   ```

4. **Format and Pattern Compliance**
   
   **Pattern Detection**: Adherence to established documentation standards
   - **Markdown Structure**: Proper heading hierarchy
   - **Code Formatting**: Consistent code block formatting
   - **Reference Format**: Inline code vs hyperlinks
   - **Template Compliance**: Following established patterns
   
   **Format Compliance Examples:**
   ```bash
   # DETECTED: Format violations
   # FILE: docs/command-guide.md
   # ISSUE: Uses hyperlinks [doc](path) instead of inline code `path`
   # RECOMMENDATION: Convert to inline code format
   # PATTERN: All doc references must use `.claude/docs/path` format
   ```

5. **Cross-Reference Validation**
   
   **Pattern Detection**: Broken or incorrect document references
   - **Internal Links**: References between documentation files
   - **Command References**: Links to actual command files
   - **Agent References**: Links to agent files
   - **External References**: Validation of external resources
   
6. **Content Accuracy Assessment**
   
   **Pattern Detection**: Outdated or incorrect information
   - **Command Examples**: Verify examples still work
   - **Path References**: Ensure paths are current and correct
   - **Version Compatibility**: Check for outdated information
   - **Implementation Alignment**: Content matches actual code

### Analysis Process

1. **Documentation Discovery**: Identify all documentation files in scope
2. **Existence Verification**: Check that all referenced docs exist
3. **Structure Analysis**: Validate markdown structure and formatting
4. **Content Assessment**: Analyze for AI optimization and completeness
5. **Cross-Reference Validation**: Verify all internal and external links
6. **Pattern Compliance**: Check adherence to documentation standards
7. **Quality Scoring**: Generate metrics for documentation quality
8. **Issue Reporting**: Provide specific, actionable recommendations

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from agent-complex documentation regarding external script usage for complex analysis.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/check-documentation` directly in bash**
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
    echo "Usage: /agent-complex:check-documentation <type> [description]"
    echo "  type: 'root', 'user', or 'project'"
    echo "  description: Optional context for analysis"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-documentation quality assessment}"

# Validate type argument
if [ "$TYPE" != "root" ] && [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'root', 'user', or 'project'"
    exit 1
fi

# Display analysis context
echo "📚 Analyzing documentation quality and completeness..."
echo "📋 Context: $DESCRIPTION"
echo "🎯 Goal: Ensure comprehensive, accurate, AI-optimized documentation"
echo "📂 Scope: $(if [ "$TYPE" = "root" ]; then echo "Root-level documentation"; elif [ "$TYPE" = "user" ]; then echo "User-level documentation"; else echo "Project-level documentation"; fi)"

# 🔴 DECISION POINT: Complex documentation analysis requires external scripts
# This command analyzes documentation structure, content, cross-references
# Following the >50 lines rule from claude-command-file-rules.md

# Define script paths based on type
if [ "$TYPE" = "user" ]; then
    SCRIPT_PATHS=(
        "../scripts/check-documentation_analyzer.sh"
        ".claude/scripts/agent-complex/check-documentation_analyzer.sh"
    )
else
    SCRIPT_PATHS=(
        "../scripts/check-documentation_analyzer.sh"
        ".claude/scripts/agent-complex/check-documentation_analyzer.sh"
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
    echo "🚀 Using documentation analyzer script: $SCRIPT_PATH"
    "$SCRIPT_PATH" "$TYPE" "$DESCRIPTION"
else
    echo "⚠️ Documentation analyzer script not found. Using basic fallback..."
    echo "📋 Would analyze documentation files for quality and completeness"
    echo "📂 Type: $TYPE"
    echo "📝 Context: $DESCRIPTION"
    echo "📝 Script should be created at: ../scripts/check-documentation_analyzer.sh"
    echo "⚠️ CRITICAL: Cannot perform comprehensive documentation analysis without analyzer script"
    exit 1
fi
```

### Script Architecture (If Using External Scripts)

This command requires external scripts due to complex documentation analysis operations:

1. **check-documentation_analyzer.sh**: Primary implementation
   - Git file discovery and documentation parsing
   - Documentation existence verification
   - AI optimization pattern analysis
   - Content completeness validation
   - Cross-reference verification
   - Format compliance checking
   - Quality scoring and metrics
   - Detailed recommendation generation

**Script Patterns:**
- User commands: `~/.claude/scripts/agent-complex/check-documentation_*.sh`
- Project commands: `.claude/scripts/agent-complex/check-documentation_*.sh`
- Development location: `../scripts/check-documentation_*.sh`

## Quality Checks Performed

### 1. Documentation Existence
```bash
# Example output format:
📚 DOCUMENTATION EXISTENCE CHECK
Found: 15 documentation files
Missing: 3 referenced documents
Issues:
  - agents/complex-agent.md references missing workflow-guide.md
  - commands/deploy.md references missing troubleshooting.md
Recommendations: Create missing files or update references
```

### 2. AI Optimization Assessment
```bash
# Example output format:
🤖 AI OPTIMIZATION ANALYSIS
Score: 7/10 (Good)
Issues Found:
  - docs/guide.md: Missing actionable structure
  - docs/patterns.md: No practical examples
  - docs/reference.md: Poor heading hierarchy
Recommendations: Add step-by-step procedures, code examples, improve structure
```

### 3. Content Completeness
```bash
# Example output format:
✅ CONTENT COMPLETENESS CHECK
Agent Files: 8/10 complete
  - Missing: Critical Context sections in 2 files
  - Missing: Available Commands tables in 1 file
Command Files: 12/15 complete  
  - Missing: Usage examples in 3 files
  - Missing: Error handling docs in 2 files
```

### 4. Format Compliance
```bash
# Example output format:
📝 FORMAT COMPLIANCE ANALYSIS
Compliant: 18/20 files
Issues:
  - docs/guide.md: Uses hyperlinks instead of inline code
  - docs/reference.md: Inconsistent code block formatting
Fix Rate: 90% (Minor formatting updates needed)
```

## Requirements

- Git repository (analyzes documentation in working directory)
- Access to agent-complex documentation for validation patterns
- Read access to documentation files and directories
- Basic utilities (grep, find, awk) for content analysis
- Understanding of AI optimization principles

## Error Handling

### Common Errors

- **Missing Arguments**: Validates required arguments are provided
- **Invalid Type**: Ensures type is valid (root/user/project)
- **Directory Access**: Handles permission issues for documentation files
- **Parsing Errors**: Manages malformed markdown or content issues
- **Script Dependencies**: Provides fallback when analyzer script unavailable

### Error Recovery

- Individual file analysis failures don't stop entire process
- Partial results reported when some checks fail
- Clear guidance for resolving documentation issues
- Fallback validation when automation isn't available

## Related Commands

- `/agent-complex:check-paths <type> [description]` - Validate deployment paths
- `/agent-complex:check-performance-optimizations <type> [description]` - Analyze performance
- `/agent-complex:update-doc <base> <topic> <doc-name> <desc>` - Create/update documentation
- `/agent-complex:run-qa <type> [description]` - Comprehensive quality assurance

## Related Documentation

- `.claude/docs/agent-complex/agent-complex-rules.md` - Documentation standards and patterns
- `.claude/docs/agent-complex/claude-agent-file-rules.md` - Agent documentation requirements
- `.claude/docs/agent-complex/claude-command-file-rules.md` - Command documentation guidelines
- `.claude/docs/agent-complex/qa-patterns.md` - QA methodology and best practices

## Notes

- **Comprehensive Analysis**: Covers existence, format, content, and optimization
- **AI Focus**: Specifically validates documentation for AI agent consumption
- **Actionable Results**: Provides specific fixes with file locations
- **Quality Metrics**: Generates quantitative assessment scores
- **Integration Ready**: Works seamlessly with QA workflow
- **Extensible Pattern**: Framework accommodates additional documentation checks

## Version History

- **v1.0.0** - Initial release
  - Documentation existence validation
  - AI optimization analysis
  - Content completeness checking
  - Format compliance verification
  - Cross-reference validation
  - Quality scoring and metrics
  - Comprehensive recommendation generation