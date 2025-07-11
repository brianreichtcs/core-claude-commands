# Factor Out DBQuery3

## Objective

Our legacy codebase has a function called `DBquery3` that accepts a series of
SQL query fragments and assembles them into a complete SQL query. This function
is used throughout the codebase, but it has several issues, the most critical of
which is it promotes SQL Injection vulnerabilities by design.

Your goal is to refactor all calls to `DBquery3` out of $ARGUMENTS in accordance
with the following requirements:

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Scan the file for any calls to `DBquery3`. If no calls are found, log "No DBquery3 calls found in $ARGUMENTS" and exit successfully without making changes.

## Rules

1. Only operate on the file $ARGUMENTS.
2. Replace all `DBquery3` and `DBupdate3` calls with mysqli prepared statements.
    - When creating a prepared statement, if creating the statement fails handle
      as follows (inline, not as a separate function):
        - Log the error at error level using LoggerInterface from DI container
        - Set HTTP response code to Core\Response::STATUS_INTERNAL_SERVER_ERROR
        - Exit with error code 1
    - After successfully creating a prepared statement, use the method
      mysqli_statement::execute() with a set of parameters, rather than using
      mysqli_stmt_bind_param().
    - If executing the prepared statement fails handle as follows (inline, not
      as a separate function):
        - Log the error at error level using LoggerInterface from DI container
        - Set HTTP response code to Core\Response::STATUS_INTERNAL_SERVER_ERROR
        - Exit with error code 1

## Success/Failure Reporting

At the end of execution:
- **Success**: If all DBquery3 calls were successfully replaced, log "Successfully remediated all DBquery3 calls in $ARGUMENTS" at info level and exit with code 0.
- **Failure**: If any errors occurred during remediation, log "Failed to remediate DBquery3 calls in $ARGUMENTS: [error details]" at error level and exit with code 1.
- **No-op**: If no DBquery3 calls were found, log "No DBquery3 calls found in $ARGUMENTS - no changes needed" at info level and exit with code 0.
