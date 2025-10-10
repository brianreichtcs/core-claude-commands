# Core Marketplace

A Claude Code plugin marketplace for the CORE Software Team, providing a comprehensive collection of development tools and AI assistants.

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](core-claude-plugin/.claude-plugin/plugin.json)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Marketplace-purple.svg)](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)

## Overview

This marketplace hosts the **core-claude-plugin** with automation tools for working on the CORE Compliance Platform:
- **21 Commands**: Security remediation, code quality, documentation, and workflow automation
- **21 Agents**: Specialized AI assistants for development, security, compliance, and architecture
- **Multiple Categories**: Legacy code, Perl scripts, security, quality assurance, and processes

## Quick Start

### 1. Add the Marketplace

```bash
# From repository directory
/plugin marketplace add brianreichtcs/core-claude-commands 
```

### 2. Install the Plugin

```bash
/plugin install core-claude-plugin@core-marketplace
```

### 3. Use a Command

```bash
/remediate-sql-injection path/to/file.php
/review
```

### 4. Use an Agent

Agents are automatically available in your Claude Code conversations. Simply reference them by describing your need (e.g., "Can you review this for security issues?" will invoke the security-auditor agent).

## Marketplace Structure

```
core-claude-commands/            # Marketplace repository
├── marketplace.json             # Marketplace manifest
│
└── core-claude-plugin/          # Plugin: CORE development tools
    ├── .claude-plugin/
    │   ├── plugin.json          # Plugin manifest
    │   └── README.md            # Plugin documentation
    │
    ├── commands/                # 21+ slash commands organized by category
    │   ├── legacy/              # PHP legacy code remediation
    │   ├── perl/                # Perl-specific commands
    │   ├── processes/           # Multi-step workflows
    │   ├── quality/             # Code quality tools
    │   └── security/            # Security remediation
    │
    └── agents/                  # 21+ specialized AI agents
```

## Available Commands

### Security Remediation

- `/remediate-sql-injection <file>` - Fix SQL injection vulnerabilities using prepared statements
- `/remediate-command-injection <file>` - Replace unsafe command execution with SecureCommand
- `/add-realm-validation <file>` - Add realm-specific validation
- `/add-input-validation <file>` - Add input validation to legacy scripts

### Legacy PHP Code

- `/factor-out-dbquery3 <file>` - Replace DBquery3() with mysqli::prepare()
- `/jsonify-legacy-output <file>` - Convert string-building to json_encode()
- `/add-file-level-docblock <file>` - Add comprehensive file documentation
- `/eliminate-cont-flag <file>` - Remove continuation flag pattern from legacy code

### Perl Scripts

- `/document-perl-script <file>` - Add docblock to Perl files
- `/remediate-perl-command-injection <file>` - Fix Perl command injection vulnerabilities
- `/remediate-perl-sql-injections <file>` - Fix SQL injections in Perl DBI code
- `/remediate-perl-scripts <file>` - Comprehensive Perl script remediation with recursion

### Workflow & Processes

- `/remediate <file>` - Comprehensive remediation (SQL, command injection, validation, docs)
- `/auto-remediate <file>` - Automated multi-step remediation
- `/review` - Self-review branch changes using team standards
- `/review-pr` - Perform PR review with focus on common issues
- `/write-qa-test-plan` - Generate test plan based on branch changes

### Code Quality

- `/run-linters` - Execute project linting and quality tools

## Available Agents

This plugin includes 21 specialized AI agents that are automatically available in your Claude Code conversations:

### Development & Code Quality

- **code-review-mentor** - Reviews code with educational feedback
- **junior-developer-mentor** - Guides less experienced developers
- **tech-debt-reducer** - Identifies and refactors technical debt
- **performance-optimizer** - Analyzes and optimizes performance issues
- **qa-test-engineer** - Comprehensive quality assurance review

### Security & Compliance

- **security-auditor** - Identifies and remediates security vulnerabilities
- **security-engineer** - Implements security fixes and best practices
- **iso-27001-auditor** - Audits ISO 27001 information security compliance
- **iso-9001-auditor** - Audits ISO 9001 quality management compliance

### Architecture & Infrastructure

- **architecture-reviewer** - Reviews system architecture decisions
- **database-architect** - Optimizes database design and queries
- **cicd-engineer** - Manages CI/CD pipelines and deployments
- **sre** - Site reliability engineering expertise

### Product & Business

- **product-manager** - Product strategy and feature prioritization
- **business-analyst** - Business process analysis and requirements
- **customer-success-engineer** - Customer experience optimization
- **scrum-master** - Agile practices and team facilitation

### Frontend & Design

- **frontend-engineer** - Modern JavaScript and UI development
- **ux-designer** - User experience design and usability
- **accessibility-engineer** - WCAG compliance and accessibility

### Documentation & Communication

- **technical-writer** - Clear technical documentation following best practices
- **documentation-engineer** - Comprehensive docs and knowledge capture
- **data-analyst** - Data analysis, metrics, and insights

## Installation

### Step 1: Add the Marketplace

**From the repository directory**:
```bash
git clone <repository-url>
cd core-claude-commands

# In Claude Code, add the marketplace
/plugin marketplace add .
```

**Or from a different location**:
```bash
/plugin marketplace add /path/to/core-claude-commands
```

### Step 2: Install the Plugin

```bash
# Install the core-claude-plugin from the marketplace
/plugin install core-claude-plugin@core-marketplace
```

### Step 3: Verify Installation

```bash
# Test a command
/review

# Commands and agents should now be available
```

See [Claude Code Plugin Marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces) for more details.

## Contributing

We encourage the CORE Software Team to contribute to this marketplace!

### How to Contribute

1. **Fork or create a feature branch**
2. **Add your command or agent**:
   - Commands go in `core-claude-plugin/commands/` (organized by category)
   - Agents go in `core-claude-plugin/agents/`
3. **Update plugin version** in `core-claude-plugin/.claude-plugin/plugin.json`:
   - **Patch** (1.0.x): Bug fixes and minor tweaks
   - **Minor** (1.x.0): New commands/agents, backward-compatible changes
   - **Major** (x.0.0): Breaking changes or major restructuring
4. **Test locally**:
   ```bash
   # Add marketplace and install plugin
   /plugin marketplace add .
   /plugin install core-claude-plugin@core-marketplace
   # Test your changes in a Claude Code session
   ```
5. **Submit a PR** with clear description of the new functionality
6. **Update documentation** if adding new categories or significant features

### Development Guidelines

- See [CLAUDE.md](./CLAUDE.md) for detailed development guidelines
- Follow existing patterns and conventions
- Include comprehensive documentation within command files
- Test thoroughly before submitting
- Consider reusability across different projects

### Focus Areas for Contributions

- Security remediation capabilities
- Code quality automation
- Developer productivity tools
- Legacy code modernization
- Cross-project standardization
- Team-specific workflows

## Requirements

- Claude Code CLI
- Target projects: PHP and/or Perl codebases (especially CORE Compliance Platform)
- Git (for installation and updates)

## Documentation

- [CLAUDE.md](./CLAUDE.md) - Comprehensive documentation for Claude Code
- [Marketplace Manifest](./marketplace.json) - Marketplace configuration
- [Plugin Manifest](./core-claude-plugin/.claude-plugin/plugin.json) - Plugin metadata and configuration
- [Claude Code Marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces) - Official marketplace documentation

## Target Use Cases

This plugin is particularly effective for:
- PHP and/or Perl codebases (especially legacy code)
- Security remediation needs (SQL injection, command injection)
- Code quality and review requirements
- Compliance auditing (ISO 27001, ISO 9001)
- Developer productivity and workflow automation

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
