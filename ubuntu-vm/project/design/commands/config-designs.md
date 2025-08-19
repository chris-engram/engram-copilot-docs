# Args: none. v1.3.0. Creates the basic designs folder structure for the Figma Make project, including README navigation files and assets directory.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/config-designs` in bash.

## Summary

Sets up the foundational designs folder structure for organizing design documentation and assets. Creates `designs/` directory with subdirectories for `prototypes/`, `screenflows/`, and `assets/`, each with their own README files that serve as navigation and documentation. The main `designs/README.md` acts as the central index for all design-related content. This command focuses solely on creating the folder structure without any git operations.

## Usage

```bash
/design:config-designs
```

## Arguments

None - This command creates a standard folder structure with no configuration options.

## Examples

```bash
# Create the basic designs folder structure
/design:config-designs

# After running, the structure will be:
# designs/
# ├── README.md              # Main navigation index
# ├── assets/
# │   └── README.md          # Design assets documentation
# ├── prototypes/
# │   └── README.md          # Prototypes documentation
# └── screenflows/
#     └── README.md          # Screen flows documentation
```

## What This Command Does

### 🚀 Workflow Overview

1. **Sets Up Folder Structure**: Creates the designs directory hierarchy
2. **Generates Documentation**: Creates README files with navigation and purpose

### Directory Structure Created

```
designs/                    # Root design documentation folder
├── README.md              # Main navigation and index file
├── assets/                # Design assets (icons, images, etc.)
│   └── README.md         # Documentation for assets
├── prototypes/            # Figma prototypes and mockups
│   └── README.md         # Documentation for prototypes
└── screenflows/           # User flow and navigation diagrams
    └── README.md         # Documentation for screen flows
```

### README Contents

#### Main designs/README.md
- Overview of the designs directory
- Navigation links to subdirectories
- Table of contents for easy access
- Guidelines for adding new design content

#### prototypes/README.md
- Purpose: Store Figma prototypes and mockups
- Organization guidelines
- Naming conventions
- Version control best practices

#### screenflows/README.md
- Purpose: Document user flows and navigation patterns
- Integration with update-screenflows command
- Organization by feature or user journey

#### assets/README.md
- Purpose: Store design assets and resources
- Organization guidelines for icons, images, fonts
- Export formats and optimization rules
- Version control for design assets

## Implementation

```bash
#!/bin/bash
set -euo pipefail

# 🔍 Step 1: Check if designs directory exists
if [[ -d "designs" ]]; then
    echo "📁 designs/ directory already exists"
else
    echo "📁 Creating designs/ directory..."
    mkdir -p designs
fi

# 📂 Step 2: Create subdirectories
echo "📂 Setting up subdirectories..."
mkdir -p designs/assets
mkdir -p designs/prototypes
mkdir -p designs/screenflows

# 📝 Step 3: Create main designs/README.md
echo "📝 Creating main designs/README.md..."
cat > designs/README.md << 'EOF'
# Designs

This directory contains all design-related documentation, prototypes, and screen flows for the Figma Make project.

## Overview

The designs directory is organized to support the full design-to-code workflow, from initial prototypes to detailed screen flows that can be converted into React components.

## Directory Structure

```
designs/
├── README.md              # This file - main navigation
├── assets/                # Design assets and resources
│   └── README.md         # Assets documentation
├── prototypes/            # Figma prototypes and mockups
│   └── README.md         # Prototypes documentation
└── screenflows/           # User flow and navigation diagrams
    └── README.md         # Screen flows documentation
```

## Navigation

### 🎨 [Assets](./assets/README.md)
Store and organize design assets including icons, images, fonts, and other resources.

### 📐 [Prototypes](./prototypes/README.md)
Store and organize Figma prototypes, mockups, and design iterations.

### 🔄 [Screen Flows](./screenflows/README.md)
Document user journeys, navigation patterns, and application flow diagrams.

## Adding New Content

### For Prototypes
1. Export your Figma designs to the `prototypes/` directory
2. Create a subdirectory for each major feature or version
3. Include a README in each subdirectory explaining the designs
4. Use descriptive filenames (e.g., `dashboard-v2-dark-mode.fig`)

### For Screen Flows
1. Use the `/design:update-screenflows` command to generate flow diagrams
2. Each flow gets its own subdirectory in `screenflows/`
3. Include Mermaid diagrams and documentation
4. Link flows back to relevant prototypes

For alternative approaches to screen flow documentation, see:
- [Screenflows Storyboarding](../docs/screenflows-storyboarding.md) - HTML-based storyboarding
- [Screenflows Wireframes](../docs/screenflows-wireframes.md) - HTML wireframing best practices

## Best Practices

1. **Version Control**: Use meaningful commit messages when adding designs
2. **Organization**: Group related designs in subdirectories
3. **Documentation**: Always include README files explaining the context
4. **Naming**: Use kebab-case for directories and files
5. **Updates**: Keep this index updated when adding new sections

## Integration with Figma Make

This directory structure supports the Figma Make workflow:
- Prototypes can be processed with `extract-layout-description`
- Screen flows guide the `insert-design-code` implementation
- Design tokens and assets can be organized here for reference

## Related Commands

- `/design:update-screenflows` - Generate screen flow diagrams
- `/design:extract-layout-description` - Process Figma exports
- `/design:insert-design-code` - Convert designs to React code

---
*Last Updated: $(date +%Y-%m-%d)*
EOF

# 📝 Step 4: Create prototypes/README.md
echo "📝 Creating prototypes/README.md..."
cat > designs/prototypes/README.md << 'EOF'
# Prototypes

This directory stores Figma prototypes, mockups, and design iterations for the project.

## Purpose

The prototypes directory serves as the central repository for all design files that will be converted into code. It provides:
- Version control for design iterations
- Easy access for developers implementing designs
- Documentation of design decisions
- Archive of design evolution

## Organization

```
prototypes/
├── README.md              # This file
├── feature-name/          # Feature-specific designs
│   ├── README.md         # Feature documentation
│   ├── v1/               # Version 1 designs
│   └── v2/               # Version 2 designs
└── components/            # Reusable component designs
    ├── buttons/
    ├── forms/
    └── navigation/
```

## File Naming Conventions

- Use kebab-case for all files and directories
- Include version numbers: `dashboard-v2.fig`
- Add context modifiers: `dashboard-v2-dark-mode.fig`
- Date exports: `dashboard-v2-2024-01-15.fig`

## Adding New Prototypes

1. Create a feature directory if it doesn't exist
2. Export your Figma file to the appropriate location
3. Add a README explaining:
   - Design goals
   - Key components
   - Interaction patterns
   - Implementation notes

## Example Structure

```
prototypes/
├── user-dashboard/
│   ├── README.md
│   ├── dashboard-v1.fig
│   ├── dashboard-v2.fig
│   └── dashboard-v2-responsive.fig
├── onboarding/
│   ├── README.md
│   ├── welcome-flow.fig
│   └── profile-setup.fig
└── components/
    ├── buttons/
    │   ├── primary-button.fig
    │   └── icon-buttons.fig
    └── forms/
        ├── input-fields.fig
        └── form-validation.fig
```

## Integration with Development

These prototypes are used with:
- `/design:extract-layout-description` - Extract component structure
- `/design:insert-design-code` - Generate React components
- Screen flows for navigation planning

## Best Practices

1. **Keep Files Small**: Export individual features rather than entire apps
2. **Document Changes**: Use git commits to track design evolution
3. **Clean Exports**: Remove unnecessary layers before exporting
4. **Consistent Naming**: Follow the naming conventions strictly
5. **Archive Old Versions**: Keep previous versions for reference

---
*Last Updated: $(date +%Y-%m-%d)*
EOF

# 📝 Step 5: Create assets/README.md
echo "📝 Creating assets/README.md..."
cat > designs/assets/README.md << 'EOF'
# Assets

This directory stores design assets and resources used throughout the Figma Make project.

## Purpose

The assets directory centralizes all design resources needed for implementation:
- Icons and iconography systems
- Images and illustrations
- Fonts and typography files
- Color palettes and design tokens
- Logos and brand assets
- SVG graphics and vector files

## Organization

```
assets/
├── README.md              # This file
├── icons/                 # Icon files and icon systems
│   ├── svg/              # SVG icon files
│   ├── png/              # PNG icon exports
│   └── README.md         # Icon usage guidelines
├── images/                # Images and illustrations
│   ├── hero/             # Hero images
│   ├── backgrounds/      # Background images
│   └── illustrations/    # Custom illustrations
├── fonts/                 # Font files (if custom)
│   └── README.md         # Typography guidelines
└── tokens/                # Design tokens
    ├── colors.json       # Color palette
    ├── spacing.json      # Spacing system
    └── typography.json   # Typography scales
```

## File Formats

### Icons
- **Primary**: SVG for scalability
- **Fallback**: PNG at 1x, 2x, 3x resolutions
- **Naming**: `icon-name-variant.svg` (e.g., `arrow-left-bold.svg`)

### Images
- **Web**: WebP with PNG/JPEG fallbacks
- **Optimization**: Compressed and responsive sizes
- **Naming**: `context-description-size.ext` (e.g., `hero-dashboard-1920w.webp`)

### Design Tokens
- **Format**: JSON for easy integration
- **Structure**: Follows design system conventions
- **Usage**: Import directly into stylesheets or components

## Best Practices

1. **Optimization First**
   - Compress all images before committing
   - Use appropriate formats (SVG for icons, WebP for photos)
   - Generate multiple sizes for responsive images

2. **Consistent Naming**
   - Use kebab-case for all files
   - Include context in filenames
   - Version assets when updating (e.g., `logo-v2.svg`)

3. **Documentation**
   - Document color codes and usage
   - Include attribution for external assets
   - Note licensing information

4. **Version Control**
   - Use Git LFS for large binary files
   - Keep source files when possible
   - Document asset sources in commit messages

## Integration with Figma

### Exporting from Figma
1. Use Figma's export settings for optimal quality
2. Export at multiple resolutions for responsive design
3. Maintain consistent naming between Figma and exports

### Asset Pipeline
1. Export from Figma to appropriate format
2. Optimize using tools like ImageOptim or SVGO
3. Place in correct directory structure
4. Update relevant documentation

## Usage in Code

### Importing Icons
```jsx
import ArrowLeft from '@/designs/assets/icons/svg/arrow-left.svg';
```

### Using Images
```jsx
import heroImage from '@/designs/assets/images/hero/dashboard-hero.webp';
```

### Design Tokens
```javascript
import { colors } from '@/designs/assets/tokens/colors.json';
```

## Maintenance

- Regularly audit for unused assets
- Keep file sizes optimized
- Update documentation when adding new assets
- Use consistent export settings from design tools

---
*Last Updated: $(date +%Y-%m-%d)*
EOF

# 📝 Step 6: Create screenflows/README.md
echo "📝 Creating screenflows/README.md..."
cat > designs/screenflows/README.md << 'EOF'
# Screen Flows

This directory contains user flow diagrams, navigation patterns, and screen relationship documentation.

## Purpose

Screen flows document how users navigate through the application and how different screens connect. They serve as:
- Blueprint for navigation implementation
- Reference for user journey planning
- Documentation for QA testing paths
- Guide for accessibility improvements

## Organization

Screen flows are organized by feature or user journey. Each screen flow created with the `/design:update-screenflows` command will have its own subdirectory here.

## Creating Screen Flows

Use the `/design:update-screenflows` command to generate screen flows. See that command's documentation for detailed usage.

### Alternative Documentation Approaches

In addition to Mermaid-based flow diagrams, consider these comprehensive documentation methods:
- [Screenflows Storyboarding](../docs/screenflows-storyboarding.md) - Visualize entire applications in a single HTML document
- [Screenflows Wireframes](../docs/screenflows-wireframes.md) - Create rapid HTML wireframes for quick iteration

## Integration with Prototypes

Screen flows should correspond to prototypes in the `../prototypes/` directory:
- Each prototype should have a matching screen flow
- Flows document the connections between prototype screens
- Use consistent naming between prototypes and flows

---
*Last Updated: $(date +%Y-%m-%d)*
EOF

# 📊 Step 7: Display created structure
echo -e "\n✅ Designs folder structure created successfully!"
echo "📂 Directory structure:"
tree designs/ 2>/dev/null || {
    echo "designs/"
    echo "├── README.md"
    echo "├── assets/"
    echo "│   └── README.md"
    echo "├── prototypes/"
    echo "│   └── README.md"
    echo "└── screenflows/"
    echo "    └── README.md"
}

echo -e "\n🎉 Designs folder structure setup complete!"
echo ""
echo "📌 Next Steps:"
echo "  1. Add your Figma prototypes to designs/prototypes/"
echo "  2. Export design assets to designs/assets/"
echo "  3. Use /design:update-screenflows to create flow diagrams"
echo "  4. Review the README files for organization guidelines"
```

## Script Integration

This command can benefit from script-based execution for:
- Atomic directory creation with proper permissions
- Template generation with consistent formatting
- Validation of existing structures
- Batch file creation operations

### Future Script Enhancement
```bash
# Script location when implemented
SCRIPT_PATH=".claude/scripts/design/config-designs_setup.sh"

# Would provide:
# - Parallel directory creation
# - Template caching
# - Atomic file operations
# - Rollback on failure
```

## Requirements

- Write permissions to create directories
- Bash shell environment

## Error Handling

- **Existing Directory**: Checks if designs/ exists and reports status
- **Permission Issues**: Reports filesystem permission errors
- **File Creation**: Handles write failures gracefully

## Notes

- **Idempotent**: Can be run multiple times safely
- **No Git Operations**: Focuses only on directory and file creation
- **No Arguments**: Standardized structure with no configuration
- **Documentation**: Creates comprehensive README files
- **Integration**: Sets up structure for update-screenflows command
- **Local Only**: All operations are performed locally without remote interaction

## Version History

- **v1.3.0** - Updated documentation references
  - Updated command references from `update-screen-flow` to `update-screenflows`
  - Added references to screenflows documentation (screenflows-storyboarding.md, screenflows-wireframes.md)
  - Enhanced screen-flows README with alternative documentation approaches
  - Provided links to HTML-based storyboarding and wireframing methods
  - Aligned with the unified update-screenflows command
- **v1.2.0** - Removed git operations
  - Removed all git operations (feature branch, commits, PR creation)
  - Simplified to focus only on folder structure creation
  - Updated documentation to reflect local-only operation
  - Removed GitHub CLI requirement
  - Streamlined error handling for file operations only
- **v1.1.0** - Added assets directory
  - Added designs/assets/ folder for design resources
  - Created comprehensive assets/README.md with organization guidelines
  - Documented asset formats, naming conventions, and integration
  - Enhanced main README navigation to include assets section
  - Updated directory structure documentation
- **v1.0.0** - Initial release
  - Creates designs/ folder structure
  - Implements full git workflow with feature branch
  - Generates comprehensive README documentation
  - Integrates with Figma Make command ecosystem
  - Follows repository command patterns