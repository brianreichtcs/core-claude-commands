# Add Input Validation

## Objectives

The goal of this command is to remediate security risks that could be introduced
by invalid or malicious user input in the PHP script $ARGUMENTS by explicitly
following the process in this file to introduce input validation to the script.
The script is expected to be a procedural PHP file.

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Scan the file for any usage of $_GET, $_POST, or $_REQUEST variables. If none are found, log "No user input parameters found in $ARGUMENTS" and exit successfully without making changes.
3. **Adaptive approach**: If the file structure doesn't exactly match expectations, adapt the validation approach while maintaining security objectives. If unsure about specific validation requirements, stop and ask for guidance.

## Process

- Where any $_GET, $_POST, or $_REQUEST parameters are used, use a null-coalescing
  operator to provide a default value if the parameter is not set. When there is
  no obvious default value, use an empty string.
- Ensure all user inputs are validated before being used in SQL queries.
- Validate sort direction parameters against the enum Core\Enums\SortDirection.
  Use SortDirection::tryFrom() to validate.
- Validate "boolean as integer" parameters using `Core\Validation\BooleanValidator`.
- Prefer validator components in src/Validation/ for input validation. Go learn
  about how they work if you don't know. If there is not a suitable validator,
  write validation logic using PHP's built-in functions.
- When validation fails, handle as follows (inline, not as a separate function):
    - Log the validation failure at info level using LoggerInterface from DI
      container. If validation was done using an IValidator, use the getMessages()
      method to report the specific validation errors.
    - Set HTTP response code to Core\Response::STATUS_BAD_REQUEST
    - Exit with error code 1

## Success/Failure Reporting

At the end of execution:
- **Success**: If all user inputs were successfully validated, log "Successfully added input validation to all user inputs in $ARGUMENTS" at info level and exit with code 0.
- **Failure**: If any errors occurred during remediation, log "Failed to add input validation to $ARGUMENTS: [error details]" at error level and exit with code 1.
- **No-op**: If no user input parameters were found, log "No user input parameters found in $ARGUMENTS - no changes needed" at info level and exit with code 0.
