# Remediate Command Injection Vulnerabilities in $ARGUMENTS

The objective of this script is to remediate all command injection
vulnerabilities in ARGUMENTS.

# Rules

1. If you find no command injection vulnerabilities. **STOP** and say
   "$ARGUMENTS has no command injection vulnerabilities to remediate."
2. If you find command injection vulnerabilities, use the SecureCommand
   perl module at cron/Core/SecureCommand.pm to remediate the vulnerabilities.
3. Use "/usr/bin/perl" as the command to run, with the script as the first
   argument.
4. Remediate the vulnerabilitity without changing runtime behavior. If you
   cannot, stop and say "I can't determine how to fix a command injection
   risk in $ARGUMENTS without changing behavior." Then follow that up with
   your reasoning.
5. If you find calls to other Perl scripts, re-run this command with those
   scripts as arguments.

