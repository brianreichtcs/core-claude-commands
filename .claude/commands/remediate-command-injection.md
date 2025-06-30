# Claude Task: Remediate Command Injection Vulnerabilities

## Description

## Task Overview
Iteratively identify and remediate command injection vulnerabilities in the CCP codebase by replacing deprecated `Command` class usage with `SecureCommand`. This task performs one complete iteration of the security remediation workflow.

## Prerequisites
- Working directory: CCP codebase root
- Branch: `security/better-command` or derivative security branch
- Tools available: Snyk CLI, git, composer, npm, linting tools

## Methodology

### 1. Branch Management
```bash
# Create a new feature branch for this iteration
ITERATION_NUM=$(date +%Y%m%d-%H%M%S)
git checkout -b security/remediate-injection-$ITERATION_NUM
```

### 2. Vulnerability Detection

```bash
# Use Snyk to scan for command injection vulnerabilities
snyk code test --severity-threshold=medium --json > vulnerability-scan.json

# Method 1: Search for deprecated Command usage patterns
rg "use.*\\\\Command[^a-zA-Z]" --type php -n
rg "new Command\\(" --type php -n
rg "Command::" --type php -n

# Method 2: Search for direct exec() function calls
rg "exec\\(" --type php -n
rg "shell_exec\\(" --type php -n
rg "system\\(" --type php -n
rg "passthru\\(" --type php -n
```

### 3. Identify Target Files

```bash
# Get list of all vulnerable files from detection methods above
VULNERABLE_FILES=$(mktemp)
rg "use.*\\\\Command[^a-zA-Z]" --type php -l >> "$VULNERABLE_FILES"
rg "new Command\\(" --type php -l >> "$VULNERABLE_FILES"
rg "Command::" --type php -l >> "$VULNERABLE_FILES"
rg "exec\\(" --type php -l >> "$VULNERABLE_FILES"
rg "shell_exec\\(" --type php -l >> "$VULNERABLE_FILES"
rg "system\\(" --type php -l >> "$VULNERABLE_FILES"
rg "passthru\\(" --type php -l >> "$VULNERABLE_FILES"

# Remove duplicates and sort
sort -u "$VULNERABLE_FILES" > "${VULNERABLE_FILES}.sorted"
mv "${VULNERABLE_FILES}.sorted" "$VULNERABLE_FILES"
```

### 4. Check for Open Pull Requests

Before selecting a file for remediation, check if there are any open PRs that modify the file:

```bash
# Function to check for open PRs affecting a file
check_open_prs() {
    local file="$1"
    echo "Checking for open PRs affecting: $file"
    
    # Get list of open PRs and check if any modify this file
    gh pr list --state open --json number,title,files | \
    jq -r --arg file "$file" '
        .[] | 
        select(.files[]?.path == $file) | 
        "PR #\(.number): \(.title)"
    '
}

# Filter out files with open PRs
AVAILABLE_FILES=$(mktemp)
while IFS= read -r file; do
    if [ -z "$(check_open_prs "$file")" ]; then
        echo "$file" >> "$AVAILABLE_FILES"
    else
        echo "Skipping $file (has open PR)"
    fi
done < "$VULNERABLE_FILES"

# Check if any files are available for remediation
if [ ! -s "$AVAILABLE_FILES" ]; then
    echo "No files available for remediation (all have open PRs or none found)"
    echo "Stopping remediation process."
    exit 0
fi

# Select the first available file for remediation
TARGET_FILE=$(head -n1 "$AVAILABLE_FILES")
echo "Selected file for remediation: $TARGET_FILE"
```

Priority targets for remediation:
- Files using `Core\Utility\Command` class
- Files with direct shell command execution patterns (`exec()`, `shell_exec()`, etc.)
- Focus on highest risk/most critical paths first
- Skip files with open pull requests

### 5. Code Analysis and Remediation

For each identified file:

#### A. Read and Analyze Current Implementation
```php
// BEFORE (vulnerable pattern):
use Core\Utility\Command;
$command = new Command('cp %source% %destination%');
$result = $command->execute(['source' => $src, 'destination' => $dest]);

// AFTER (secure pattern):
use Core\Utility\SecureCommand;
$command = new SecureCommand('cp');
$result = $command->execute([$src, $dest]);
```

#### B. Apply SecureCommand Transformation

**For Command class usage:**
1. Replace `use Core\Utility\Command` with `use Core\Utility\SecureCommand`.
    1. When you make this change to a Command that runs a perl script, make sure
       the code is transformed to run `/usr/bin/perl` with the script as the
       first argument.
2. Convert parameterized commands to argument arrays
3. Remove shell operators and handle them in PHP if needed
4. Update variable substitution patterns
5. Verify error handling and exit code expectations

**For direct exec() function calls:**
1. Replace `exec()`, `shell_exec()`, `system()`, `passthru()` with `SecureCommand`
2. Split shell commands into separate arguments 
3. Handle output capture appropriately:
   - `exec()` → `SecureCommand::execute()` + `getLastOutput()`
   - `shell_exec()` → `SecureCommand::execute()` + `getLastOutput()`
   - `system()` → `SecureCommand::execute()` + handle output display
   - `passthru()` → `SecureCommand::execute()` + handle direct output
4. Update error handling to use `getExitCode()`

### 6. Quality Validation

#### A. Syntax and Style Checks
```bash
# Run comprehensive linting
./ops/lint-all.sh

# PHP-specific checks
vendor/bin/phpcs src/
vendor/bin/psalm
```

#### B. Unit Testing
```bash
# Run all tests
vendor/bin/phpunit

# Run specific test if file has dedicated test
vendor/bin/phpunit tests/php/unit/Core/[TargetPath]/[TargetClass]Test.php
```

### 7. Test Coverage Analysis

If tests fail or coverage is inadequate:

#### A. Add Missing Tests
```php
// Example test structure for SecureCommand migration
public function testSecureCommandExecution(): void
{
    $command = new SecureCommand('/bin/echo');
    $result = $command->execute(['Hello World']);
    
    $this->assertEquals(0, $command->getExitCode());
    $this->assertEquals('Hello World', $command->getLastOutput());
}
```

#### B. Integration Testing
- Test actual command execution with safe test data
- Verify error handling for non-zero exit codes
- Test argument handling with special characters

### 8. Iteration and Correction

If any quality checks fail:
1. Analyze the failure cause
2. Correct the implementation
3. Re-run quality checks
4. Repeat until all checks pass

### 9. Commit Process

Once all validations pass:
```bash
# Stage changes
git add -A

# Commit with descriptive message
git commit -m "security: remediate command injection in [TargetFile]

Replace deprecated Command class usage with SecureCommand to prevent
command injection vulnerabilities. Updated [specific functionality].

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to remote
git push -u origin security/remediate-injection-$ITERATION_NUM
```

## Success Criteria

An iteration is complete when:
- [ ] At least one command injection vulnerability is remediated
- [ ] All linting and static analysis checks pass
- [ ] All existing tests continue to pass
- [ ] New/updated functionality has adequate test coverage
- [ ] Changes are committed with proper documentation
- [ ] No new security vulnerabilities are introduced

## Safety Measures

1. **Branch Isolation**: Always work on feature branches
2. **Incremental Changes**: Focus on one file/vulnerability per iteration
3. **Comprehensive Testing**: Validate both functionality and security
4. **Rollback Capability**: Maintain clean git history for easy reversion
5. **Documentation**: Update inline comments and commit messages

## Common Transformation Patterns

### Pattern 1: Simple Command with Arguments
```php
// Before
$cmd = new Command('ls %directory%');
$cmd->execute(['directory' => $path]);

// After
$cmd = new SecureCommand('ls');
$cmd->execute([$path]);
```

### Pattern 2: Command with Options
```php
// Before
$cmd = new Command('grep %pattern% %file%');
$cmd->execute(['pattern' => $search, 'file' => $filename]);

// After
$cmd = new SecureCommand('grep');
$cmd->execute([$search, $filename]);
```

### Pattern 3: Complex Command (requires PHP handling)
```php
// Before
$cmd = new Command('find %dir% -name "*.php" | xargs grep %pattern%');

// After (split into PHP operations)
$findCmd = new SecureCommand('find');
$findCmd->execute([$dir, '-name', '*.php']);
$files = explode("\n", $findCmd->getLastOutput());

foreach ($files as $file) {
    $grepCmd = new SecureCommand('grep');
    $grepCmd->execute([$pattern, $file]);
    // Process results...
}
```

### Pattern 4: Direct exec() Function Calls
```php
// Before
$output = [];
$return_var = 0;
exec("ls -la $directory", $output, $return_var);

// After
use Core\Utility\SecureCommand;
$cmd = new SecureCommand('ls');
$cmd->execute(['-la', $directory]);
$output = explode("\n", $cmd->getLastOutput());
$return_var = $cmd->getExitCode();
```

### Pattern 5: shell_exec() Function Calls
```php
// Before
$result = shell_exec("grep '$pattern' $filename");

// After
use Core\Utility\SecureCommand;
$cmd = new SecureCommand('grep');
$cmd->execute([$pattern, $filename]);
$result = $cmd->getLastOutput();
```

### Pattern 6: system() and passthru() Function Calls
```php
// Before
system("cat $filename");
passthru("ls -la $directory");

// After
use Core\Utility\SecureCommand;
$catCmd = new SecureCommand('cat');
$catCmd->execute([$filename]);
echo $catCmd->getLastOutput();

$lsCmd = new SecureCommand('ls');
$lsCmd->execute(['-la', $directory]);
echo $lsCmd->getLastOutput();
```

## Next Steps

After completing this iteration:
1. Review the changes with security team if needed
2. Consider creating a pull request for code review
3. Run this task again to continue with the next vulnerability
4. Update security documentation and training materials as needed

## Notes

- Always test with realistic data that matches production patterns
- Pay special attention to user input handling
- Consider performance implications of command splitting
- Document any breaking changes or behavioral differences
- Coordinate with team on large-scale refactoring efforts