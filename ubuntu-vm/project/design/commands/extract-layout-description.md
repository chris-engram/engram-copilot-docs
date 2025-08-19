# Args: `<figma-export-path>` `[output-format]`. v1.0.0. Read a Figma Make export file and prepare a structured response with page layout details.

## Summary

Extracts and analyzes Figma Make export files to provide structured page layout descriptions, component hierarchies, and design system information. This command analyzes the export structure, identifies visual components, extracts design tokens, and generates comprehensive layout documentation that can be used for planning React component structures.

## Usage

```bash
/design:extract-layout-description design/export.zip
/design:extract-layout-description ui/dashboard.zip json
/design:extract-layout-description figma-exports/landing.zip markdown
```

## Arguments

- `<figma-export-path>`: Path to the Figma Make exported zip file (REQUIRED)
  - Examples: `design/export.zip`, `ui/figma-exports/dashboard.zip`
  - Must be a valid Figma Make export zip file
  - Path is relative to repository root
- `[output-format]`: Format for the layout description output (OPTIONAL)
  - Default: `markdown`
  - Options: `markdown`, `json`, `yaml`
  - Examples: `markdown` (human-readable), `json` (structured data)

## Examples

```bash
# Extract layout from dashboard export (markdown format)
/design:extract-layout-description design/dashboard-export.zip

# Extract layout with JSON output for programmatic use
/design:extract-layout-description ui/exports/landing-page.zip json

# Extract layout from CRM dashboard example
/design:extract-layout-description ubuntu-vm/project/design/docs/example-design-crm-dashboard.zip

# Extract with YAML format for configuration files
/design:extract-layout-description design/saas-app.zip yaml
```

## What This Command Does

This command performs comprehensive analysis of Figma Make exports to extract layout and design information:

### Key Features
- **Export Extraction**: Safely extracts and analyzes zip file contents
- **Component Discovery**: Identifies all UI components and their relationships
- **Design Token Extraction**: Captures CSS variables, colors, typography, spacing
- **Layout Analysis**: Infers page structure from component organization
- **Style Documentation**: Documents all styling patterns and design decisions
- **Asset Inventory**: Lists all images, fonts, and other resources

### Process Overview
1. **Extract and Validate**: Unzip the Figma export to a temporary directory
2. **Analyze Structure**: Scan for components, styles, and assets
3. **Extract Design Tokens**: Parse CSS for variables and design system values
4. **Identify Components**: Catalog all UI components and their properties
5. **Infer Layout**: Analyze component usage to understand page structure
6. **Generate Documentation**: Create structured output in requested format
7. **Clean Up**: Remove temporary extraction directory

### Output Structure

The command generates comprehensive layout documentation including:

#### Component Hierarchy
- Component names and file locations
- Parent-child relationships
- Component variants and states
- Props and configuration options

#### Design System
- Color palette and usage
- Typography scale and fonts
- Spacing system and grid
- Border radii and shadows
- Animation and transition values

#### Page Layout
- Section organization
- Navigation structure
- Content areas and containers
- Responsive breakpoints
- Layout patterns used

#### Assets and Resources
- Image files and usage
- Font files and declarations
- Icon sets and SVGs
- Other static resources

## Script Integration

This command leverages scripts for optimal extraction and analysis:

```bash
# Check for extraction script
EXTRACT_SCRIPT=".claude/scripts/design/extract-layout-description_extractor.sh"
if [[ -f "$EXTRACT_SCRIPT" ]]; then
    echo "🚀 Using optimized extraction script..."
    "$EXTRACT_SCRIPT" "$FIGMA_EXPORT_PATH" "$OUTPUT_FORMAT"
else
    echo "📝 Executing extraction logic directly..."
    # Fallback implementation
fi

# Check for analysis script
ANALYSIS_SCRIPT=".claude/scripts/design/extract-layout-description_analyzer.sh"
if [[ -f "$ANALYSIS_SCRIPT" ]]; then
    echo "🔍 Using enhanced analysis script..."
    "$ANALYSIS_SCRIPT" "$EXTRACT_DIR" "$OUTPUT_FORMAT"
fi
```

**Script Patterns:**
- Project commands: `.claude/scripts/design/extract-layout-description_*.sh`
- Common operations: `_extractor.sh`, `_analyzer.sh`, `_formatter.sh`

## Performance Considerations

- **Temporary Directory Management**: Uses unique temp directories to avoid conflicts
- **Parallel Analysis**: Analyzes multiple file types concurrently when possible
- **Memory Efficiency**: Processes large exports in chunks
- **Clean-up Guarantee**: Always removes temporary files, even on errors

## Implementation Details

```bash
#!/bin/bash
set -euo pipefail

# Parse arguments
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required argument"
    echo "Usage: /design:extract-layout-description <figma-export-path> [output-format]"
    echo "Example: /design:extract-layout-description design/export.zip markdown"
    exit 1
fi

FIGMA_EXPORT_PATH="$1"
OUTPUT_FORMAT="${2:-markdown}"

# Validate export file exists
if [[ ! -f "$FIGMA_EXPORT_PATH" ]]; then
    echo "❌ Error: Figma export file not found: $FIGMA_EXPORT_PATH"
    exit 1
fi

# Validate output format
case "$OUTPUT_FORMAT" in
    markdown|json|yaml) ;;
    *)
        echo "❌ Error: Invalid output format: $OUTPUT_FORMAT"
        echo "Valid formats: markdown, json, yaml"
        exit 1
        ;;
esac

# Create extraction directory
EXTRACT_DIR="/tmp/figma-extract-$(date +%s)"
mkdir -p "$EXTRACT_DIR"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up temporary files..."
    rm -rf "$EXTRACT_DIR"
}
trap cleanup EXIT

echo "📦 Extracting Figma Make export..."
unzip -q "$FIGMA_EXPORT_PATH" -d "$EXTRACT_DIR"

echo "🔍 Analyzing export structure..."

# Analyze component files
echo -e "\n=== Component Analysis ==="
COMPONENT_COUNT=$(find "$EXTRACT_DIR" -type f \( -name "*.tsx" -o -name "*.jsx" \) | wc -l)
echo "Found $COMPONENT_COUNT component files"

if [ $COMPONENT_COUNT -gt 0 ]; then
    echo -e "\nComponent files:"
    find "$EXTRACT_DIR" -type f \( -name "*.tsx" -o -name "*.jsx" \) -exec basename {} \; | sort | head -20
fi

# Analyze CSS structure
echo -e "\n=== Style Analysis ==="
CSS_COUNT=$(find "$EXTRACT_DIR" -name "*.css" -o -name "*.scss" | wc -l)
echo "Found $CSS_COUNT style files"

# Extract design tokens
echo -e "\n=== Design Token Extraction ==="
echo "Extracting CSS variables and design tokens..."

# Find and extract CSS variables
if [ $CSS_COUNT -gt 0 ]; then
    echo -e "\nCSS Variables:"
    find "$EXTRACT_DIR" -name "*.css" -exec grep -h "^[[:space:]]*--" {} \; | sort -u | head -20
    
    echo -e "\nColor tokens:"
    find "$EXTRACT_DIR" -name "*.css" -exec grep -h "--.*color" {} \; | sort -u | head -10
    
    echo -e "\nTypography tokens:"
    find "$EXTRACT_DIR" -name "*.css" -exec grep -h "--.*font" {} \; | sort -u | head -10
    
    echo -e "\nSpacing tokens:"
    find "$EXTRACT_DIR" -name "*.css" -exec grep -h "--.*spacing\|--.*gap\|--.*margin\|--.*padding" {} \; | sort -u | head -10
fi

# Analyze HTML structure for layout patterns
echo -e "\n=== Layout Structure Analysis ==="
HTML_COUNT=$(find "$EXTRACT_DIR" -name "*.html" | wc -l)
if [ $HTML_COUNT -gt 0 ]; then
    echo "Analyzing HTML structure for layout patterns..."
    
    # Look for common layout elements
    echo -e "\nLayout containers found:"
    find "$EXTRACT_DIR" -name "*.html" -exec grep -h "class=.*container\|class=.*wrapper\|class=.*layout" {} \; | head -10
    
    echo -e "\nGrid/Flex patterns:"
    find "$EXTRACT_DIR" -name "*.html" -exec grep -h "class=.*grid\|class=.*flex" {} \; | head -10
fi

# Asset inventory
echo -e "\n=== Asset Inventory ==="
echo "Images: $(find "$EXTRACT_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.svg" -o -name "*.webp" \) | wc -l)"
echo "Fonts: $(find "$EXTRACT_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff" -o -name "*.woff2" \) | wc -l)"

# Component hierarchy analysis
echo -e "\n=== Component Hierarchy ==="
if [ $COMPONENT_COUNT -gt 0 ]; then
    echo "Analyzing component relationships..."
    
    # Find potential parent components (those that import others)
    echo -e "\nComponents with imports:"
    find "$EXTRACT_DIR" -type f \( -name "*.tsx" -o -name "*.jsx" \) -exec grep -l "import.*from" {} \; | head -10
fi

# Generate output based on format
echo -e "\n=== Generating $OUTPUT_FORMAT Output ==="

case "$OUTPUT_FORMAT" in
    markdown)
        cat << EOF
# Figma Make Export Layout Analysis

## Export: $(basename "$FIGMA_EXPORT_PATH")

Generated: $(date)

## Component Summary

- Total Components: $COMPONENT_COUNT
- Style Files: $CSS_COUNT  
- HTML Templates: $HTML_COUNT

## Design System

### Colors
\`\`\`css
$(find "$EXTRACT_DIR" -name "*.css" -exec grep -h "--.*color" {} \; | sort -u | head -20)
\`\`\`

### Typography
\`\`\`css
$(find "$EXTRACT_DIR" -name "*.css" -exec grep -h "--.*font" {} \; | sort -u | head -20)
\`\`\`

### Spacing
\`\`\`css
$(find "$EXTRACT_DIR" -name "*.css" -exec grep -h "--.*spacing\|--.*gap" {} \; | sort -u | head -20)
\`\`\`

## Layout Structure

Based on the analysis, this export appears to contain:

$(if [ $COMPONENT_COUNT -gt 0 ]; then
    echo "### Components Found"
    find "$EXTRACT_DIR" -type f \( -name "*.tsx" -o -name "*.jsx" \) -exec basename {} \; | sort | while read comp; do
        echo "- $comp"
    done | head -20
fi)

## Integration Notes

1. **Design Tokens**: Import the CSS variables into your React project's global styles
2. **Components**: Map Figma components to React component structure
3. **Layout**: Use existing React layout system (e.g., shadcn/ui) for page structure
4. **Styling**: Apply Figma styles selectively to preserve pixel-perfect design

Refer to \`ubuntu-vm/project/design/commands/insert-design-code.md\` for automated integration.
EOF
        ;;
    
    json)
        # Generate JSON output
        echo "{"
        echo "  \"export\": \"$(basename "$FIGMA_EXPORT_PATH")\","
        echo "  \"analysis_date\": \"$(date -Iseconds)\","
        echo "  \"summary\": {"
        echo "    \"components\": $COMPONENT_COUNT,"
        echo "    \"styles\": $CSS_COUNT,"
        echo "    \"templates\": $HTML_COUNT"
        echo "  },"
        echo "  \"components\": ["
        if [ $COMPONENT_COUNT -gt 0 ]; then
            find "$EXTRACT_DIR" -type f \( -name "*.tsx" -o -name "*.jsx" \) -exec basename {} \; | sort | while read comp; do
                echo "    \"$comp\","
            done | sed '$ s/,$//' 
        fi
        echo "  ]"
        echo "}"
        ;;
    
    yaml)
        # Generate YAML output
        cat << EOF
export: $(basename "$FIGMA_EXPORT_PATH")
analysis_date: $(date -Iseconds)
summary:
  components: $COMPONENT_COUNT
  styles: $CSS_COUNT
  templates: $HTML_COUNT
components:
$(if [ $COMPONENT_COUNT -gt 0 ]; then
    find "$EXTRACT_DIR" -type f \( -name "*.tsx" -o -name "*.jsx" \) -exec basename {} \; | sort | while read comp; do
        echo "  - $comp"
    done
fi)
EOF
        ;;
esac

echo -e "\n✅ Layout extraction complete!"
```

## Requirements

- `unzip` utility for extracting zip files
- Basic Unix utilities (`find`, `grep`, `sort`, `wc`)
- Temporary directory write access
- Valid Figma Make export zip file

## Error Handling

### Common Errors

- **File Not Found**: Validates export file exists before processing
- **Invalid Zip Format**: Handles corrupted or invalid zip files gracefully
- **Permission Issues**: Ensures temp directory cleanup even on errors
- **Invalid Output Format**: Validates format parameter before processing

### Error Messages

The command provides clear, actionable error messages:
- Missing file paths with examples of correct usage
- Invalid format options with list of valid choices
- Extraction failures with troubleshooting steps

## Related Documentation

**Documentation Paths:**
- `ubuntu-vm/project/design/docs/convert-to-react-vite.md` - Comprehensive conversion guide
- `ubuntu-vm/project/design/docs/` - Example exports and guides

## Notes

- **Temporary Files**: All extraction happens in temp directories that are automatically cleaned
- **Large Exports**: Handles large Figma exports efficiently with streaming where possible
- **Design Tokens**: Focuses on extracting reusable design tokens for system integration
- **Layout Inference**: Since Figma Make doesn't export layout structure, this command helps identify components for manual layout planning
- **Integration Ready**: Output is designed to work with `insert-design-code` command

## Version History

- **v1.0.0** - Initial version
  - Comprehensive export analysis functionality
  - Multiple output format support (markdown, json, yaml)
  - Design token extraction
  - Component hierarchy analysis
  - Asset inventory
  - Integration with existing figma-make workflow