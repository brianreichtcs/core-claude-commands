# Remediate a Legacy PHP Script

## Objective

The goal of this command is to remediate security issues in $ARGUMENTS by
following the process in this file. The script is expected to be a procedural 
PHP file that may contain vulnerabilities such as SQL injection, insecure file 
handling, command injection, XSS, or other common security flaws.

You will identify and fix these vulnerabilities by following the process below.
**Adaptive Execution**: If a step cannot be completed as specified, consult the
decision tree in the "Troubleshooting" section before proceeding.

First, here are some high-level workflow rules to follow:

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Form a task list and keep it updated as you go. The task list filename is
   `remediate-{filename}-tasks.md` where `{filename}` is the base name component of
   $ARGUMENTS and place it at the root of the repository. Mark tasks complete as
   you complete them.
3. Create a state tracking file `remediate-{filename}-state.json` to track progress
   and command execution results. This file should contain:
   - Current step being executed
   - Results of each completed command (success/failure/no-op)
   - Any error messages encountered
   - Timestamp of each operation
4. Work atomically. In other words: tasks should be as small as possible.
5. Before executing each sub-command, update the state file with the current step.
6. After each sub-command completes, update the state file with the result.
7. If a sub-command fails, check the state file to determine recovery options.
8. After each task, run the command /quality:run-linters on the file
   $ARGUMENTS to identify and cleanup any remaining coding standards issues.
9. Stage, commit, and push changes after each task. Use good practices with
   crafting atomic commit messages to make git history easy to read, and tell
   the story of the changes made.

## Process

1. Run the command `/legacy:factor-out-dbquery3 $ARGUMENTS` to
   refactor any calls to `DBquery3` into secure prepared statements.
2. Run the command `/legacy:remediate-command-injections-php $ARGUMENTS` to
   remediate any command injection vulnerabilities by replacing insecure calls
   calls to other commands.
3. Find any calls to Perl scripts and remediate by running the command
    `/legacy:remediate-perl-scripts $ARGUMENTS` to remediate the full
    execution path of the Perl script.
4. Run the command `/legacy:jsonify-legacy-output $ARGUMENTS` to
   refactor legacy output processing to safer JSON output.
5. Run the command `/legacy:add-input-validation $ARGUMENTS` to
   add input validation to the script.
6. Run the command `/legacy:add-file-level-docblock $ARGUMENTS` to
   add a file-level docblock to the script.
7. Run the command `/quality:run-linters $ARGUMENTS` to
   identify and cleanup any remaining coding standards issues.

## Error Handling and Recovery

- If any sub-command returns exit code 1 (failure), stop execution and review the state file.
- If a sub-command reports "no changes needed" (no-op), continue to the next step.
- If multiple consecutive sub-commands report no-op, this may indicate the file doesn't require remediation.
- Before retrying a failed command, ensure prerequisites are met and the file hasn't been corrupted.
- Log all command executions and their results for debugging purposes.

## State File Format

The state tracking JSON file should follow this structure:
```json
{
  "file": "$ARGUMENTS",
  "started_at": "ISO timestamp",
  "current_step": "step_name",
  "completed_steps": [
    {
      "step": "step_name",
      "command": "/command:executed",
      "result": "success|failure|no-op",
      "message": "Result message",
      "completed_at": "ISO timestamp"
    }
  ],
  "status": "in_progress|completed|failed"
}
```

## Troubleshooting Decision Tree

When encountering issues during execution, follow this decision tree:

### Sub-command Returns "No-op" (No Changes Needed)
- **Continue** to next step - this is normal and expected
- **Log** the no-op result in the state file
- **If 3+ consecutive no-ops**: Consider if this file needs remediation at all

### Sub-command Fails (Exit Code 1)
1. **Check prerequisites**: Does the file have required dependencies/imports?
2. **Verify file integrity**: Was the file corrupted by previous steps?
3. **Review error message**: Is it a recoverable error?
   - **If recoverable**: Fix the issue and retry the command
   - **If not recoverable**: Stop and ask for guidance
4. **Update state file** with failure details

### Command Path Not Found
1. **Verify command exists**: Check the .claude/commands directory structure
2. **Check spelling**: Ensure command names match exactly
3. **If command missing**: Stop and ask for guidance

### File Not Found ($ARGUMENTS)
- **Stop immediately** - do not attempt to create or modify other files
- **Log error** in state file
- **Report** file path that was attempted

### Unexpected File Content
- **If file is not PHP**: Stop and ask for guidance  
- **If file has syntax errors**: Fix syntax first, then continue
- **If file structure is unexpected**: Adapt approach based on actual content

### General Error Recovery
1. **Consult state file** to understand what was completed successfully
2. **Determine safe restart point** - usually the last successful step
3. **If unsure**: Stop and ask for specific guidance rather than guessing
