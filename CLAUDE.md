# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository is a centralized collection of reusable Claude Code automation tools (commands, agents, and configurations) that can be installed into any developer's environment and used across multiple projects. It serves as a shared toolkit for the CORE Software Team, providing standardized automation for code remediation, security scanning, code review, and development workflows.

## Key Commands

## How It Works

1. **Development**: Commands and agents are developed and tested in this repository
2. **Installation**: Developers run `./install-commands.sh` to copy the `.claude/` folder contents to their home directory
3. **Usage**: Once installed, these commands become available in any project the developer works on
4. **Updates**: Pull latest changes and re-run the install script to get new/updated commands

### Installation
To install these automation tools into your Claude Code environment:
```bash
./install-commands.sh
```

This copies all commands from `.claude/commands/` to `~/.claude/commands/` and agents from `.claude/agents/` to `~/.claude/agents/`, making them globally available across all your projects.

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
.claude/
├── agents/           # Specialized AI agents for specific tasks
│   ├── cicd-engineer.md
│   ├── code-review-mentor.md
│   └── performance-optimizer.md
├── commands/         # Claude Code command definitions
│   ├── legacy/      # PHP legacy code commands
│   ├── perl/        # Perl-specific commands
│   ├── processes/   # Multi-step workflow commands
│   ├── quality/     # Code quality commands
│   └── security/    # Security remediation commands
└── settings.local.json
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

## Target Project Context

These tools are primarily designed for projects with:
- PHP and/or Perl codebases (especially legacy code)
- Security remediation needs (SQL injection, command injection)
- Code quality and review requirements
- Need for standardized development workflows

The commands are particularly effective for the CORE Compliance Platform but can be adapted for other projects with similar technology stacks and requirements.

## Developing New Commands

When creating or modifying commands in this repository:
1. Place commands in appropriate subdirectories under `.claude/commands/`
2. Use clear, descriptive filenames that match the command name
3. Include comprehensive documentation within each command file
4. Test commands thoroughly before committing
5. Consider reusability across different projects
6. Follow existing patterns and conventions

## Command Development Guidelines

- **Portability**: Commands should work across different project structures
- **Safety**: Include checks to prevent destructive operations
- **Clarity**: Provide clear feedback about what the command is doing
- **Flexibility**: Use variables and parameters where appropriate
- **Documentation**: Include usage examples and expected outcomes

## Contributing

To contribute new automation tools:
1. Fork this repository or create a feature branch
2. Develop and test your commands/agents
3. Ensure they follow the existing structure and conventions
4. Submit a PR with clear description of the new functionality
5. Update this CLAUDE.md if adding new categories or significant features

Focus areas for contributions:
- Security remediation capabilities
- Code quality automation
- Developer productivity tools
- Legacy code modernization
- Cross-project standardization
- Team-specific workflows