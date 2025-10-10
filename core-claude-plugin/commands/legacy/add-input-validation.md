# Add Input Validation

## Variables

- `$target`
    - Value: $ARGUMENTS
    - Purpose: The path to the file to add input validation to.

## Objectives

The goal of this command is to remediate security risks that could be introduced
by invalid or malicious user input in the PHP script $target by explicitly
following the process in this file to introduce input validation to the script.
The script is expected to be a procedural PHP file.

## Workflow

1. If you cannot find the file $target, then STOP and output an error message.
   Do not try to be helpful. Do not try to do something else.
2. Scan the file for any usage of $_GET, $_POST, or $_REQUEST variables. If
   none are found, output "No user input parameters found in $target" and exit
   successfully without making changes.
3. **Adaptive approach**: If the file structure doesn't exactly match
   expectations, adapt the validation approach while maintaining security
   objectives. If unsure about specific validation requirements, stop and ask
   for guidance.

## Workflow

1. Place all input validation code in a commented VSCode Region called
   "Input Validation".
2. Where any $_GET, $_POST, or $_REQUEST parameters are used, use a null-coalescing
   operator to provide a default value if the parameter is not set. When there is
   no obvious default value, use an empty string.
3. Ensure all user inputs are validated before being used in SQL queries.


### PHP Specific Directives

1. All validation should happen in a try/catch block.
2. Validation failures should always throw a `Core\Exception\InvalidArgumentException`.
3. The try/catch block should catch `Core\Exception\InvalidArgumentException` only.
4. When an InvalidArgumentException is caught, handle failure as follows:
    - Log the validation failure at info level using LoggerInterface from DI
      container. If validation was done using an IValidator, use the getMessages()
      method to report the specific validation errors.
    - Set HTTP response code to Core\Response::STATUS_BAD_REQUEST
    - exit with error code 1
5. Validate sort direction parameters against the enum Core\Enums\SortDirection.
   Use SortDirection::tryFrom() to validate.
6. Validate "boolean as integer" parameters using `Core\Validation\BooleanValidator`.
7. Prefer validator components in src/Validation/ for input validation. Go learn
   about how they work if you don't know. If there is not a suitable validator,
   write validation logic using PHP's built-in functions.
    - Exit with error code 1

