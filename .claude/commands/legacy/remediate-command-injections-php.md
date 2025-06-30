# Remediate Command Injections in Legacy PHP Scripts

## Objective

The goal of this command is to remediate command injection vulnerabilities in
$ARGUMENTS by following the process in this file. The script is expected to be 
a procedural PHP file that may contain command injection vulnerabilities. 
**Adaptive approach**: If the exact process doesn't match the file's structure, 
adapt the remediation while maintaining the security objectives.

## Background

You will remediate command injections in PHP using the
`Core\Utility\SecureCommand` class. You should go review that code and learn
about how it works before proceeding if a solid understanding is not already
in context.

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Scan the file for calls to `exec()`, `shell_exec()`, `system()`, `passthru()`, backticks, or similar command execution functions. If none are found, log "No command injection vulnerabilities found in $ARGUMENTS" and exit successfully without making changes.

## Process

1. Identify all calls to `exec()`, `shell_exec()`, `system()`, or similar functions
   that execute system commands.
2. For each identified call:
    - Replace the call with a secure alternative that does not allow command. Use
      `Core\Utility\SecureCommand` for executing system commands that are not
      asynchronous. Asynchronous commands will end in an `&`.
    - If the command is asynchronous, stop and ask what to do.
3. Find all calls to Perl scripts. By this point, then should all run through
   a `SecureCommand`. For each call to a Perl script:
    - Call `/usr/bin/perl` with the script as the first argument instead of
      executing it directly.
    - Remediate the Perl script by running `/legacy:remediate-perl.scripts
      {script_path}`. If that fails, stop immediately and ask what to do.

## Success/Failure Reporting

At the end of execution:
- **Success**: If all command injection vulnerabilities were successfully remediated, log "Successfully remediated all command injection vulnerabilities in $ARGUMENTS" at info level and exit with code 0.
- **Failure**: If any errors occurred during remediation, log "Failed to remediate command injection vulnerabilities in $ARGUMENTS: [error details]" at error level and exit with code 1.
- **No-op**: If no command injection vulnerabilities were found, log "No command injection vulnerabilities found in $ARGUMENTS - no changes needed" at info level and exit with code 0.
