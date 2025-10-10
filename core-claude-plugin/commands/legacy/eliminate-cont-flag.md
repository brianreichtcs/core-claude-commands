# Eliminate the $cont Flag

## Objective

This command refactors the pattern of tracking a boolean flag which determines
if a script should keep processing and replaces it with early return.

## The Old Pattern

Much of our legacy code has a pattern of tracking a boolean flag called
`$cont` which is either true or false (or 1 or 0) which specifies whether
processing should continue to the next step. Conditions are used to inspect
`$cont` and do the next step if it is truthy, or skip the next step if it is
falsy.

### Example:

Below is some example code taken directly from our codebase of how this looks in practice.
```php
// Example if setting $cont based on error condition:
$cont = 1;
if($ELkey eq '')        { $cont = 0; }
if($Crealm eq '')       { $cont = 0; }
if($log_object eq '')   { $cont = 0; }
if($primaryKey eq '')   { $cont = 0; }
if($docLink eq '')      { $cont = 0; }
if($docName eq '')      { $cont = 0; }
if($save_path eq '')    { $cont = 0; }
if($SuserKey eq '')     { $cont = 0; }
if($Susername eq '')    { $cont = 0; }
if($ScKey eq '')        { $cont = 0; }

// Example of using $cont to conditionally execute next step:
if ($cont == 1) {
    $DBRW_inSight = getDatabaseConnection($dbRW, $adminDB, $adminUser);

    if (!$DBRW_inSight) { 
        $cont = 0;
        # See file_upload.php ERROR_CODE_DATABASE_CONNECTION_FAILED
        $errnum = 11; 
        $logger->error('Unable to connect to admin database');
    }
}
```

## The New Pattern: Early Exit

In new code, or when we refactor old code, we prefer to move to early return
or early termination, while logging failures and providing the frontend with
the proper HTTP response code.

### Example:

```php
$DBRW_inSight = getDatabaseConnection($dbRW, $adminDB, $adminUser);
if (!$DBRW_inSight) {
    $logger->error(__FILE__ . ' unable to connect to the database');
    http_response_code(Response::STATUS_INTERNAL_SERVER_ERROR);
    exit(1);
}

The early exit pattern will:

- Always log the failure using the LoggerInterface registered in DI.
- Always return an appropriate HTTP response code using the constants in
  Core\Response.
- Maintain backwards compatibility by maintaining for output format that was
  emitted by the previous iteration of the code.
- Always terminate with exit code 1

# Workflow

1. Remove all changes to the `$cont` flag. Stop tracking it.
2. Where `$cont` flag is tested and used to determine whether or not to
   continue to the next stage of the process, replace with the early
   exit pattern.
3. Always maintain backwards compatibility.

