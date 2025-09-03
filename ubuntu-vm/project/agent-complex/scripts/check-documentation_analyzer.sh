#!/bin/bash
set -euo pipefail

# Documentation Quality Analyzer Script
# Purpose: Analyze documentation completeness, accuracy, and AI optimization
# Usage: check-documentation_analyzer.sh <type> <description>
# Version: 1.0.0

# Parse arguments
TYPE="$1"
DESCRIPTION="$2"

echo "📚 Documentation Quality Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Type: $TYPE"
echo "Context: $DESCRIPTION"
echo ""

echo "🔍 Analyzing documentation files in working directory..."
echo ""

# Get list of modified/added files from git
CHANGED_FILES=$(git status --porcelain | grep -E '\.(md|rst|txt)$' | cut -c4- || echo "")

if [[ -z "$CHANGED_FILES" ]]; then
    echo "ℹ️ No documentation files found in working directory changes"
    echo "✅ Documentation analysis complete - no files to analyze"
    exit 0
fi

echo "📂 Documentation files to analyze:"
echo "$CHANGED_FILES" | sed 's/^/  - /'
echo ""

# Initialize counters
TOTAL_FILES=0
ISSUES_FOUND=0
AI_OPTIMIZATION_ISSUES=0
FORMAT_ISSUES=0
COMPLETENESS_ISSUES=0

echo "📋 DOCUMENTATION ANALYSIS RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Analyze each documentation file
while IFS= read -r file; do
    if [[ -n "$file" && -f "$file" ]]; then
        ((TOTAL_FILES++))
        echo ""
        echo "📄 Analyzing: $file"
        
        # Check for basic markdown structure
        if ! grep -q "^#" "$file" 2>/dev/null; then
            echo "  ⚠️ MEDIUM: Missing heading structure for AI optimization"
            ((AI_OPTIMIZATION_ISSUES++))
            ((ISSUES_FOUND++))
        fi
        
        # Check for hyperlinks instead of inline code
        if grep -q '\[.*\](.*\.md)' "$file" 2>/dev/null; then
            echo "  🚨 CRITICAL: Uses hyperlinks instead of inline code format"
            echo "    Fix: Convert [doc](path) to \`path\`"
            ((FORMAT_ISSUES++))
            ((ISSUES_FOUND++))
        fi
        
        # Check for proper code block formatting
        if grep -q '```' "$file" 2>/dev/null; then
            echo "  ✅ Code blocks present (good for AI consumption)"
        else
            echo "  ⚡ LOW: Consider adding code examples for better AI optimization"
            ((AI_OPTIMIZATION_ISSUES++))
        fi
        
        # Check for table of contents or structure
        if grep -qE "(Table of Contents|## Table of Contents)" "$file" 2>/dev/null; then
            echo "  ✅ Structured with table of contents"
        elif [[ $(grep -c "^##" "$file" 2>/dev/null || echo 0) -gt 3 ]]; then
            echo "  ⚡ LOW: Consider adding table of contents for better navigation"
        fi
        
        # Check file length (empty or too short files)
        LINE_COUNT=$(wc -l < "$file" 2>/dev/null || echo 0)
        if [[ $LINE_COUNT -lt 10 ]]; then
            echo "  ⚠️ MEDIUM: File appears incomplete (< 10 lines)"
            ((COMPLETENESS_ISSUES++))
            ((ISSUES_FOUND++))
        fi
        
    fi
done <<< "$CHANGED_FILES"

echo ""
echo "📊 DOCUMENTATION QUALITY SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Files Analyzed: $TOTAL_FILES"
echo "Total Issues: $ISSUES_FOUND"
echo "  - Format Issues: $FORMAT_ISSUES"
echo "  - AI Optimization Issues: $AI_OPTIMIZATION_ISSUES" 
echo "  - Completeness Issues: $COMPLETENESS_ISSUES"
echo ""

if [[ $ISSUES_FOUND -eq 0 ]]; then
    echo "✅ EXCELLENT: All documentation follows quality standards"
    echo "Score: 10/10"
elif [[ $ISSUES_FOUND -le 2 ]]; then
    echo "✅ GOOD: Minor documentation improvements needed"
    echo "Score: 8/10"
elif [[ $ISSUES_FOUND -le 5 ]]; then
    echo "⚠️ FAIR: Several documentation improvements recommended"
    echo "Score: 6/10"
else
    echo "❌ NEEDS WORK: Significant documentation improvements required"
    echo "Score: 4/10"
fi

echo ""
echo "💡 KEY RECOMMENDATIONS:"
if [[ $FORMAT_ISSUES -gt 0 ]]; then
    echo "  1. Convert all documentation hyperlinks to inline code format"
fi
if [[ $AI_OPTIMIZATION_ISSUES -gt 0 ]]; then
    echo "  2. Improve AI optimization with better structure and examples"
fi
if [[ $COMPLETENESS_ISSUES -gt 0 ]]; then
    echo "  3. Expand incomplete documentation files"
fi
echo "  4. Follow patterns in .claude/docs/agent-complex/qa-patterns.md"

echo ""
echo "🔍 Documentation analysis completed successfully"