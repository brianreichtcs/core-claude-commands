# Remediate Perl Scripts

## Objective

The goal of this command is to remediate command injection vulnerabilities in
$ARGUMENTS by explicitly following the process in this file. **DO NOT GO OFF
SCRIPT**. The script is expected to be a Perl script that may contain command
injection vulnerabilities.

## Background

You will remediate command injections in Perl using the `SecureCommand` module
defined in `cron/Core/SecureCommand.pm` You should go review that code and learn
about how it works before proceeding if a solid understanding is not already
in context.

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.

## Process

1. Identify all calls to `exec()`, `shell_exec()`, `system()`, backtick
   operations, or similar functions that execute system commands.
2. For each identified call:
    - Replace the call with a secure alternative that does not allow command. Use
      the `SecureCommand` module for executing system commands that are not
      asynchronous. Asynchronous commands will end in an `&`.
    - If the command is asynchronous, stop and ask what to do.
    - If the identified call runs another Perl script:
        - Call `/usr/bin/perl` with the script as the first argument instead of
          executing it directly.
        - Remediate the Perl script by running `/project:legacy:remediate-perl-script
          {script_path}` in order to remediate the full execution path. If that
          fails, stop immediately and ask what to do.
3. Identify any SQL queries that are constructed via string concatenation
   or interpolation. Replace these with prepared statements using the `DBI`
   module.
