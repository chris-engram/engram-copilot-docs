# Args: `<type>` `[description]`. v1.0.0. Analyzes command files, scripts, and agents for security vulnerabilities, hardcoded secrets, unsafe patterns, and security best practices compliance. Provides actionable recommendations to improve security posture.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/check-security` in bash.

## Summary

**SECURITY VULNERABILITY ANALYSIS**: Systematically analyzes command files, scripts, agents, and documentation for security vulnerabilities, unsafe patterns, hardcoded secrets, and compliance with security best practices. This command provides comprehensive security assessment with specific remediation guidance.

## Usage

```bash
/agent-complex:check-security <type> [description]
```

## Arguments

- `<type>`: Type of components to analyze for security (REQUIRED)
  - Accepts: 'root', 'user', or 'project'
  - Purpose: Determines which security patterns and risks to analyze
  - **'root'**: Root-level commands and scripts (highest security priority)
    - Analysis scope: `/root/.claude/commands/`, `/root/.claude/scripts/`
    - Focus: Privilege escalation, system access, administrative vulnerabilities
  - **'user'**: Topic-based user commands and agents  
    - Analysis scope: `~/.claude/commands/{topic}/`, `~/.claude/scripts/{topic}/`
    - Focus: User data exposure, workflow security, development vulnerabilities
  - **'project'**: Project-specific commands and configurations
    - Analysis scope: `.claude/commands/{topic}/`, `.claude/scripts/{topic}/`
    - Focus: Deployment security, API keys, project-specific vulnerabilities
- `[description]`: Context description for security analysis (OPTIONAL)
  - Default: "security vulnerability assessment"
  - Examples: "deployment security review", "agent security audit", "pre-production security check"
  - Purpose: Provides context for security analysis scope and risk assessment

## Examples

```bash
# Comprehensive security audit for user-level components
/agent-complex:check-security user "development workflow security review"

# Project deployment security validation
/agent-complex:check-security project "pre-deployment security audit"

# Root-level system security assessment
/agent-complex:check-security root

# Agent complex security validation
/agent-complex:check-security user "agent complex security assessment"

# Pre-commit security check
/agent-complex:check-security project "staged changes security validation"
```

### Quick Reference: Security Risk Categories

| Risk Level | Security Issues | Impact | Priority |
|------------|----------------|--------|----------|
| **Critical** | Hardcoded secrets, RCE vulnerabilities | System compromise | Immediate |
| **High** | Unsafe file operations, privilege escalation | Data exposure | High |
| **Medium** | Input validation gaps, insecure patterns | Limited exposure | Medium |
| **Low** | Security best practice violations | Potential weakness | Low |

## What This Command Does

**IDENTIFIES SECURITY VULNERABILITIES**: Systematically scans command files, scripts, agents, and related components for security vulnerabilities and provides actionable remediation guidance.

### Key Security Analysis Areas

1. **Hardcoded Secrets Detection**
   
   **Pattern Detection**: Embedded credentials, API keys, tokens
   - **API Keys**: AWS, Google Cloud, GitHub tokens
   - **Database Credentials**: Passwords, connection strings
   - **Encryption Keys**: Private keys, certificates
   - **Service Tokens**: OAuth tokens, service account keys
   
   **Examples of Secret Detection:**
   ```bash
   # DETECTED: Hardcoded API key
   # FILE: scripts/deploy_service.sh
   # LINE: 45
   # PATTERN: export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
   # SEVERITY: CRITICAL
   # RECOMMENDATION: Use environment variables or secret management
   ```

2. **Command Injection Vulnerability Analysis**
   
   **Pattern Detection**: Unsafe command construction and execution
   - **Unquoted Variables**: Variables in bash commands without quotes
   - **User Input Injection**: Direct user input in command execution
   - **Eval Usage**: Use of eval with untrusted input
   - **Shell Metacharacters**: Unsafe handling of special characters
   
   **Command Injection Examples:**
   ```bash
   # DETECTED: Command injection vulnerability
   # FILE: commands/process-input.md
   # LINE: 78
   # PATTERN: bash -c "process $USER_INPUT"
   # SEVERITY: HIGH
   # RECOMMENDATION: Quote variables, validate input, use safer alternatives
   ```

3. **File System Security Analysis**
   
   **Pattern Detection**: Unsafe file operations and path traversal
   - **Path Traversal**: ../../../ patterns in file operations
   - **Unsafe Permissions**: Overly permissive file permissions
   - **Temporary Files**: Insecure temporary file creation
   - **File Overwrites**: Unsafe file write operations
   
   **File Security Issues:**
   ```bash
   # DETECTED: Path traversal vulnerability
   # FILE: scripts/file_processor.sh
   # LINE: 23
   # PATTERN: cp "$1" "/target/dir/"
   # SEVERITY: HIGH
   # RECOMMENDATION: Validate file paths, use basename, implement path checking
   ```

4. **Input Validation Security Assessment**
   
   **Pattern Detection**: Missing or inadequate input validation
   - **Argument Validation**: Missing parameter validation
   - **Type Checking**: Lack of input type verification
   - **Length Limits**: No input length restrictions
   - **Character Filtering**: Missing dangerous character filtering
   
   **Input Validation Issues:**
   ```bash
   # DETECTED: Missing input validation
   # FILE: commands/user-input.md
   # LINE: 12
   # PATTERN: USER_DATA="$1"
   # SEVERITY: MEDIUM
   # RECOMMENDATION: Add input validation, sanitization, length checks
   ```

5. **Privilege and Permission Analysis**
   
   **Pattern Detection**: Privilege escalation and permission issues
   - **Sudo Usage**: Inappropriate sudo command usage
   - **File Permissions**: Overly permissive script permissions
   - **User Context**: Operations requiring elevated privileges
   - **Service Accounts**: Insecure service account usage
   
6. **Network Security Assessment**
   
   **Pattern Detection**: Insecure network operations
   - **HTTP vs HTTPS**: Use of insecure HTTP connections
   - **Certificate Validation**: Disabled SSL/TLS verification
   - **API Endpoints**: Insecure API endpoint usage
   - **Network Timeouts**: Missing network security controls

### Security Analysis Process

1. **Component Discovery**: Identify all security-relevant files in scope
2. **Pattern Scanning**: Search for known vulnerability patterns
3. **Context Analysis**: Understand security impact within component context
4. **Risk Assessment**: Classify findings by severity and exploitability
5. **Remediation Planning**: Generate specific fix recommendations
6. **Compliance Checking**: Validate against security best practices
7. **Report Generation**: Create actionable security report

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from agent-complex documentation regarding external script usage for complex security analysis.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/check-security` directly in bash**
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
    echo "Usage: /agent-complex:check-security <type> [description]"
    echo "  type: 'root', 'user', or 'project'"
    echo "  description: Optional context for security analysis"
    exit 1
fi

TYPE="$1"
DESCRIPTION="${2:-security vulnerability assessment}"

# Validate type argument
if [ "$TYPE" != "root" ] && [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'root', 'user', or 'project'"
    exit 1
fi

# Display security analysis context
echo "🔒 Analyzing security vulnerabilities and best practices..."
echo "📋 Context: $DESCRIPTION"
echo "🎯 Goal: Identify and remediate security vulnerabilities"
echo "📂 Scope: $(if [ "$TYPE" = "root" ]; then echo "Root-level (high privilege)"; elif [ "$TYPE" = "user" ]; then echo "User-level workflows"; else echo "Project-specific components"; fi)"

# 🔴 DECISION POINT: Complex security analysis requires external scripts
# This command performs pattern matching, vulnerability scanning, risk assessment
# Following the >50 lines rule from claude-command-file-rules.md

# Define script paths based on type
if [ "$TYPE" = "user" ]; then
    SCRIPT_PATHS=(
        "../scripts/check-security_analyzer.sh"
        ".claude/scripts/agent-complex/check-security_analyzer.sh"
    )
else
    SCRIPT_PATHS=(
        "../scripts/check-security_analyzer.sh"
        ".claude/scripts/agent-complex/check-security_analyzer.sh"
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
    echo "🚀 Using security analyzer script: $SCRIPT_PATH"
    "$SCRIPT_PATH" "$TYPE" "$DESCRIPTION"
else
    echo "⚠️ Security analyzer script not found. Using basic fallback..."
    echo "📋 Would analyze components for security vulnerabilities"
    echo "📂 Type: $TYPE"
    echo "📝 Context: $DESCRIPTION"
    echo "📝 Script should be created at: ../scripts/check-security_analyzer.sh"
    echo "⚠️ CRITICAL: Cannot perform comprehensive security analysis without analyzer script"
    exit 1
fi
```

### Script Architecture (If Using External Scripts)

This command requires external scripts due to complex security analysis operations:

1. **check-security_analyzer.sh**: Primary implementation
   - Git file discovery and security-relevant file identification
   - Pattern-based vulnerability scanning
   - Secret detection algorithms
   - Command injection analysis
   - File system security assessment
   - Input validation verification
   - Risk classification and scoring
   - Remediation recommendation generation

**Script Patterns:**
- User commands: `~/.claude/scripts/agent-complex/check-security_*.sh`
- Project commands: `.claude/scripts/agent-complex/check-security_*.sh`
- Development location: `../scripts/check-security_*.sh`

## Security Checks Performed

### 1. Hardcoded Secrets Detection
```bash
# Example output format:
🚨 CRITICAL: HARDCODED SECRETS DETECTED
Found: 3 potential secrets
Issues:
  - scripts/deploy.sh:23 - API key pattern detected
  - commands/setup.md:45 - Database password in plain text
  - agents/service.md:67 - OAuth token embedded
Risk: Credential exposure, unauthorized access
Remediation: Move to environment variables, use secret management
```

### 2. Command Injection Vulnerabilities
```bash
# Example output format:
⚠️ HIGH: COMMAND INJECTION RISKS
Found: 2 injection vulnerabilities
Issues:
  - commands/process.md:34 - Unquoted variable in bash command
  - scripts/handler.sh:78 - User input directly in command execution
Risk: Remote code execution, system compromise
Remediation: Quote variables, validate input, use parameter arrays
```

### 3. File System Security Issues
```bash
# Example output format:
🔍 MEDIUM: FILE SYSTEM SECURITY ISSUES
Found: 4 file security concerns
Issues:
  - scripts/backup.sh:12 - Overly permissive file permissions (777)
  - commands/copy.md:56 - Potential path traversal vulnerability
  - scripts/temp.sh:23 - Insecure temporary file creation
  - commands/write.md:89 - Unsafe file overwrite operation
Risk: Data exposure, file system compromise
Remediation: Restrict permissions, validate paths, use secure temp files
```

### 4. Input Validation Gaps
```bash
# Example output format:
⚡ MEDIUM: INPUT VALIDATION WEAKNESSES
Found: 5 validation gaps
Issues:
  - commands/input.md:15 - Missing argument validation
  - scripts/process.sh:67 - No input length limits
  - commands/user.md:34 - Missing character filtering
  - agents/handler.md:89 - Type validation missing
Risk: Input-based attacks, data corruption
Remediation: Add validation, sanitization, length checks, type verification
```

## Security Best Practices Validated

### 1. Credential Management
- ✅ No hardcoded secrets in files
- ✅ Environment variables used for sensitive data
- ✅ Secret management integration implemented
- ✅ Credential rotation capabilities present

### 2. Input Security
- ✅ All inputs validated and sanitized
- ✅ Type checking implemented
- ✅ Length limits enforced
- ✅ Dangerous characters filtered

### 3. File System Security
- ✅ Appropriate file permissions set
- ✅ Path traversal protection implemented
- ✅ Secure temporary file handling
- ✅ Safe file operation patterns

### 4. Network Security
- ✅ HTTPS used for all external communications
- ✅ Certificate validation enabled
- ✅ Secure API endpoint usage
- ✅ Network timeouts and limits configured

## Requirements

- Git repository (analyzes security-relevant files in working directory)
- Read access to command files, scripts, and documentation
- Basic security scanning utilities (grep, awk, find)
- Understanding of common vulnerability patterns
- Access to security best practices documentation

## Error Handling

### Common Errors

- **Missing Arguments**: Validates required arguments are provided
- **Invalid Type**: Ensures type is valid (root/user/project)
- **File Access**: Handles permission issues for security analysis
- **Pattern Parsing**: Manages complex regex and pattern matching errors
- **Script Dependencies**: Provides fallback when security analyzer unavailable

### Error Recovery

- Individual file analysis failures don't stop security assessment
- Partial results reported when some checks fail
- Clear guidance for resolving security issues
- Fallback validation when automation isn't available

## Security Report Format

```bash
# Example comprehensive security report:
🔒 SECURITY ASSESSMENT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scope: user-level components
Files Analyzed: 47
Analysis Time: 2.3 seconds

RISK SUMMARY:
🚨 Critical: 2 issues (immediate attention required)
⚠️ High: 5 issues (address within 24 hours)
🔍 Medium: 8 issues (address within week)
⚡ Low: 12 issues (address when convenient)

CRITICAL ISSUES:
1. Hardcoded GitHub token in deploy script
   File: scripts/deploy_github.sh:23
   Fix: Move to GITHUB_TOKEN environment variable

2. SQL injection vulnerability in database query
   File: commands/query-data.md:45
   Fix: Use parameterized queries, input validation

HIGH PRIORITY ISSUES:
[Detailed list with specific remediation steps]

SECURITY SCORE: 6.2/10 (Needs Improvement)
COMPLIANCE: 78% with security best practices

IMMEDIATE ACTIONS:
1. Remove hardcoded credentials (Critical)
2. Fix command injection vulnerabilities (High)
3. Implement missing input validation (Medium)

NEXT SECURITY REVIEW: After critical issues resolved
```

## Related Commands

- `/agent-complex:check-paths <type> [description]` - Validate deployment paths and references
- `/agent-complex:check-performance-optimizations <type> [description]` - Analyze performance opportunities
- `/agent-complex:check-documentation <type> [description]` - Validate documentation quality
- `/agent-complex:run-qa <type> [description]` - Comprehensive quality assurance including security

## Related Documentation

- `.claude/docs/agent-complex/agent-complex-rules.md` - Security considerations for agent complexes
- `.claude/docs/agent-complex/claude-command-file-rules.md` - Security patterns for command files
- `.claude/docs/agent-complex/qa-patterns.md` - Security validation in QA workflows

## Notes

- **Comprehensive Coverage**: Analyzes multiple security dimensions systematically
- **Risk-Based Prioritization**: Focuses on highest impact vulnerabilities first
- **Actionable Recommendations**: Provides specific fixes with implementation guidance
- **Integration Ready**: Works seamlessly with QA and development workflows
- **Extensible Pattern**: Framework accommodates additional security checks
- **Best Practice Enforcement**: Validates compliance with established security standards

## Version History

- **v1.0.0** - Initial release
  - Hardcoded secrets detection
  - Command injection vulnerability analysis
  - File system security assessment
  - Input validation verification
  - Network security analysis
  - Risk classification and scoring
  - Comprehensive remediation recommendations