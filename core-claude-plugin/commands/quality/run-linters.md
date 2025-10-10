# Run Linters

1. Run all linters appropriate for the file $ARGUMENTS.
2. If lint issues are found, try to correct them automatically.

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Determine appropriate linters based on file extension and run them. Log results of linting operations.

## Success/Failure Reporting

At the end of execution:
- **Success**: If linting completed successfully and all issues were resolved, log "Successfully completed linting for $ARGUMENTS" at info level and exit with code 0.
- **Partial Success**: If linting found issues that were automatically fixed, log "Linting completed for $ARGUMENTS with automatic fixes applied" at info level and exit with code 0.
- **Failure**: If linting failed or found issues that could not be automatically resolved, log "Linting failed for $ARGUMENTS: [error details]" at error level and exit with code 1.
