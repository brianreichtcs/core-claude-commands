# JSON Injection Remediation Prompt

## Vulnerability

This script $ARGUMENTS may contain a JSON injection vulnerability due to manual
JSON string construction through concatenation.

## Pattern to Identify

Look for code that:
- Builds JSON output using string concatenation (`$string .= '"' . $data . '"'`)
- Manually constructs JSON arrays/objects with quotes and brackets
- Uses functions like `code_string()` or custom escaping for JSON context
- Outputs JSON data using `print()` or `echo` on manually built strings

## Security Risk

User data that contains JSON special characters (quotes, backslashes, control characters) can:
- Break JSON structure causing parsing errors
- Inject malicious JSON content
- Lead to XSS if JSON is consumed by JavaScript without proper handling

## Workflow

1. If you cannot find the file $ARGUMENTS, then STOP. Do not go off script.
2. Scan the file for manual JSON construction patterns (string concatenation for JSON, calls to `code_string()`, manual quote/bracket building). If none are found, log "No manual JSON construction found in $ARGUMENTS" and exit successfully without making changes.

## Remediation Steps

1. **Replace manual string building with proper PHP data structures**:
   - Convert string concatenation to array/object building
   - Use PHP's native data types (arrays, objects, strings, numbers, booleans)

2. **Use `json_encode()` for output**:
   - Replace manual JSON construction with `json_encode($data, JSON_THROW_ON_ERROR)`
   - This automatically handles all JSON escaping and encoding

3. **Set proper HTTP headers**:
   - Add `Content-Type: application/json` header
   - Consider `Content-Security-Policy` headers if appropriate

4. **Handle encoding errors**:
   - Use `JSON_THROW_ON_ERROR` flag to catch encoding issues
   - Log any encoding failures appropriately

5. **Remove custom JSON escaping functions**:
   - Remove calls to `code_string()` or similar functions when building data structures
   - Let `json_encode()` handle all escaping

6. **Preserve exact output format for backward compatibility**:
   - Ensure the final JSON structure matches the original exactly
   - Test that consuming applications still work correctly

## Implementation Pattern

```php
// OLD: Manual string building
$json = '[';
$json .= '"' . code_string($value) . '",';
$json .= '"' . $other_value . '"';
$json .= ']';
print($json);

// NEW: Proper array building
$data = [
    $value,
    $other_value
];
header('Content-Type: application/json');
print(json_encode($data, JSON_THROW_ON_ERROR));
```

## Testing Requirements

- Verify output format matches original exactly
- Test with data containing JSON special characters: `"`, `\`, control characters
- Test with Unicode characters
- Test with empty/null values
- Verify consuming applications still parse output correctly

## Success/Failure Reporting

At the end of execution:
- **Success**: If all manual JSON construction was successfully replaced, log "Successfully converted manual JSON construction to secure json_encode() in $ARGUMENTS" at info level and exit with code 0.
- **Failure**: If any errors occurred during remediation, log "Failed to remediate JSON construction in $ARGUMENTS: [error details]" at error level and exit with code 1.
- **No-op**: If no manual JSON construction was found, log "No manual JSON construction found in $ARGUMENTS - no changes needed" at info level and exit with code 0.

## Notes

- This change eliminates JSON injection vulnerabilities completely
- Performance may improve due to more efficient JSON generation
- Code becomes more maintainable and less error-prone
- Future data structure changes become easier to implement