# Args: `<spec-project>`. v1.1.0. Generate a Figma Make prompt from design specifications to create frontend builds with design philosophy integration

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/create-prompt` in bash.

## Summary

Generates optimized prompts for Figma Make to create high-quality frontend builds from design specifications. Takes a specification project path and creates a structured markdown prompt file that follows Figma Make best practices for AI-powered code generation. The command analyzes the design specifications and creates a comprehensive prompt that includes design philosophy, tech stack requirements, behavioral specifications, and detailed references to design components. The prompt now integrates emotional design principles and brand philosophy from project documentation to ensure generated code aligns with the intended user experience.

**Purpose**: Streamline the process of converting design specifications into effective Figma Make prompts that generate production-ready frontend code with minimal iteration while maintaining alignment with design philosophy and emotional goals.

## Command Execution

This command processes design specification folders and generates structured prompts for Figma Make AI code generation, following research-backed best practices for optimal results.

## Usage

```bash
/design:create-prompt <spec-project>
```

## Arguments

- `<spec-project>`: Path to specification folder containing design specs (REQUIRED)
  - Format: Path relative to current directory or absolute path
  - Examples: 
    - `designs/specs/RevsUp Key Pages for Completing Human Tasks`
    - `designs/specs/Dashboard Components`
    - `designs/specs/Mobile App Login Flow`
  - Must contain design files, images, or specification documents
  - The prompt file will be created at: `designs/specs/{spec-project}/figma-make-prompt.md`

## Examples

```bash
# Generate prompt for RevsUp project specifications
/design:create-prompt "designs/specs/RevsUp Key Pages for Completing Human Tasks"
# Creates: designs/specs/RevsUp Key Pages for Completing Human Tasks/figma-make-prompt.md

# Generate prompt for dashboard components
/design:create-prompt "designs/specs/Dashboard Components"
# Creates: designs/specs/Dashboard Components/figma-make-prompt.md

# Generate prompt for mobile login flow
/design:create-prompt "designs/specs/Mobile App Login Flow" 
# Creates: designs/specs/Mobile App Login Flow/figma-make-prompt.md
```

## What This Command Does

### 1. Analyze Specification Folder and Design Philosophy
- Scans the provided spec-project directory for design files
- Identifies images, Figma files, and specification documents
- Checks for design philosophy documentation (PHILOSOPHY.md or similar)
- Extracts emotional goals, core principles, and brand feeling from available documentation
- Catalogs components, layouts, and design system elements
- Determines project scope and complexity aligned with design intention

### 2. Generate Structured Prompt
Creates a comprehensive Figma Make prompt following best practices:

#### **Prompt Structure Components:**
- **Design Philosophy**: Emotional goals and design principles guiding the build
- **Project Overview**: Clear description of what needs to be built
- **Tech Stack Specification**: Explicit framework and tool requirements
- **Design References**: Detailed references to attached files and components
- **Component Breakdown**: Section-by-section build instructions
- **Behavioral Requirements**: Interactive elements and functionality specs
- **Quality Standards**: Accessibility, responsiveness, and code quality requirements

#### **Research-Based Best Practices Applied:**
- **Explicit Instructions**: Clear, focused prompts with specific tech stack requirements
- **Section Organization**: Breaking complex interfaces into manageable sections
- **1:1 Build Specifications**: Precise recreation requirements vs. inspiration guidance
- **Component References**: Direct citations of design system elements
- **Iterative Structure**: Organized for step-by-step refinement

### 3. Create Optimized Prompt File
- Generates `figma-make-prompt.md` in the specification folder
- Includes template sections for easy customization
- Provides specific instructions for attaching design files
- Contains example refinement prompts for iteration

### 4. Include Template Sections

#### **Generated Prompt Template:**
```markdown
# Figma Make Build Prompt: [Project Name]

## Design Philosophy
[Summarize the emotional intention and design principles from designs/PHILOSOPHY.md or project documentation]
- **Emotional Goals**: [e.g., Trust, delight, calm, excitement]
- **Core Principles**: [e.g., Minimalism, accessibility, user-centricity]
- **Brand Feeling**: [e.g., Professional, playful, innovative]
- **Visual Language**: [e.g., Clean lines, organic shapes, bold typography]

## Build Overview
Generate a [tech stack] application based on the attached design specifications. Build a 1:1 visual match with the following requirements:

## Tech Stack Requirements
- Framework: [React/Next.js/Vue/etc.]
- Styling: [Tailwind CSS/styled-components/CSS modules]
- Additional libraries: [specific requirements]

## Design References
Reference the following attached files:
- [List of design files]
- [Component references]
- [Design system elements]

## Component Breakdown

### Header Section
[Specific instructions for header build]

### Main Content Area
[Detailed requirements for main content]

### Interactive Elements
[Behavioral specifications]

## Quality Requirements
- Responsive design for mobile, tablet, desktop
- Semantic HTML structure
- Accessibility compliance (ARIA labels, proper contrast)
- Form validation as specified
- Loading states and error handling

## Iteration Prompts
Use these follow-up prompts if refinement is needed:
- "Please match the button colors exactly to the attached design"
- "Regenerate with correct mobile breakpoints at 768px and 1024px"
- "Add proper loading spinners to form submission buttons"
```

### 5. Performance Optimization Opportunities

This command could be enhanced with scripts for:
- **Design File Analysis**: Automated scanning of image metadata and design tokens
- **Component Detection**: AI-powered identification of reusable components
- **Tech Stack Detection**: Analysis of existing project structure to suggest optimal tech stack
- **Prompt Validation**: Quality checks for prompt completeness and clarity

**Script Integration Pattern:**
```bash
# Future script locations:
# .claude/scripts/design/create-prompt_analyzer.sh
# .claude/scripts/design/create-prompt_validator.sh
```

## Output

Creates a comprehensive prompt file at:
```
designs/specs/{spec-project}/figma-make-prompt.md
```

The generated prompt includes:
- ✅ Structured build instructions
- ✅ Tech stack specifications
- ✅ Design file references
- ✅ Component breakdown
- ✅ Quality requirements
- ✅ Iteration guidance
- ✅ Best practice patterns

## Figma Make Best Practices Integration

### Research-Backed Prompt Patterns

Based on current Figma Make best practices research:

#### **1. Explicit Framework Specification**
```markdown
Generate a responsive Next.js page using Tailwind CSS based on the attached Figma frame.
```

#### **2. Attachment Reference Strategy**
```markdown
Build a 1:1 match for the attached design files:
- Main Layout: [filename]
- Component Library: [filename]
- Mobile Variants: [filename]
```

#### **3. Section-by-Section Instructions**
```markdown
### Header Section
- Logo left-aligned as shown in 'Header/Desktop' frame
- Navigation collapses on mobile (<768px)
- Search functionality as specified in interactions

### Main Content
- Use 'Card/Primary' component pattern for content blocks
- Maintain 24px spacing between elements
- Follow grid system from design tokens
```

#### **4. Behavioral Specifications**
```markdown
### Interactive Elements
- All buttons use 'Button/Primary' component from design system
- Form validation messages appear below inputs
- Loading spinner on form submission
- Hover states match design specifications
```

#### **5. Quality Standards**
```markdown
### Technical Requirements
- Semantic HTML structure
- ARIA labels for accessibility
- Mobile-first responsive design
- Form validation and error handling
- Performance optimization for images
```

## Requirements

- **Design Specifications**: Spec folder must contain design files or documentation
- **Directory Structure**: Must be run from project root or specify full path
- **File System Access**: Write permissions to create prompt file in spec directory

## Error Handling

### Common Issues and Solutions

#### **Spec Folder Not Found**
```
❌ Error: Specification folder not found: designs/specs/[path]
📋 Solution: Verify the path exists and contains design specifications
```

#### **No Design Files Detected**
```
❌ Error: No design files found in specification folder
📋 Solution: Ensure folder contains images, Figma files, or spec documents
```

#### **Write Permission Denied**
```
❌ Error: Cannot create prompt file in target directory
📋 Solution: Check write permissions for the specification folder
```

#### **Invalid Path Format**
```
❌ Error: Invalid specification path format
📋 Solution: Use relative path from current directory or absolute path
Examples:
- designs/specs/ProjectName
- /full/path/to/designs/specs/ProjectName
```

## Best Practices for Generated Prompts

### **Effective Prompt Characteristics**
1. **Specific Tech Stack**: Always specify exact frameworks and libraries
2. **Clear Build Intent**: State whether 1:1 recreation or style inspiration
3. **Component References**: Cite specific design system elements by name
4. **Behavioral Detail**: Explicit interactivity and functionality requirements
5. **Quality Standards**: Accessibility, responsiveness, and performance requirements

### **Iteration Strategy**
1. **Start Broad**: Initial prompt covers overall structure and key components
2. **Refine Specific**: Follow-up prompts address specific styling or behavioral issues
3. **Validate Results**: Test generated code against design specifications
4. **Document Changes**: Track successful prompt refinements for future use

## Advanced Usage

### **Design System Integration**
When working with established design systems:
```markdown
Apply the 'DesignSystem-2024' tokens for:
- Colors: Use semantic color names (primary, secondary, accent)
- Typography: Apply text styles (heading-1, body-regular, caption)
- Spacing: Use 8px grid system (space-2, space-4, space-6)
- Components: Reference 'Button/Primary', 'Card/Default', 'Input/Text'
```

### **Multi-Screen Projects**
For complex applications:
```markdown
Build the following screens in sequence:
1. Landing Page (attached: landing-desktop.png, landing-mobile.png)
2. Dashboard (attached: dashboard-main.fig)
3. Settings Panel (attached: settings-component.png)

Each screen should maintain design system consistency and shared component library.
```

## Notes

- **File Location**: Prompts are created within the specification folder for easy reference
- **Customization**: Generated prompts serve as templates - customize based on specific project needs
- **Best Practice Research**: Based on current Figma Make documentation and community best practices
- **Iteration Support**: Includes follow-up prompt suggestions for common refinement needs
- **Quality Focus**: Emphasizes accessibility, performance, and maintainable code generation

## Version History

- **v1.1.0** - Added design philosophy integration
  - Design philosophy section now included at the top of generated prompts
  - Extracts emotional goals, core principles, and brand feeling from project documentation
  - Analyzes PHILOSOPHY.md or similar design intention documentation
  - Ensures generated code aligns with intended user experience and emotional design goals
  - References design-philosophy-best-practices.md for comprehensive guidance
- **v1.0.0** - Initial version with comprehensive prompt generation
  - Research-backed best practices integration
  - Structured template generation with all essential sections
  - Quality standards and accessibility requirements
  - Component breakdown and behavioral specifications
  - Iteration guidance for prompt refinement
  - Error handling for common specification folder issues