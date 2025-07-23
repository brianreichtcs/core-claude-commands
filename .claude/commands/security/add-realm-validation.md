# Add Realm Validation

## Variables

- `$target`
    - Value: $ARGUMENTS
    - Purpose: The path to the file to modify
- `$realm`
    - Value: To be determined during the command workflow
    - Purpose: The realm whose data is being queried or updated by the
      file `$target`

## Objectives

The goal of this command is to improve security in `$target` by adding an
authorization step which validates that the requesting user actually has
access to the realm specified in their request.

## Top-Level Commands

The following rules have priority over the rest of the rules and steps in this
command:

- If you cannot find the file $target, then STOP and output an error message.
  Do not try to be helpful. Do not try to do something else.
- Determine the realm being queried. Store this value as `$target` 
    - Many scripts use `$Srealm` which is the realm name specified in a session
      variable.
    - Many scripts specify a GET or POST variable, often called `ARG_Crealm` or
      similar.
    - Use the script's flow to understand which value actually gets used to
      satisfy the request, and adapt code appropriately.

## Workflow

1. Place authorization code in a VSCode region called "Authorization Check"
2. Use the `authenticatedUser` object provided by the DI container to get the
   current user.
3. Get the current user's "InSight User".
4. Use the InSight User to check if the user has a mapping for the
   requested realm.
5. If they do not have a mapping for the requested realm:
    - Log the authorization failure.
    - Return a `Response::STATUS_UNAUTHORIZED` http response code.
    - Exit with error code 1

Ensure all classes including `Core\Entities\User` and `Core\Response` have a `use` statement.

### Example Implementation

This is an example implementation. The command should adapt the implementation
to work with the $realm as specified in $target.

```php
#region Authorization Check

/** @var User */
$authenticatedUser = $container->get('authenticatedUser');
if (! $authenticatedUser->getInsightUser()->hasClientMapping($ARG_Crealm)) {
    $logger->info(sprintf(
        'User %s tried to call %s for realm %s but does not have realm access',
        $authenticatedUser->getUsername(),
        __FILE__,
        $ARG_Crealm
    ));
    http_response_code(Response::STATUS_UNAUTHORIZED);
    exit(1);
}

#endregion Authorization Check
```

