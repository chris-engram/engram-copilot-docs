# Agent Complex Rules

Best practices for building agent complexes: coordination of Claude Code CLI agents, commands, and documents for sophisticated automation workflows.

## Overview

An **agent complex** refers to the coordinated deployment of Claude Code CLI agents, commands, and documentation working together to achieve sophisticated automation goals. This approach combines the flexibility of AI agents with the reliability of structured commands and the knowledge-sharing power of comprehensive documentation.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Key Concepts](#key-concepts)
- [Agent Complex Architecture](#agent-complex-architecture)
- [Development Workflow](#development-workflow)
- [Agent File Requirements](#agent-file-requirements)
- [Command Integration](#command-integration)
- [Documentation Strategy](#documentation-strategy)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)
- [Testing and Validation](#testing-and-validation)
- [Deployment Guidelines](#deployment-guidelines)
- [References](#references)

## Prerequisites

- Understanding of Claude Code CLI agents and command files
- Familiarity with agent file structure per `ubuntu-vm/user/agent-complex/docs/claude-agent-file-rules.md`
- Knowledge of command file patterns per `ubuntu-vm/user/agent-complex/docs/claude-command-file-rules.md`
- Experience with documentation-driven development

## Key Concepts

### Agent Complex Components

1. **Meta-Command**: Entry point that initiates the agent complex workflow
2. **Agents**: AI entities with specialized expertise and documented knowledge
3. **Commands**: Discrete, reliable tasks that agents can execute
4. **Documentation**: Knowledge base that guides agent behavior and decisions

### Coordination Pattern

```
Meta-Command → Agent(s) → Commands + Free-form Activities
     ↓              ↓              ↓
Documentation ← Knowledge ← Results + Feedback
```

## Agent Complex Architecture

### Typical Deployment Pattern

```
# Development Structure (in repository)
ubuntu-vm/
├── user/                          # User-level components
│   ├── commands/
│   │   └── run-example-workflow.md   # Entry point Claude slash command
│   ├── agents/
│   │   ├── dev/
│   │   │   ├── example-coordinator.md # Primary coordination agent
│   │   │   └── example-analyzer.md   # Specialized analysis agent
│   │   └── agents/
│   │       └── example-executor.md   # Task execution agent
│   └── docs/
│       ├── dev/
│       │   ├── workflow-guide.md     # Process documentation
│       │   └── data-formats.md      # Input/output specifications
│       └── general/
│           └── troubleshooting.md    # Common issues and solutions
└── project/                       # Project-specific components
    ├── supabase/
    │   ├── commands/
    │   │   ├── analyze-input.md      # Claude slash command for analysis
    │   │   ├── process-data.md       # Claude slash command for processing
    │   │   └── generate-output.md    # Claude slash command for output
    │   └── docs/
    │       └── project-guide.md      # Project-specific documentation
    └── ...

# Deployed Structure (runtime access paths)
.claude/                         # User-wide deployment
├── commands/
│   └── run-example-workflow.md
├── agents/
│   ├── dev:example-coordinator.md
│   ├── dev:example-analyzer.md
│   └── agents:example-executor.md
└── docs/
    ├── dev/
    │   ├── workflow-guide.md
    │   └── data-formats.md
    └── general/
        └── troubleshooting.md

.claude/                           # Project-specific deployment
├── commands/
│   ├── supabase:analyze-input.md
│   ├── supabase:process-data.md
│   └── supabase:generate-output.md
└── docs/
    └── project-guide.md
```

### Component Relationships

1. **Entry Point**: Meta-command file that initiates workflow
2. **Orchestration**: Primary agent coordinates the overall process
3. **Specialization**: Additional agents handle specific domains or tasks
4. **Execution**: Commands provide reliable, structured operations
5. **Knowledge**: Documentation guides all decision-making

### Workflow Orchestration

Agent complexes follow a standard orchestration pattern:

1. **Meta-Command Invocation**: User invokes the meta-command
2. **Agent Deployment**: Meta-command deploys appropriate agents
3. **Workflow Coordination**: Agents coordinate with each other
4. **Command Execution**: Agents execute commands as needed
5. **Result Integration**: Outputs are combined and validated

## Development Workflow

### 1. Design Phase

**Planning Agent Complex Architecture**

Before implementation, thoroughly plan the agent complex:

```
1. Define Overall Goal
   - What is the high-level objective?
   - What are the expected inputs and outputs?
   - What are the success criteria?

2. Identify Required Capabilities
   - What domain expertise is needed?
   - What specialized tasks must be performed?
   - What reliable operations are required?

3. Map Component Relationships
   - Which agents need to coordinate with each other?
   - What commands will each agent use?
   - What documentation will guide the agents?

4. Design Workflow Patterns
   - How will work flow between agents?
   - Where are the decision points?
   - What are the error handling strategies?
```

### 2. Implementation Phase

**Building Components**

Implement components in this order:

```
1. Documentation First
   - Create comprehensive guides and standards
   - Define data formats and protocols
   - Document decision-making criteria

2. Commands Next
   - Implement discrete, reliable operations
   - Ensure idempotent execution
   - Provide clear error codes

3. Agents Last
   - Create agents with proper knowledge loading
   - Implement coordination patterns
   - Test agent-to-agent communication

4. Meta-Command Finally
   - Orchestrate the entire workflow
   - Handle high-level error scenarios
   - Provide user-friendly interface
```

### 3. Testing Phase

**Validation Strategy**

Test each level of the complex:

```
1. Unit Testing
   - Test individual commands
   - Validate documentation completeness
   - Verify agent knowledge loading

2. Integration Testing
   - Test agent-to-agent coordination
   - Validate command execution from agents
   - Check documentation usage patterns

3. End-to-End Testing
   - Execute complete workflow via meta-command
   - Test error scenarios and recovery
   - Validate output quality and completeness

4. Performance Testing
   - Measure execution times
   - Identify parallelization opportunities
   - Optimize resource usage
```

## Agent File Requirements

### Essential Patterns

All agents in a complex must follow these patterns:

#### 1. Critical Context Section

Every agent MUST have a "Critical Context" section that loads essential documentation:

```markdown
## Critical Context

Before conducting any tasks, ALWAYS load the following documents into context:

### Required Documentation
- `path/to/essential-doc-1.md` - Core principles and standards
- `path/to/essential-doc-2.md` - Process guidelines
- `path/to/essential-doc-3.md` - Data formats and protocols

**IMPORTANT**: Use the Read tool to load ALL critical documents before beginning any task.
```

#### 2. Available Commands Section

Agents must document available commands they can execute:

```markdown
## Available Claude Slash Commands

| Command File | Arguments | Usage Description | Invocation |
|--------------|-----------|-------------------|------------|
| `command-1.md` | `<arg1> <arg2>` | Purpose and usage | `/topic:command-1` |
| `command-2.md` | `<arg1>` | Purpose and usage | `/topic:command-2` |

### Claude Slash Command Usage Guidelines

- Use command X for Y scenarios
- Execute command Z when conditions W are met
- Always validate inputs before command execution

**Note**: Commands are discovered from `.claude/commands/` (user) or `.claude/commands/` (project).
```

#### 3. Coordination Guidelines

Agents must document how they coordinate with other agents:

```markdown
## Agent Coordination

### Workflow Handoffs

This agent coordinates with:
- `@agent-name-1` for task X
- `@agent-name-2` for validation Y
- `@agent-name-3` for output formatting

### Communication Patterns

1. **Input Processing**: Receive structured input from coordination agent
2. **Specialized Analysis**: Apply domain expertise to the input
3. **Result Generation**: Provide structured output to next agent
4. **Error Handling**: Report issues to coordination agent

### Quality Gates

- Validate all inputs meet expected format
- Verify output completeness before handoff
- Escalate issues that cannot be resolved
```

## Command Integration

### Command Discovery

Agents discover available commands through:

1. **User Commands**: `~/.claude/commands/{topic}/`
2. **Project Commands**: `.claude/commands/{topic}/`

### Command Execution Patterns

#### Standard Execution
```markdown
# Agent executes command directly
The output shows successful execution of the validation process.
```

#### Conditional Execution
```markdown
# Agent uses commands based on context
Based on the current state, I'll execute the deployment verification command.
```

#### Error Handling
```markdown
# Agent responds to command failures
The command execution failed with error code 1. I'll attempt the fallback process.
```

### Command Design for Agent Complex

Commands used in agent complexes should:

1. **Provide Clear Exit Codes**: Enable agents to make decisions based on success/failure
2. **Generate Structured Output**: Use consistent formats that agents can parse
3. **Handle Edge Cases**: Provide graceful degradation for unexpected inputs
4. **Document Dependencies**: Clearly specify what conditions must be met

## Documentation Strategy

### Documentation Types in Agent Complex

#### 1. Architectural Documentation
- **Purpose**: Explain the overall system design
- **Audience**: Other agents and developers
- **Content**: Component relationships, workflow patterns, design decisions

#### 2. Process Documentation
- **Purpose**: Guide step-by-step workflows
- **Audience**: Coordination agents
- **Content**: Procedural steps, decision criteria, validation checkpoints

#### 3. Domain Knowledge
- **Purpose**: Provide specialized expertise
- **Audience**: Domain-specific agents
- **Content**: Standards, best practices, troubleshooting guides

#### 4. Data Specifications
- **Purpose**: Define input/output formats
- **Audience**: All agents in the complex
- **Content**: Schemas, examples, validation rules

### Documentation Loading Patterns

#### Critical Context Loading
```markdown
## Critical Context

Before conducting any tasks, ALWAYS load the following documents into context:

### Required Documentation
- `path/to/workflow-guide.md` - Step-by-step process guidelines
- `path/to/data-formats.md` - Input/output specifications
- `path/to/quality-standards.md` - Validation criteria and best practices

**IMPORTANT**: Use the Read tool to load ALL critical documents before beginning any task.
```

#### Conditional Documentation Loading
```markdown
## Specialized Knowledge Loading

Based on task requirements, load additional documentation:

### For Analysis Tasks
- `path/to/analysis-patterns.md` - Analysis methodologies
- `path/to/data-validation.md` - Data quality standards

### For Generation Tasks  
- `path/to/output-templates.md` - Standard output formats
- `path/to/quality-checklist.md` - Generation quality criteria
```

## Best Practices

### 1. Clear Separation of Concerns

Each component should have a single, well-defined responsibility:

- **Meta-Command**: Workflow orchestration only
- **Coordination Agent**: High-level coordination only
- **Specialized Agents**: Domain-specific tasks only
- **Commands**: Discrete operations only
- **Documentation**: Knowledge sharing only

### 2. Robust Error Handling

Implement comprehensive error handling at every level:

```
1. Command Level
   - Clear error codes and messages
   - Graceful degradation for edge cases
   - Proper input validation

2. Agent Level
   - Error interpretation and response
   - Fallback strategies for common failures
   - Escalation paths for critical issues

3. Complex Level
   - Workflow recovery mechanisms
   - User-friendly error reporting
   - Logging for troubleshooting
```

### 3. Documentation-Driven Development

Always develop documentation before implementation:

```
1. Document the Intent
   - What problem are we solving?
   - What are the constraints and requirements?
   - What are the expected outcomes?

2. Document the Design
   - How will components interact?
   - What are the data flows?
   - Where are the decision points?

3. Document the Implementation
   - How do you execute each step?
   - What are the validation criteria?
   - How do you handle errors?

4. Document the Operations
   - How do you deploy the complex?
   - How do you monitor its performance?
   - How do you troubleshoot issues?
```

### 4. Iterative Development

Build agent complexes incrementally:

```
1. Start Simple
   - Begin with a single agent and basic workflow
   - Validate the core concept works
   - Gather feedback on usability

2. Add Specialization
   - Introduce specialized agents for complex tasks
   - Ensure proper coordination patterns
   - Maintain clear interfaces

3. Optimize Performance
   - Identify parallelization opportunities
   - Reduce unnecessary coordination overhead
   - Implement caching where appropriate

4. Enhance Robustness
   - Add comprehensive error handling
   - Implement monitoring and alerting
   - Create detailed troubleshooting guides
```

### 5. Consistent Naming and Organization

Use consistent patterns across all components:

#### File Naming
- **Meta-Commands**: `run-{purpose}.md`
- **Agents**: `{role}-{specialization}.md`
- **Commands**: `{action}-{object}.md`
- **Documentation**: `{topic}-{type}.md`

#### Directory Structure
```
.claude/
├── commands/           # Entry points
├── agents/            # AI coordination and execution
└── docs/             # Knowledge base
```

#### Agent References
- **User Agents**: `@agent-{topic}:{name}` or `@agent-{name}` (for general topic)
- **Project Agents**: `@agent-{topic}:{name}`

### 6. Performance Optimization

Design for efficiency from the start:

#### Parallel Execution
```markdown
# Execute independent operations in parallel
I'll simultaneously:
- Load the configuration data
- Validate the input parameters
- Check the system status

These operations are independent and can run concurrently.
```

#### Resource Management
```markdown
# Use resources efficiently
I'll process the data in batches to manage memory usage effectively.
```

#### Caching Strategies
```markdown
# Cache expensive operations
I'll cache the validation results to avoid re-processing identical inputs.
```

## Common Patterns

### 1. Analysis-Process-Generate Pattern

```
Meta-Command → Analyzer Agent → Processor Agent → Generator Agent
                    ↓                ↓               ↓
              Analysis Docs → Processing Docs → Output Docs
```

**Use Cases**:
- Data transformation workflows
- Content generation pipelines
- Report creation systems

**Implementation**:
- Analyzer agent extracts and validates input
- Processor agent transforms data according to rules
- Generator agent creates final output in specified format

### 2. Coordinator-Worker Pattern

```
Meta-Command → Coordinator Agent → Multiple Worker Agents
                     ↓                     ↓
               Coordination Docs → Specialized Worker Docs
```

**Use Cases**:
- Parallel processing workflows
- Multi-domain analysis tasks
- Distributed validation processes

**Implementation**:
- Coordinator agent manages overall workflow
- Worker agents handle specialized tasks in parallel
- Results are aggregated by coordinator

### 3. Pipeline Processing Pattern

```
Meta-Command → Stage 1 Agent → Stage 2 Agent → Stage 3 Agent
                    ↓              ↓              ↓
                Stage Docs → Validation → Final Output
```

**Use Cases**:
- Sequential processing workflows
- Quality assurance pipelines
- Approval and review processes

**Implementation**:
- Each stage validates previous stage output
- Progressive refinement of results
- Quality gates at each transition

### 4. Expert Consultation Pattern

```
Meta-Command → Generalist Agent → Domain Expert 1
                     ↓              Domain Expert 2
                Coordination       Domain Expert N
                    ↓                     ↓
              General Docs → Specialized Expert Docs
```

**Use Cases**:
- Complex decision-making scenarios
- Multi-domain evaluation tasks
- Technical review processes

**Implementation**:
- Generalist agent coordinates overall process
- Domain experts provide specialized analysis
- Final decision based on integrated expert input

## Testing and Validation

### Unit Testing

Test individual components:

#### Commands
```bash
# Test command execution
/topic:command arg1 arg2

# Verify expected outputs
# Check error handling
# Validate edge cases
```

#### Agents
```markdown
# Test agent knowledge loading
@agent-name should load required documentation

# Test agent command execution
Agent should successfully execute available commands

# Test agent coordination
Agent should properly handoff to other agents
```

#### Documentation
```markdown
# Test documentation completeness
All required sections present
All examples work as described
All references are valid

# Test documentation utility
Agents can successfully use the documentation
Documentation answers common questions
Documentation provides clear guidance
```

### Integration Testing

Test component interactions:

#### Agent-to-Agent Coordination
```markdown
# Test workflow handoffs
Agent A → Agent B → Agent C
Verify data flows correctly
Validate error propagation
Check result integration
```

#### Agent-to-Command Integration
```markdown
# Test command discovery
Agent finds available commands
Agent executes commands correctly
Agent handles command failures appropriately
```

#### Documentation Usage
```markdown
# Test documentation loading
Agents load required documentation
Documentation influences agent behavior
Documentation helps with decision making
```

### End-to-End Testing

Test complete workflows:

#### Workflow Execution
```bash
# Execute via meta-command
/run-workflow-name

# Verify complete execution
# Check all stages complete successfully
# Validate final outputs
# Test error scenarios
```

#### Performance Testing
```markdown
# Measure execution time
Record baseline performance
Identify bottlenecks
Test optimization improvements

# Test resource usage
Monitor memory consumption
Track tool call efficiency
Measure documentation loading time
```

#### Stress Testing
```markdown
# Test with edge cases
Maximum input size
Minimum input size
Invalid inputs
Missing dependencies

# Test error recovery
Partial failures
Network interruptions
Resource constraints
```

## Deployment Guidelines

### Pre-Deployment Checklist

Before deploying an agent complex:

#### Component Validation
- [ ] All agents have Critical Context sections
- [ ] All agents have Available Commands sections
- [ ] All commands exist and are executable
- [ ] All documentation is complete and accurate
- [ ] All file references use correct paths

#### Integration Validation
- [ ] Agent coordination patterns are tested
- [ ] Command execution from agents works
- [ ] Documentation loading is successful
- [ ] Error handling is comprehensive
- [ ] Performance is acceptable

#### User Experience Validation
- [ ] Meta-command provides clear interface
- [ ] Error messages are helpful
- [ ] Output format is useful
- [ ] Documentation is accessible
- [ ] Troubleshooting guides are available

### Deployment Process

#### 1. Component Deployment
```bash
# Deploy agents to appropriate directories
# User agents: ~/.claude/agents/
# Project agents: .claude/agents/

# Deploy commands to appropriate directories  
# User commands: ~/.claude/commands/
# Project commands: .claude/commands/

# Deploy documentation to appropriate directories
# User docs: ~/.claude/docs/
# Project docs: .claude/docs/
```

#### 2. Validation Testing
```bash
# Test meta-command execution
/topic:run-workflow-name

# Verify agent deployment
@agent-name should be discoverable

# Test command availability
/topic:command-name should execute

# Validate documentation access
Documentation should be readable
```

#### 3. User Training
```markdown
# Provide usage documentation
How to invoke the meta-command
What inputs are expected
How to interpret outputs
Common troubleshooting steps

# Create examples
Typical use cases
Expected workflows  
Sample inputs and outputs
Error scenarios and solutions
```

### Post-Deployment Monitoring

#### Performance Monitoring
```markdown
# Track key metrics
Execution time per workflow
Success/failure rates
Resource consumption
User satisfaction

# Identify optimization opportunities
Bottlenecks in workflow
Frequently failing components
Under-utilized resources
User pain points
```

#### Quality Monitoring
```markdown
# Monitor output quality
Accuracy of results
Completeness of outputs
User acceptance rates
Error frequencies

# Track improvement opportunities
Common user questions
Frequently requested features
Documentation gaps
Process inefficiencies
```

## References

### Core Documentation
- `claude-agent-file-rules.md` - Agent file structure and requirements
- `claude-command-file-rules.md` - Command file patterns and best practices
- `meta-command-template.md` - Template for meta-command files
- `regular-command-template.md` - Template for regular command files

### Best Practices
- Start with simple, single-agent workflows
- Build documentation before implementation
- Test integration points thoroughly
- Optimize for performance early
- Plan for error scenarios
- Design for maintainability

### Common Pitfalls
- Skipping documentation development
- Insufficient error handling
- Poor agent coordination design
- Neglecting performance optimization
- Inadequate testing coverage
- Unclear component responsibilities

The agent complex pattern represents a powerful approach to building sophisticated automation workflows that combine the flexibility of AI agents with the reliability of structured processes and the knowledge-sharing power of comprehensive documentation. By following these guidelines, you can create robust, maintainable, and effective agent complexes that solve real-world problems.