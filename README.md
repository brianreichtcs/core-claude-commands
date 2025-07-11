# core-claude-commands

This repository provides Claude commands that I've developed for working
specifically on CORE Compliance Platform.

## Structure

- `.claude/` - Directory containing Claude Code commands, hooks, etc.
- `install-commands.sh` - A Bash script for installing commands into
  your home directory where Claude Code can pick them up.
- `README.md` - A description of this project (this document).

## Legacy Code Commands

- `/add-file-level-docblock <file>` - A command for adding a docblock to the top
  of a file. Does some thinking about the code first, then does it's best
  to write a useful docblock with a summary, a detailed explaination, an
  explaination of expected inputs, outputs, and side effects. Uses a
  template to specify the proper docblock format and annotations we expect
  to see in each file.
- `/factory-out-dbquery3 <file>` - A command for specifically rooting out SQL
  injections in legacy code that exist due to use of `DBquery3()` and
  related legacy functions. Replaces these function calls with equivalent
  calls to `mysqli::prepare()`
- `/remediate-command-injections-php <file>` - Remediates command injection
  vulnerabilities in PHP code by searching for backtick usages, `exec()`,
  and similar function calls and using `SecureCommand` instead.
- `/add-input-validation <file>` - Analyzes a legacy script for inputs and adds
  validation code to stop badly-formatted requests in their tracks.
- `/jsonify-legacy-outout <file>` - Takes a script that does what I cheekily
  describe as "JSON-like string building" and does it's best to use
  `json_encode()` to emit results while retaining the original result
  shape.
- `/remediate-perl-scripts <file>` - Attempts to remediate a Perl script
  by fixing SQL injections and command injections. Attempts some
  clever recursion to dive into called files and do the same.

## Perl Specific Commands

- `/document-perl-script <file>` - A command for adding a docblock to the top
  of a Perl file. Does some thinking about the code first, then does it's
  best to write a useful docblock with a summary, a detailed explaination,
  an explaination of expected inputs, outputs, and side effects.
- `/remediate-perl-command-injections <file>` - A command for resolving Command
  Injection vulnerabilities by looking for backticks and other unsafe
  execution methods, and replacing them with the Perl `SecureCommand`
  implementation.
- `/remediate-perl-sql-injections <file>` - A command for resolving SQL injections
  in Perl by replacing string-building `DBI` code with appropriate `prepare()`
  equivalents.

## Processes

- `/remediate <file>` - An attempt at a general purpose remediation command
  that runs all remediation commands to result in a legacy file with zero
  SQL injections, zero command injections, better input validation, and a
  half decent description at the top of the file.
- `/review` - Conducts a critical "self-review" of the changes on your branch.
  This command contains instructions that check for all of the most common things
  I typically get NITs and change requests for. My intent is to continue to add
  to this command to help myself pre-check my work to lint-out the sort of
  "trivial stuff" that I as the author might not pick up on as I read my
  own code back to myself, but will be glaringly obvious and annoying to a
  reviewer.
- `/write-qa-test-plan` - Looks at the changes on your branch, does some deep
  thinking about how and why, and the larger scope of your changes within the
  application, and helps to write a test plan. Spits it out as markdown which
  can be easily applied to a Jira ticket or PR description.

## Using Commands

To use these commands, you just need to install them into `~/.claude/commands`
so Claude Code picks them up as user commands. I've provided a script to do it
for you:

```bash
./install-commands.sh
```

## Contributing

I'd encourage anyone on the CORE Software Team to offer contributions to this
branch. To do so, please submit a PR.

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

