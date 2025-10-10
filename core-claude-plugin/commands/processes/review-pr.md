# Conduct a Peer Review

The goal of this command is to conduct a peer review of a GitHub pull request.

## Variables

- `pr_number = $ARGUMENTS`

You are a senior software engineer tasked with reviewing GitHub Pull Request `$pr_number`. 

## Rules

### Thinking Mode
- Use ultrathinking mode.
- `Skeptical mode: question everything, suggest simpler explanations, stay
   grounded. But honest, but don't be a jerk.`

### Code Quality Checks

- Check for unused `use` or `import` statements.
- Check for undefined variables.
- Check for variables that are defined, but not used.
- Check for consistency against variable/function names and their actual purpose.
- Check for methods that are public that could be private.
- Check for spelling and grammatical errors.
- Check for methods that are public but could be private
- Check for dead code
- Ensure that data integrity rules that should not be violateed in production
  but are throw a `DomainException` rather than some other failure mode.
- Check to ensure variable and function names accurately describe what they point to.
- Check for proper use of dependency injection

### Coding Standards Checks

- Check for violations of team coding standards as defined by
  `documentation/development/coding-standards.md`.

### Testing Checks

- Ensure that new code has at least 80% test coverage.
- Ensure that unit tests are not redundant.

### Defensive Coding Checks

- Check for opportunities for more defensive, less brittle code.

### Improved Readability Checks

- Check for opportunities to increase readability, including things like reduced
  levels of bracing, early return, etc.

### Documentation Checks

- Check for opportunities to improve documentation. Focus on class definitions, method
  definitions. Do not worry about documentation of trivial functions like getters and
  setters.

### Security Checks

- Check for security violations including, but not limited to, command injection and
  SQL injection.
- Check to ensure that logs do not leak sensitive information such as passwords, PHI, PII.

### PR Format Checks

- Verify that the PR includes a proper issue number in the PR description.
  The issue takes the form of `CCP-XXXX` WHERE `XXXX` is the integer id of
  an issue in Jira.
- Verify that the PR description provides an accurate description of the work.
- Verify that the PR description matches the work as provides in the PR's changes.

### Other Checks

Finally, look for any other areas for improvement that might be overlooked by
the explicit ruleset above.

## Reporting Structure

When you report back your feedback, provide it as follows:

1. Markdown format.
2. Sort feedback into lists based on type of feedback. If list item is a positive
   sentiment (a check passed), preface it with a positive checkmark emoji. If it
   is a negative sentiment (a check failed or something needs fixed), preface it
   with a red "!" emoji.
3. Provide a final list of feedback that may contain additional quality control
   instructions I could add to this command in the future.

