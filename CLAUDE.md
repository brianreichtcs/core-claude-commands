# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository is a Claude Code marketplace that hosts the **core-claude-plugin**, providing reusable automation tools (commands, agents, and configurations) for the CORE Software Team. It leverages Claude Code's native plugin marketplace system to deliver standardized automation for code remediation, security scanning, code review, and development workflows across multiple projects.

## Key Commands

## How It Works

1. **Development**: Commands and agents are developed and tested in the `core-claude-plugin/` directory
2. **Marketplace Manifest**: The `marketplace.json` file defines the marketplace and references available plugins
3. **Plugin Manifest**: The `core-claude-plugin/.claude-plugin/plugin.json` file defines the plugin metadata and configuration
4. **Installation**: Add the marketplace and install plugins using Claude Code's marketplace system
5. **Auto-Discovery**: Claude Code automatically discovers commands in the `core-claude-plugin/commands/` directory and agents in the `core-claude-plugin/agents/` directory
6. **Usage**: Once installed, commands and agents become available in any project
7. **Updates**: Update the marketplace and plugins to receive new/updated commands and agents

### Installation

To install plugins from this marketplace in your Claude Code environment:

**Method 1: From Repository Directory** (recommended)
```bash
git clone <repository-url>
cd core-claude-commands

# In Claude Code, add the marketplace
/plugin marketplace add .

# Install the plugin
/plugin install core-claude-plugin@core-marketplace
```

**Method 2:From Git 
```bash
# Add marketplace from path
/plugin marketplace add brianreichtcs/core-claude-commands

# Install the plugin
/plugin install core-claude-plugin@core-marketplace
```

Once installed, Claude Code automatically discovers all commands and agents from the plugin, making them globally available across all your projects.

For more details on marketplace installation and management, see the [Claude Code Plugin Marketplaces Documentation](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces).

### Common Development Tasks

**Security Remediation:**
- `/remediate-sql-injection <file>` - Fix SQL injection vulnerabilities using prepared statements
- `/remediate-command-injection <file>` - Replace unsafe command execution with SecureCommand
- `/add-input-validation <file>` - Add input validation to legacy scripts
- `/add-realm-validation <file>` - Add realm-specific validation

**Code Quality:**
- `/review` - Conduct self-review of branch changes using team standards
- `/review-pr` - Perform PR review with focus on common issues
- `/write-qa-test-plan` - Generate test plan based on branch changes
- `/run-linters` - Execute project linting and quality tools

**Documentation:**
- `/add-file-level-docblock <file>` - Add comprehensive file-level documentation
- `/document-perl-script <file>` - Document Perl scripts with proper docblocks

**Legacy Code Modernization:**
- `/factor-out-dbquery3 <file>` - Replace DBquery3() with mysqli::prepare()
- `/jsonify-legacy-output <file>` - Convert string-building to json_encode()
- `/auto-remediate <file>` - Comprehensive remediation (SQL, command injection, validation, documentation)

## Architecture

### Directory Structure
```
core-claude-commands/             # Marketplace repository
├── marketplace.json              # Marketplace manifest
│
└── core-claude-plugin/           # Plugin directory
    ├── .claude-plugin/
    │   ├── plugin.json           # Plugin manifest with metadata
    │   └── README.md             # Plugin documentation
    │
    ├── agents/                   # Specialized AI agents for specific tasks
    │   ├── cicd-engineer.md
    │   ├── code-review-mentor.md
    │   ├── performance-optimizer.md
    │   ├── security-auditor.md
    │   ├── junior-developer-mentor.md
    │   ├── iso-27001-auditor.md
    │   └── ...
    │
    └── commands/                 # Claude Code command definitions
        ├── legacy/               # PHP legacy code commands
        ├── perl/                 # Perl-specific commands
        ├── processes/            # Multi-step workflow commands
        ├── quality/              # Code quality commands
        └── security/             # Security remediation commands
```

### Command Structure
Commands are defined as markdown files with:
- Clear task descriptions
- Step-by-step instructions
- Variable definitions for file paths
- Integration with project quality tools

### Agent System
Specialized agents provide focused expertise:
- **code-review-mentor**: Reviews code with educational feedback
- **cicd-engineer**: Handles CI/CD pipeline and deployment tasks
- **performance-optimizer**: Analyzes and optimizes performance issues
- **security-auditor**: Identifies and remediates security vulnerabilities
- **junior-developer-mentor**: Provides guidance for less experienced developers
- **iso-27001-auditor**: Audits compliance with ISO 27001 standards

### Marketplace Manifest
The `marketplace.json` file at the repository root defines:
- **name**: Unique identifier for the marketplace (`core-marketplace`)
- **owner**: Marketplace owner information
- **plugins**: Array of available plugins with their sources

### Plugin Manifest
The `core-claude-plugin/.claude-plugin/plugin.json` file defines the plugin's metadata:
- **name**: Unique identifier for the plugin (`core-claude-plugin`)
- **description**: Brief description of plugin functionality
- **version**: Semantic version number (follow semver.org conventions)
- **author**: Plugin maintainer information

Claude Code automatically discovers:
- Commands from the `core-claude-plugin/commands/` directory (and subdirectories)
- Agents from the `core-claude-plugin/agents/` directory
- No manual installation or copying required

## Target Project Context

These tools are primarily designed for projects with:
- PHP and/or Perl codebases (especially legacy code)
- Security remediation needs (SQL injection, command injection)
- Code quality and review requirements
- Need for standardized development workflows

The commands are particularly effective for the CORE Compliance Platform but can be adapted for other projects with similar technology stacks and requirements.

## Developing New Commands

When creating or modifying commands in this repository:
1. Place commands in appropriate subdirectories under `core-claude-plugin/commands/`
2. Place agents in the `core-claude-plugin/agents/` directory
3. Update the plugin version in `core-claude-plugin/.claude-plugin/plugin.json` when making changes:
   - **Patch** (1.0.x): Bug fixes and minor tweaks
   - **Minor** (1.x.0): New commands or agents, backward-compatible changes
   - **Major** (x.0.0): Breaking changes or major restructuring
4. Use clear, descriptive filenames that match the command name
5. Include comprehensive documentation within each command file
6. Test commands thoroughly before committing
7. Consider reusability across different projects
8. Follow existing patterns and conventions

## Command Development Guidelines

- **Portability**: Commands should work across different project structures
- **Safety**: Include checks to prevent destructive operations
- **Clarity**: Provide clear feedback about what the command is doing
- **Flexibility**: Use variables and parameters where appropriate
- **Documentation**: Include usage examples and expected outcomes

## Contributing

To contribute new automation tools:
1. Fork this repository or create a feature branch
2. Develop and test your commands/agents in the appropriate directories:
   - Commands: `core-claude-plugin/commands/`
   - Agents: `core-claude-plugin/agents/`
3. Update the plugin version in `core-claude-plugin/.claude-plugin/plugin.json` following semantic versioning
4. Test the marketplace and plugin installation process locally:
   ```bash
   /plugin marketplace add .
   /plugin install core-claude-plugin@core-marketplace
   ```
5. Ensure changes follow the existing structure and conventions
6. Submit a PR with clear description of the new functionality
7. Update this CLAUDE.md if adding new categories or significant features

**Plugin Versioning Guidelines:**
- Increment patch version for bug fixes
- Increment minor version for new commands/agents
- Increment major version for breaking changes

Focus areas for contributions:
- Security remediation capabilities
- Code quality automation
- Developer productivity tools
- Legacy code modernization
- Cross-project standardization
- Team-specific workflows
