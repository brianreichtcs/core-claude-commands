# Write a Test Plan for QA

## Objective

The goal of this command is to create a test plan for the QA team to validate that the changes made to the file $ARGUMENTS work as expected. The test plan should be comprehensive enough to cover the main functionalities of the file, ensuring that no features are broken and that the code behaves as intended.

Use ultrathink mode to deeply analyze the file and its interactions within the
codebase. The test plan should be clear, concise, and easy to follow for QA testers.

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Do deep research on the file $ARGUMENTS to understand where it gets used
   in the codebase, what user facing features cause it to be caused, and how.
3. It is OK to switch to the deep thinking (Opus 4) model to do this job if you
   need to. You can also ask for help if you are stuck.

## Process

- Re-read the file with all the changes made. Research how the file is used
  throughout the codebase. Form a test plan that our QA team can use to verify
  the feature works as expected. Name the test plan something like
  `qa-{filename}-test-plan.md` Where `{filename}` is the base name of $ARGUMENTS.
  This is not expected to be a comprehensive test plan that covers things like
  security testing, API testing, fuzzing, performance testing, etc. It is
  expected to be a script that QA testers can use, from the perspective of a
  user, to validate that these changes do not break the feature and that it
  works as expected. The test plan should be written in markdown format.
