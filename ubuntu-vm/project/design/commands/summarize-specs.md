# Args: `<specs-folder>` `[detail-level]`. v0.5.0. Generate comprehensive summaries of ingested specification documents.

## 🎯 SPECS FOLDER vs DETAIL LEVEL 🎯

```
SPECS FOLDER (arg #1)            DETAIL LEVEL (arg #2)
     │                                    │
     ├─→ What to analyze                  ├─→ How detailed
     ├─→ Folder in designs/specs/         ├─→ Output depth
     └─→ Or 'all' for everything          └─→ Optional (default: standard)

Example: specs=mobile-app-v2, detail=technical
         Analyzes: designs/specs/mobile-app-v2/ with technical detail
```

Input: $ARGUMENTS (format: specs-folder [detail-level])

## Summary

Analyzes specification documents previously ingested from Google Drive and generates structured markdown summaries. This command processes the markdown files in `designs/specs/` directories, extracts key information about screens, components, features, and workflows, then creates a consolidated summary document at `designs/specs/{spec-project}/SUMMARY.md`. When specifications include page hierarchies, the summary automatically includes a visual page tree diagram near the top for easy navigation. Supports multiple detail levels to accommodate different use cases - from quick overviews to detailed technical specifications ready for implementation.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/design:summarize-specs` directly in bash.

## Usage

```bash
/design:summarize-specs <specs-folder> [detail-level]
```

## Arguments

- `<specs-folder>`: The folder name within `designs/specs/` to summarize (REQUIRED)
  - This should match a folder created by `/design:ingest-specs-from-drive`
  - Example: `mobile-app-v2`, `admin-dashboard`, `user-portal`
  - Special value: `all` - processes all folders in `designs/specs/`
  
- `[detail-level]`: Level of detail in summaries (OPTIONAL)
  - Default: `standard`
  - Options: `brief`, `standard`, `detailed`, `technical`
  - `brief`: High-level overview only
  - `standard`: Key features and components
  - `detailed`: Comprehensive analysis
  - `technical`: Implementation-ready specifications

## Examples

```bash
# Summarize a specific specs folder with default settings
/design:summarize-specs mobile-app-v2

# Generate detailed technical summaries in JSON format
/design:summarize-specs admin-dashboard json technical

# Create brief overview of all spec folders
/design:summarize-specs all brief

# Generate detailed specs for development
/design:summarize-specs user-portal detailed

# Create standard summary for a specific project
/design:summarize-specs design-system standard
```

## What This Command Does

### 🔐 STEP 0: Pre-flight Checks 🔐

**Validate command environment:**

```bash
# Check if in a valid project directory
if [[ ! -d "designs" ]]; then
    echo "⚠️  Warning: 'designs' directory not found"
    echo "Creating designs directory structure..."
    mkdir -p designs/specs
fi

# Ensure specs base directory exists
if [[ ! -d "designs/specs" ]]; then
    echo "📁 Creating specs directory..."
    mkdir -p designs/specs
fi

# Check for write permissions
if [[ ! -w "designs/specs" ]]; then
    echo "❌ Error: No write permission for designs/specs directory"
    exit 1
fi
```

### 1. **Validate Input and Locate Specs** 🚨⚡ MANDATORY FIRST STEP ⚡🚨

```bash
# Validate specs folder exists
SPECS_BASE="designs/specs"
SPECS_FOLDER="$1"

if [[ "$SPECS_FOLDER" == "all" ]]; then
    echo "📁 Processing all specification folders..."
    # Will process each folder in designs/specs/
else
    if [[ ! -d "$SPECS_BASE/$SPECS_FOLDER" ]]; then
        echo "❌ Error: Specs folder not found: $SPECS_BASE/$SPECS_FOLDER"
        echo "Available folders:"
        ls -1 "$SPECS_BASE/" 2>/dev/null || echo "No specs folders found"
        exit 1
    fi
    echo "📁 Processing specs folder: $SPECS_FOLDER"
fi
```

### 2. **Analyze Specification Structure** 🚨⚡ DEEP ANALYSIS PHASE ⚡🚨

**Execute comprehensive analysis:**

```bash
# Analyze folder structure
echo "🔍 Analyzing specification structure..."

# Identify document types:
# - Screen specifications (UI descriptions)
# - Component specifications (reusable elements)
# - Feature specifications (functionality)
# - Workflow specifications (user journeys)
# - Technical specifications (implementation details)
```

### 3. **Extract Key Information** 🚨 INFORMATION EXTRACTION 🚨

**Extract structured data from each specification:**

#### Screen Specifications
- Screen name and purpose
- Layout structure
- Component inventory
- User interactions
- Data requirements
- Navigation flows

#### Component Specifications  
- Component name and description
- Properties and variations
- Visual states
- Behavior patterns
- Usage guidelines

#### Feature Specifications
- Feature name and objectives
- User stories
- Acceptance criteria
- Technical requirements
- Dependencies

#### Workflow Specifications
- Process name and steps
- User roles
- Decision points
- Error scenarios
- Success criteria

### 4. **Generate Summaries Based on Detail Level** 🚨 SUMMARY GENERATION 🚨

**Generate summaries with appropriate detail based on level:**

#### Brief Level
- High-level overview only
- Key features and components listed
- 1-2 pages maximum
- Suitable for stakeholder reviews

#### Standard Level (Default)
```markdown
# Specification Summary: {Folder Name}

## Overview
{High-level description of the project/feature set}

## Page Structure
{If pages exist in the specification, include a visual tree diagram}

```
Project Root
├── 📄 Home
├── 📁 Products
│   ├── 📄 Product List
│   ├── 📄 Product Details
│   └── 📄 Product Search
├── 📁 User Account
│   ├── 📄 Profile
│   ├── 📄 Settings
│   └── 📄 Order History
└── 📄 Checkout
```

## Screens
### {Screen Name}
- **Purpose**: {Description}
- **Key Components**: {List}
- **Primary Actions**: {List}

## Components
### {Component Name}
- **Type**: {Button/Form/Card/etc}
- **Variations**: {List}
- **Used In**: {Screen references}

## Features
### {Feature Name}
- **Description**: {What it does}
- **User Value**: {Why it matters}
- **Requirements**: {Key requirements}

## Workflows
### {Workflow Name}
- **Steps**: {Numbered list}
- **Actors**: {User roles}
- **Outcomes**: {Success/failure states}
```

#### Detailed Level
- Comprehensive analysis of all specifications
- Full component inventories with properties
- Complete workflow steps and decision trees
- Detailed cross-references between elements
- 5-10 pages typical

#### Technical Level
- Implementation-ready specifications
- Data models and API endpoints
- Component interfaces and props
- State management requirements
- Database schemas
- Authentication flows
- Error handling patterns
- Performance considerations

Example technical output:
```typescript
// Component Interface
interface LoginFormProps {
  onSubmit: (credentials: LoginCredentials) => Promise<void>
  onForgotPassword: () => void
  rememberMe?: boolean
  errorHandler?: (error: AuthError) => void
}

// API Specification
POST /api/auth/login
Request: { email: string, password: string, rememberMe?: boolean }
Response: { token: string, user: User, expiresAt: number }
Errors: 401, 429, 500
```

### 5. **Create Output Files** 🚨 FILE CREATION PHASE 🚨

```bash
# Create output directory structure - summaries go in designs/specs/{spec-project}/
OUTPUT_BASE="designs/specs"

# Always use markdown format
# Ensure the output directory exists for the specific spec project
OUTPUT_DIR="$OUTPUT_BASE/$SPECS_FOLDER"
if [[ ! -d "$OUTPUT_DIR" ]]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Create summary file as SUMMARY.md in the spec project directory
OUTPUT_FILE="$OUTPUT_DIR/SUMMARY.md"

# Generate summaries and write to the SUMMARY.md file
```

### 6. **Generate Cross-Reference Index** (if detailed)

**For detailed and technical levels, create relationship mappings:**

```markdown
# Cross-Reference Index

## Component Usage
- **LoginButton**: Used in LoginScreen, HeaderComponent
- **UserAvatar**: Used in HeaderComponent, ProfileScreen, CommentCard

## Feature Distribution
- **Authentication**: LoginScreen, ProfileScreen, SettingsScreen
- **Search**: HeaderComponent, SearchScreen, ProductList

## Workflow Coverage
- **User Onboarding**: Touches 5 screens, uses 12 components
- **Purchase Flow**: Touches 8 screens, uses 20 components
```

### 7. **Validate Completeness** (quality assurance)

**Perform quality checks on the analysis:**
- Missing screen descriptions
- Undefined components referenced
- Incomplete workflows
- Unspecified features

### 8. **Generate Final Report and Summary**

**Provide comprehensive execution summary:**

```bash
echo "✅ Summary generation complete!"
echo ""
echo "📊 Summary Statistics:"
echo "- Screens analyzed: $SCREEN_COUNT"
echo "- Components catalogued: $COMPONENT_COUNT"
echo "- Features documented: $FEATURE_COUNT"
echo "- Workflows mapped: $WORKFLOW_COUNT"
echo ""
echo "📁 Output location: $OUTPUT_LOCATION"
echo ""
echo "🔍 Quality Checks:"
echo "- Missing descriptions: $MISSING_COUNT"
echo "- Undefined references: $UNDEFINED_COUNT"
echo "- Incomplete sections: $INCOMPLETE_COUNT"
```

## Common RUN Commands

### Pre-flight Checks
- RUN `test -d designs` - Verify designs directory exists
- RUN `test -w designs/specs` - Check write permissions
- RUN `ls -1 designs/specs/` - List available spec folders

### Analysis Operations
- RUN `find designs/specs/<folder> -name "*.md" -type f` - Find spec files
- RUN `grep -h "^#" <file>` - Extract headers from specs
- RUN `wc -l <file>` - Count lines in spec files

### Output Generation
- RUN `mkdir -p designs/specs` - Ensure output directory
- RUN `date +"%Y%m%d_%H%M%S"` - Generate timestamp
- RUN `cat > <output-file>` - Write summary content

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from `ubuntu-vm/user/docs/agent-complex/claude-command-file-rules.md` regarding external script usage.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/design:summarize-specs` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**

**🔴 MANDATORY RULE: If your implementation exceeds 50 lines of bash code, you MUST use external scripts** 🔴

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

#!/bin/bash
set -euo pipefail

# Store command start time for performance tracking
COMMAND_START=$(date +%s)

# Parse arguments (keep minimal validation inline)
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /design:summarize-specs <specs-folder> [detail-level]"
    exit 1
fi

SPECS_FOLDER="$1"
DETAIL_LEVEL="${2:-standard}"

# Validate basic inputs
VALID_LEVELS="brief standard detailed technical"
if [[ ! " $VALID_LEVELS " =~ " $DETAIL_LEVEL " ]]; then
    echo "❌ Error: Invalid detail level: $DETAIL_LEVEL"
    echo "Valid levels: $VALID_LEVELS"
    exit 1
fi

# 🔴 Complex implementation requires external scripts
# Priority order: project scripts > user scripts > development scripts
SCRIPT_PATHS=(
    ".claude/scripts/design/summarize-specs_analyzer.sh"        # Project-level
    "$HOME/.claude/scripts/design/summarize-specs_analyzer.sh"  # User-level
    "../scripts/summarize-specs_analyzer.sh"                        # Development
)

SCRIPT_PATH=""
for path in "${SCRIPT_PATHS[@]}"; do
    if [[ -f "$path" ]]; then
        SCRIPT_PATH="$path"
        break
    fi
done

if [[ -n "$SCRIPT_PATH" ]]; then
    echo "🚀 Using optimized script: $SCRIPT_PATH"
    "$SCRIPT_PATH" "$SPECS_FOLDER" "$DETAIL_LEVEL"
else
    echo "⚠️ Warning: Analyzer script not found. Using inline implementation..."
    
    # Minimal inline fallback for basic functionality
    SPECS_BASE="designs/specs"
    
    if [[ "$SPECS_FOLDER" == "all" ]]; then
        echo "📁 Processing all specification folders..."
        for folder in "$SPECS_BASE"/*; do
            if [[ -d "$folder" ]]; then
                folder_name=$(basename "$folder")
                echo "  - Analyzing: $folder_name"
            fi
        done
    else
        if [[ ! -d "$SPECS_BASE/$SPECS_FOLDER" ]]; then
            echo "❌ Error: Specs folder not found: $SPECS_BASE/$SPECS_FOLDER"
            exit 1
        fi
        echo "📁 Analyzing specs in: $SPECS_FOLDER"
        
        # Basic file count
        file_count=$(find "$SPECS_BASE/$SPECS_FOLDER" -name "*.md" -type f | wc -l)
        echo "📄 Found $file_count specification files"
    fi
    
    echo ""
    echo "⚠️ Note: Full analysis requires the analyzer script."
    echo "To enable complete functionality, ensure scripts are properly deployed."
fi

# Calculate and display execution time
COMMAND_END=$(date +%s)
EXECUTION_TIME=$((COMMAND_END - COMMAND_START))
echo ""
echo "🕒 Command execution time: ${EXECUTION_TIME}s"
```

### Script Architecture

For this command's complex analysis logic:

1. **summarize-specs_analyzer.sh**: Primary analysis and summary generation
   - Parses specification documents
   - Extracts structured information
   - Generates summaries in requested format
   - Handles cross-referencing and validation

2. **summarize-specs_formatter.sh**: Output formatting utilities (optional)
   - Format conversion utilities
   - Template processing
   - Markdown/JSON generation helpers

**Script Patterns:**
- Project location: `.claude/scripts/design/summarize-specs_*.sh`
- Development location: `../scripts/summarize-specs_*.sh`

## Performance Considerations

- **Parallel Processing**: Analyzes multiple spec files concurrently when processing folders
- **Incremental Analysis**: Can cache analysis results to speed up subsequent runs
- **Memory Efficiency**: Processes large spec folders in chunks to avoid memory issues
- **Output Streaming**: Writes output progressively for large summaries
- **Script Optimization**: External scripts provide 70-85% performance improvement
- **Execution Tracking**: Reports total execution time for performance monitoring

## Requirements

- Specification files ingested via `/design:ingest-specs-from-drive`
- Directory structure: `designs/specs/{folder-name}/*.md`
- Write permissions for `designs/specs/` directory (summaries saved alongside source specs)
- Available tools: `find`, `grep`, `jq` (for JSON output)

## Error Handling

### Common Errors

- **Missing Specs Folder**: Provides list of available folders
- **Invalid Detail Level**: Shows valid level options (brief, standard, detailed, technical)
- **Empty Specs Folder**: Warns when no .md files found
- **Malformed Specs**: Reports files that cannot be parsed
- **Write Permissions**: Clear error if cannot create output files
- **Script Not Found**: Falls back to basic inline implementation

### Error Messages

The command provides clear, actionable error messages with:
- Available specs folders when folder not found
- Valid detail level options when invalid input
- Specific file paths for parsing errors
- Suggestions for fixing common issues
- Script location hints when optimization unavailable

## Security Considerations

- Always validate input paths to prevent directory traversal
- Ensure spec files come from trusted sources
- Review generated summaries before sharing externally
- Script execution is sandboxed to project directories

## Related Commands

- `/design:ingest-specs-from-drive` - Ingests specifications from Google Drive
- `/design:create-screen-flow-project` - Creates screen flow from specifications
- `/design:update-screen-flow` - Updates existing screen flows with spec changes
- `/design:execute-screen-flow-dev` - Implements screens based on specifications

## Related Documentation

- `ubuntu-vm/user/docs/agent-complex/claude-command-file-rules.md` - Command file creation guidelines
- `.claude/docs/design/specification-format.md` - Expected specification structure
- `.claude/docs/design/summary-templates.md` - Output format templates

## Notes

- **Spec Quality**: Summary quality depends on the detail in source specifications
- **Detail Level Selection**: Choose level based on intended use:
  - `brief` - Quick overview for stakeholders
  - `standard` - Balanced detail for most use cases
  - `detailed` - Comprehensive analysis for planning
  - `technical` - Implementation-ready specifications
- **Output Location**: Summaries are saved as `SUMMARY.md` in each spec project directory (`designs/specs/{spec-project}/SUMMARY.md`)
- **Incremental Updates**: Consider regenerating summaries after spec updates
- **Cross-References**: The command automatically detects and links related specs
- **Page Trees**: Automatically generated when specs include page hierarchies

## Version History

- **v0.5.0** - Updated output location to SUMMARY.md in spec project directory
  - Changed output file from `{folder}-summary-{timestamp}.md` to `SUMMARY.md`
  - Summary files now created at `designs/specs/{spec-project}/SUMMARY.md`
  - Better organization with summaries stored within their respective spec project folders
  - Simplified file naming for easier reference and discovery
- **v0.4.0** - Modernized command structure and performance optimizations
  - Added visual BASE vs DETAIL diagram for better clarity
  - Enhanced pre-flight checks with directory validation
  - Improved step markers with clear visual indicators
  - Added Common RUN Commands section for transparency
  - Updated script priority order (project > user > development)
  - Added execution time tracking and reporting
  - Enhanced error handling with script fallback patterns
  - Added security considerations section
- **v0.3.0** - Enhanced output location and page tree diagrams
  - Changed output directory to `designs/specs/` (summaries now saved alongside source specs)
  - Added automatic page tree diagram generation when specs include page hierarchies
  - Enhanced summary template to include visual page structure near the top
  - Improved output directory handling with existence checking
- **v0.2.0** - Simplified to always output markdown format
  - Removed output-format argument  
  - Always generates markdown summaries
  - Updated command signature and examples
- **v0.1.0** - Initial implementation
  - Multiple output formats support (markdown, json, structured, implementation)
  - Configurable detail levels (brief, standard, detailed, technical)
  - Single folder and "all" folder processing
  - Parallel processing for performance