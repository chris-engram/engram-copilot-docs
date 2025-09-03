#!/bin/bash
set -euo pipefail

# Security Vulnerability Analyzer Script
# Purpose: Analyze command files, scripts, and agents for security vulnerabilities
# Usage: check-security_analyzer.sh <type> <description>
# Version: 1.0.0

# Parse arguments
TYPE="$1"
DESCRIPTION="$2"

echo "🔒 Security Vulnerability Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Type: $TYPE"
echo "Context: $DESCRIPTION"
echo ""

echo "🔍 Scanning for security vulnerabilities in working directory..."
echo ""

# Get list of modified/added files from git
CHANGED_FILES=$(git status --porcelain | grep -E '\.(md|sh|js|py|ts|yml|yaml|json)$' | cut -c4- || echo "")

if [[ -z "$CHANGED_FILES" ]]; then
    echo "ℹ️ No security-relevant files found in working directory changes"
    echo "✅ Security analysis complete - no files to analyze"
    exit 0
fi

echo "📂 Files to analyze for security:"
echo "$CHANGED_FILES" | sed 's/^/  - /'
echo ""

# Initialize counters
TOTAL_FILES=0
CRITICAL_ISSUES=0
HIGH_ISSUES=0
MEDIUM_ISSUES=0
LOW_ISSUES=0

echo "🚨 SECURITY ANALYSIS RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Common patterns to check for
declare -A PATTERNS=(
    ["hardcoded_github_token"]='gh[ps]_[A-Za-z0-9_]{36,}'
    ["hardcoded_aws_key"]='AKIA[0-9A-Z]{16}'
    ["hardcoded_api_key"]='api_key["\s]*[:=]["\s]*[a-zA-Z0-9]{20,}'
    ["hardcoded_password"]='password["\s]*[:=]["\s]*["\047][^"]{8,}'
    ["command_injection"]='bash -c.*\$'
    ["eval_usage"]='eval.*\$'
    ["unquoted_variables"]='rm.*\$[A-Za-z_][A-Za-z0-9_]*[^"]'
    ["path_traversal"]='\.\./\.\./.*'
    ["insecure_temp"]='/tmp/[a-zA-Z]*[^$]'
)

# Analyze each file
while IFS= read -r file; do
    if [[ -n "$file" && -f "$file" ]]; then
        ((TOTAL_FILES++))
        echo ""
        echo "🔍 Analyzing: $file"
        FILE_ISSUES=0
        
        # Check for hardcoded secrets
        if grep -qiE "(api_key|password|secret|token).*[:=].*[\"'][a-zA-Z0-9]{8,}" "$file" 2>/dev/null; then
            echo "  🚨 CRITICAL: Potential hardcoded credentials detected"
            echo "    Fix: Move to environment variables or secret management"
            echo "    Reference: Use \${VARIABLE_NAME} pattern"
            ((CRITICAL_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for GitHub token patterns
        if grep -qE "gh[ps]_[A-Za-z0-9_]{36,}" "$file" 2>/dev/null; then
            echo "  🚨 CRITICAL: GitHub token pattern detected"
            echo "    Fix: Use \${GITHUB_TOKEN} environment variable"
            ((CRITICAL_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for command injection risks
        if grep -qE 'bash -c.*\$|sh -c.*\$' "$file" 2>/dev/null; then
            echo "  ⚠️ HIGH: Potential command injection vulnerability"
            echo "    Fix: Quote variables and validate input"
            echo "    Pattern: Use bash -c \"\$SAFE_COMMAND\" or parameter arrays"
            ((HIGH_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for unquoted variables in dangerous contexts
        if grep -qE '(rm|cp|mv).*\$[A-Za-z_][A-Za-z0-9_]*[^"]' "$file" 2>/dev/null; then
            echo "  ⚠️ HIGH: Unquoted variables in file operations"
            echo "    Fix: Quote variables: rm \"\$VARIABLE\""
            ((HIGH_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for path traversal patterns
        if grep -qE '\.\./\.\./.*' "$file" 2>/dev/null; then
            echo "  🔍 MEDIUM: Potential path traversal pattern"
            echo "    Fix: Validate paths and use basename for safety"
            ((MEDIUM_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for eval usage
        if grep -qE 'eval.*\$' "$file" 2>/dev/null; then
            echo "  ⚠️ HIGH: Use of eval with variables"
            echo "    Fix: Avoid eval, use safer alternatives"
            ((HIGH_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for insecure temporary files
        if grep -qE '/tmp/[a-zA-Z]*[^$]' "$file" 2>/dev/null; then
            echo "  🔍 MEDIUM: Potential insecure temporary file usage"
            echo "    Fix: Use mktemp for secure temporary files"
            ((MEDIUM_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        # Check for missing input validation in bash scripts
        if [[ "$file" =~ \.sh$ ]] && ! grep -q 'if.*\[\[.*\$[0-9]' "$file" 2>/dev/null; then
            echo "  ⚡ LOW: Consider adding input validation for script arguments"
            echo "    Recommendation: Add checks for required parameters"
            ((LOW_ISSUES++))
        fi
        
        # Check for HTTP vs HTTPS
        if grep -qE 'http://[^/]' "$file" 2>/dev/null; then
            echo "  🔍 MEDIUM: HTTP URLs detected (consider HTTPS)"
            echo "    Fix: Use HTTPS for secure communication"
            ((MEDIUM_ISSUES++))
            ((FILE_ISSUES++))
        fi
        
        if [[ $FILE_ISSUES -eq 0 ]]; then
            echo "  ✅ No security issues detected"
        fi
        
    fi
done <<< "$CHANGED_FILES"

# Calculate total issues and security score
TOTAL_ISSUES=$((CRITICAL_ISSUES + HIGH_ISSUES + MEDIUM_ISSUES + LOW_ISSUES))
SECURITY_SCORE=10

# Deduct points based on severity
SECURITY_SCORE=$((SECURITY_SCORE - (CRITICAL_ISSUES * 4) - (HIGH_ISSUES * 2) - MEDIUM_ISSUES - (LOW_ISSUES / 2)))

# Ensure score doesn't go below 0
if [[ $SECURITY_SCORE -lt 0 ]]; then
    SECURITY_SCORE=0
fi

echo ""
echo "📊 SECURITY ASSESSMENT SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Files Analyzed: $TOTAL_FILES"
echo "Total Issues: $TOTAL_ISSUES"
echo ""
echo "🚨 Critical Issues: $CRITICAL_ISSUES (immediate attention required)"
echo "⚠️ High Priority: $HIGH_ISSUES (address within 24 hours)"
echo "🔍 Medium Priority: $MEDIUM_ISSUES (address within week)"
echo "⚡ Low Priority: $LOW_ISSUES (address when convenient)"
echo ""

if [[ $CRITICAL_ISSUES -gt 0 ]]; then
    echo "🚨 SECURITY STATUS: CRITICAL - Immediate action required"
    echo "❌ Do NOT deploy until critical issues are resolved"
elif [[ $HIGH_ISSUES -gt 0 ]]; then
    echo "⚠️ SECURITY STATUS: HIGH RISK - Address promptly"
    echo "⚠️ Review high priority issues before deployment"
elif [[ $MEDIUM_ISSUES -gt 0 ]]; then
    echo "🔍 SECURITY STATUS: MODERATE RISK - Schedule fixes"
    echo "✅ Safe for deployment with planned improvements"
elif [[ $LOW_ISSUES -gt 0 ]]; then
    echo "⚡ SECURITY STATUS: LOW RISK - Minor improvements"
    echo "✅ Good security posture, minor enhancements available"
else
    echo "✅ SECURITY STATUS: EXCELLENT - No issues found"
    echo "🎯 All files follow security best practices"
fi

echo ""
echo "Security Score: $SECURITY_SCORE/10"

echo ""
echo "💡 IMMEDIATE ACTIONS:"
if [[ $CRITICAL_ISSUES -gt 0 ]]; then
    echo "  1. Remove all hardcoded credentials immediately"
    echo "  2. Move secrets to environment variables"
fi
if [[ $HIGH_ISSUES -gt 0 ]]; then
    echo "  3. Fix command injection vulnerabilities"
    echo "  4. Quote all variables in file operations"
fi
if [[ $MEDIUM_ISSUES -gt 0 ]]; then
    echo "  5. Validate file paths and use secure temporary files"
    echo "  6. Replace HTTP URLs with HTTPS"
fi

echo ""
echo "📚 SECURITY RESOURCES:"
echo "  - Security patterns: .claude/docs/agent-complex/qa-patterns.md"
echo "  - Command security: .claude/docs/agent-complex/claude-command-file-rules.md"

echo ""
echo "🔒 Security analysis completed"

# Exit with error code if critical issues found
if [[ $CRITICAL_ISSUES -gt 0 ]]; then
    exit 1
fi