# Remediate SQL Injection

## Overview

The purpose of this command is to remediate SQL injection vulnerabilities in a
single source code file.

## Variables

- `$input`: $ARGUMENTS
- `$taskList`: `tasks/remediate-sql-$input.md`

## Task 1: Review the file.

Review the file `$input`. Build an understanding of how SQL is executed within
the file.

## Task 2: Build a Task List.

Create a task list at $taskList in markdown format which enumerates all of the
SQL injections in the input file. Market them as incomplete to start off.

## Task 3: Remediate SQL Injections

Work incrementally as follows:

1. Pick the next incomplete task on the task list.
2. Remediate the SQL injection.
3. Run all project quality and linting tools. If they fail, assess the issue
   and fix it.
4. Once all quality tools pass, mark the item as resolved in the task list
   file.
5. Stage, commit, and push your work. Always use the atomic comments format.

