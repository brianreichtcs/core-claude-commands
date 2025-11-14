# Modernize Legacy Endpoint

This skill provides a systematic approach for converting procedural PHP/Perl endpoints to modern object-oriented PHP with RESTful APIs in the Core Compliance Platform.

## Overview

Use this skill when you need to:
- Convert procedural PHP scripts to modern MVC architecture
- Replace Perl business logic with PHP service classes
- Create RESTful API endpoints with proper authentication/authorization
- Maintain comprehensive test coverage throughout the conversion

## Prerequisites

Before starting, ensure you have:
- Access to the legacy PHP/Perl scripts
- Understanding of the business logic being converted
- Familiarity with CCP's modern architecture patterns

## Phase 1: Analysis

### 1.1 Understand Legacy Implementation

**Read the legacy scripts:**
```bash
# Find the entry point (usually in www/app/)
find www/app -name "*[feature_name]*"

# Find associated Perl scripts (usually in tools/pl/ or cgi-bin/)
find tools/pl -name "*[feature_name]*"
find cgi-bin -name "*[feature_name]*"
```

**Document the flow:**
- What inputs does it accept? (GET/POST parameters)
- What validation is performed?
- What database operations occur? (inserts, updates, deletes)
- What side effects occur? (notifications, event logs, search indexing)
- What does it return? (JSON, HTML, pipe-delimited, etc.)

**Identify database tables:**
- List all tables that are read from or written to
- Note any transactions or multi-table operations
- Identify foreign key relationships

### 1.2 Map to Modern Architecture

**Determine the domain entity:**
- Is there an existing entity in `src/Entities/`?
- Does it have all required properties?
- Are there related entities needed?

**Identify existing infrastructure:**
```bash
# Check for existing model interface
ls src/Models/I*Model.php | grep -i [feature]

# Check for existing service
ls src/Services/*Service.php | grep -i [feature]

# Check for existing controller
ls src/Controllers/*Controller.php | grep -i [feature]
```

**List required models:**
- Which model interfaces are needed? (I*Model)
- Do they have the methods you need?
- Are there related services required?

## Phase 2: Service Layer Implementation

### 2.1 Create or Extend Service Class

**Location:** `src/Services/[Feature]Service.php`

**Structure:**
```php
<?php
/**
 * [Feature] Service
 *
 * @copyright Copyright (c) $year$ Core Business Solutions
 * @license   Proprietary and confidential
 * @version   $version$
 */

declare(strict_types=1);

namespace Core\Services;

use Core\Entities\[Feature];
use Core\Models\I[Feature]Model;
use Core\Services\Traits\AuthenticatedUserAwareTrait;
use Core\Services\Traits\LoggerAwareTrait;
use Core\Services\Traits\TransactionManagerAwareTrait;
use DI\Attribute\Inject;
use Psr\Log\LoggerInterface;

/**
 * Service for [feature] operations
 */
class [Feature]Service
{
    use AuthenticatedUserAwareTrait;
    use LoggerAwareTrait;
    use TransactionManagerAwareTrait;

    #[Inject]
    protected I[Feature]Model $[feature]Model;

    // Add other required models and services

    /**
     * Create a new [feature]
     *
     * @param string $realm The realm name
     * @param [params] Operation-specific parameters
     * @return [Feature] The created entity
     * @throws AuthenticationException If user is not authenticated
     * @throws AuthorizationException If user lacks permissions
     * @throws InvalidArgumentException If validation fails
     */
    public function create(string $realm, [params]): [Feature]
    {
        // 1. Authentication check
        $user = $this->getAuthenticatedUser();
        if ($user === null) {
            throw new AuthenticationException('User must be authenticated');
        }

        // 2. Input validation
        if (/* validation */) {
            throw new InvalidArgumentException('Validation message');
        }

        // 3. Authorization check (if needed)
        // Use existing authorization services or models

        // 4. Begin transaction
        $this->getTransactionManager()->begin();

        try {
            // 5. Create main entity
            $entity = new [Feature]();
            // Set properties from parameters
            $created = $this->[feature]Model->create($realm, $entity);

            // 6. Create related records
            // Use other models for related inserts

            // 7. Side effects
            // - Event logging
            // - Search indexing queue
            // - Notifications

            // 8. Commit transaction
            $this->getTransactionManager()->commit();

            $this->getLogger()->info(
                'Created [feature]',
                ['id' => $created->getId(), 'realm' => $realm]
            );

            return $created;

        } catch (\Exception $e) {
            $this->getTransactionManager()->rollback();
            $this->getLogger()->error(
                'Failed to create [feature]: ' . $e->getMessage(),
                ['realm' => $realm, 'exception' => $e]
            );
            throw $e;
        }
    }
}
```

**Key patterns:**
- Use traits for cross-cutting concerns (logging, transactions, auth)
- Inject all dependencies via `#[Inject]` attribute
- Wrap multi-step operations in transactions
- Log success and failure cases
- Throw specific exceptions for different error types
- Return entities, not arrays

### 2.2 Extract Magic Strings to Constants

**In the service class:**
```php
// Error messages
private const ERROR_NOT_AUTHENTICATED = 'User must be authenticated';
private const ERROR_INVALID_PARAM = 'Parameter %s is invalid: %s';
private const ERROR_NOT_FOUND = '[Feature] with ID %d not found';

// Log messages
private const LOG_CREATED = 'Created [feature]';
private const LOG_CREATE_FAILED = 'Failed to create [feature]: %s';

// Configuration values
private const DEFAULT_STATUS = 'active';
private const MAX_TITLE_LENGTH = 255;
```

## Phase 3: Service Layer Testing

### 3.1 Create Comprehensive Unit Tests

**Location:** `tests/php/unit/Core/Services/[Feature]ServiceTest.php`

**Structure:**
```php
<?php
/**
 * Tests for [Feature]Service
 *
 * @copyright Copyright (c) $year$ Core Business Solutions
 * @license   Proprietary and confidential
 * @version   $version$
 */

declare(strict_types=1);

namespace CoreTest\Services;

use Core\Entities\[Feature];
use Core\Models\Mock\[Feature]Model;
use Core\Services\[Feature]Service;
use Core\TaskRunnerContext;
use PHPUnit\Framework\TestCase;

/**
 * @covers \Core\Services\[Feature]Service
 */
class [Feature]ServiceTest extends TestCase
{
    // Test constants
    private const DEFAULT_REALM = 'phpunit';
    private const DEFAULT_[PARAM] = 'test-value';

    private [Feature]Service $service;
    private TaskRunnerContext $user;

    public function setUp(): void
    {
        parent::setUp();

        // Create default test fixtures
        $this->user = new TaskRunnerContext();
        $this->service = (new [Feature]Service())
            ->setAuthenticatedUser($this->user)
            ->set[Feature]Model(new [Feature]Model());
    }

    /**
     * Test successful creation with valid input
     */
    public function testCreateReturnsEntityWithValidInput(): void
    {
        // Given
        $realm = self::DEFAULT_REALM;
        $param = self::DEFAULT_[PARAM];

        // When
        $result = $this->service->create($realm, $param);

        // Then
        self::assertInstanceOf([Feature]::class, $result);
        self::assertGreaterThan(0, $result->getId());
        self::assertEquals($param, $result->get[Property]());
    }

    /**
     * Test authentication requirement
     */
    public function testCreateThrowsAuthenticationExceptionWhenNotAuthenticated(): void
    {
        // Given
        $this->service->setAuthenticatedUser(null);

        // Then
        self::expectException(AuthenticationException::class);
        self::expectExceptionMessage('User must be authenticated');

        // When
        $this->service->create(self::DEFAULT_REALM, self::DEFAULT_[PARAM]);
    }

    /**
     * Test validation for invalid input
     */
    public function testCreateThrowsInvalidArgumentExceptionForInvalidInput(): void
    {
        // Given
        $invalidParam = '';

        // Then
        self::expectException(\InvalidArgumentException::class);

        // When
        $this->service->create(self::DEFAULT_REALM, $invalidParam);
    }

    // Add tests for:
    // - Authorization checks
    // - Edge cases (null, empty, boundary values)
    // - All conditional branches
    // - Error handling
    // - Side effects (logging, events, etc.)
}
```

**Coverage requirements:**
- Test all public methods
- Test all error paths (authentication, authorization, validation)
- Test all conditional branches
- Use data providers for multiple test cases
- Achieve 100% method coverage, 90%+ line coverage

### 3.2 Run Tests and Generate Coverage

```bash
# Run specific test file
vendor/bin/phpunit tests/php/unit/Core/Services/[Feature]ServiceTest.php

# Generate coverage report
XDEBUG_MODE=coverage vendor/bin/phpunit \
  tests/php/unit/Core/Services/[Feature]ServiceTest.php \
  --coverage-text \
  --coverage-html .build/coverage

# View coverage
open .build/coverage/index.html
```

## Phase 4: Controller Layer Implementation

### 4.1 Add Controller Endpoint

**Location:** `src/Controllers/[Feature]Controller.php`

**Add create method:**
```php
/**
 * Create a new [feature]
 *
 * POST /[features]
 *
 * @param Request $request HTTP request with JSON body
 * @return Response HTTP response with created entity
 */
public function create(Request $request): Response
{
    try {
        // Extract parameters from request
        $realm = $request->getOption('realm');
        $body = json_decode((string) $request->getBody(), true);

        // Validate required fields
        if (!isset($body['requiredField'])) {
            throw new InvalidRequestException('Missing required field: requiredField');
        }

        // Call service layer
        $entity = $this->service->create(
            $realm,
            $body['param1'],
            $body['param2'] ?? null
        );

        // Return created entity as JSON
        return (new Response())
            ->setStatusCode(Response::STATUS_CREATED)
            ->setBody(json_encode($entity->toArray()))
            ->setHeader('Content-Type', 'application/json');

    } catch (AuthenticationException $e) {
        return $this->createErrorResponse(Response::STATUS_UNAUTHORIZED, $e->getMessage());
    } catch (AuthorizationException $e) {
        return $this->createErrorResponse(Response::STATUS_FORBIDDEN, $e->getMessage());
    } catch (InvalidArgumentException | InvalidRequestException $e) {
        return $this->createErrorResponse(Response::STATUS_BAD_REQUEST, $e->getMessage());
    } catch (\Exception $e) {
        $this->logger->error('Failed to create [feature]: ' . $e->getMessage());
        return $this->createErrorResponse(
            Response::STATUS_INTERNAL_SERVER_ERROR,
            'Internal server error'
        );
    }
}

private function createErrorResponse(int $status, string $message): Response
{
    return (new Response())
        ->setStatusCode($status)
        ->setBody(json_encode(['error' => $message]))
        ->setHeader('Content-Type', 'application/json');
}
```

**Register route (if not using auto-routing):**
```php
// In src/bootstrap.php or routing configuration
$router->post('/[features]', [[Feature]Controller::class, 'create']);
```

### 4.2 Controller Testing

**Location:** `tests/php/unit/Core/Controllers/[Feature]ControllerTest.php`

**Structure:**
```php
<?php
/**
 * Tests for [Feature]Controller
 *
 * @copyright Copyright (c) $year$ Core Business Solutions
 * @license   Proprietary and confidential
 * @version   $version$
 */

declare(strict_types=1);

namespace CoreTest\Controllers;

use Core\Controllers\[Feature]Controller;
use Core\Entities\[Feature];
use Core\Http\Request;
use Core\Http\Response;
use Core\Services\[Feature]Service;
use PHPUnit\Framework\TestCase;

/**
 * @covers \Core\Controllers\[Feature]Controller
 */
class [Feature]ControllerTest extends TestCase
{
    private const DEFAULT_REALM = 'phpunit';
    private const DEFAULT_[PARAM] = 'test-value';

    /**
     * Test successful creation returns 201 Created
     */
    public function testCreateReturnsCreatedWithValidInput(): void
    {
        // Given
        $entity = (new [Feature]())
            ->setId(123)
            ->set[Property](self::DEFAULT_[PARAM]);

        $service = $this->createStub([Feature]Service::class);
        $service->method('create')->willReturn($entity);

        $controller = (new [Feature]Controller())->setService($service);

        $request = Request::createBaseRequest()
            ->addOption('realm', self::DEFAULT_REALM)
            ->setBody(json_encode(['param': self::DEFAULT_[PARAM]]));

        // When
        $response = $controller->create($request);

        // Then
        self::assertInstanceOf(Response::class, $response);
        self::assertEquals(Response::STATUS_CREATED, $response->getStatusCode());

        $data = json_decode((string) $response->getBody(), true);
        self::assertIsArray($data);
        self::assertEquals($entity->getId(), $data['id']);
        self::assertEquals(self::DEFAULT_[PARAM], $data['[property]']);
    }

    /**
     * Test authentication error returns 401 Unauthorized
     */
    public function testCreateReturns401WhenNotAuthenticated(): void
    {
        // Given
        $service = $this->createStub([Feature]Service::class);
        $service->method('create')
            ->willThrowException(new AuthenticationException('Not authenticated'));

        $controller = (new [Feature]Controller())->setService($service);
        $request = Request::createBaseRequest()
            ->addOption('realm', self::DEFAULT_REALM)
            ->setBody(json_encode(['param': self::DEFAULT_[PARAM]]));

        // When
        $response = $controller->create($request);

        // Then
        self::assertEquals(Response::STATUS_UNAUTHORIZED, $response->getStatusCode());
    }

    // Add tests for:
    // - 400 Bad Request (validation errors)
    // - 403 Forbidden (authorization errors)
    // - 500 Internal Server Error (unexpected exceptions)
    // - Missing required fields
    // - Invalid JSON body
}
```

## Phase 5: Integration and Cleanup

### 5.1 Run Full Test Suite

```bash
# Run all tests
vendor/bin/phpunit

# Run specific test suite
vendor/bin/phpunit tests/php/unit/Core/Services/[Feature]ServiceTest.php
vendor/bin/phpunit tests/php/unit/Core/Controllers/[Feature]ControllerTest.php
```

### 5.2 Code Quality Checks

```bash
# Fix code style
vendor/bin/phpcbf src/Services/[Feature]Service.php
vendor/bin/phpcbf src/Controllers/[Feature]Controller.php
vendor/bin/phpcbf tests/php/unit/Core/Services/[Feature]ServiceTest.php
vendor/bin/phpcbf tests/php/unit/Core/Controllers/[Feature]ControllerTest.php

# Verify code style
vendor/bin/phpcs src/Services/[Feature]Service.php
vendor/bin/phpcs src/Controllers/[Feature]Controller.php

# Run static analysis
vendor/bin/psalm src/Services/[Feature]Service.php
vendor/bin/psalm src/Controllers/[Feature]Controller.php
```

### 5.3 Delete Legacy Code

**Safely remove old scripts:**
```bash
# Verify no other code references the legacy scripts
grep -r "documents_new.php" www/
grep -r "document_new.pl" cgi-bin/ tools/

# If Perl subroutines are in shared library (like LIB500.PL):
# - Check if they're used elsewhere
# - Only delete if this is the sole usage
# - Otherwise, leave them for future cleanup
```

**Delete files:**
- Remove the legacy PHP entry point
- Remove the legacy Perl script
- Remove any associated configuration files
- Update any documentation referencing the old endpoint

## Phase 6: Commit Strategy

Create atomic commits for each logical change:

### Commit 1: Service Layer
```bash
git add src/Services/[Feature]Service.php
git add tests/php/unit/Core/Services/[Feature]ServiceTest.php
git commit -m "feat: add [feature] creation to [Feature]Service

- Implement create() method with full business logic
- Transaction-wrapped for atomicity
- Comprehensive error handling and logging
- Add unit tests with 100% method coverage
- Extract magic strings to constants

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### Commit 2: Controller Layer
```bash
git add src/Controllers/[Feature]Controller.php
git add tests/php/unit/Core/Controllers/[Feature]ControllerTest.php
git commit -m "feat: add REST API endpoint for [feature] creation

- Add POST /[features] endpoint
- Session-based authentication
- JSON request/response
- HTTP status codes (201, 400, 401, 403, 500)
- Comprehensive controller tests

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### Commit 3: Cleanup
```bash
git rm www/app/php/[feature]/[legacy_script].php
git rm tools/pl/[feature]/[legacy_script].pl
git commit -m "refactor: remove legacy [feature] scripts

- Delete procedural PHP entry point
- Delete Perl business logic script
- Modern OOP implementation in service layer

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Checklist

- [ ] Analyzed legacy implementation (inputs, outputs, flow)
- [ ] Identified all database operations
- [ ] Mapped to existing entities and models
- [ ] Implemented service layer method
- [ ] Extracted magic strings to constants
- [ ] Created comprehensive service tests (100% coverage)
- [ ] Implemented controller endpoint
- [ ] Created controller tests
- [ ] All tests pass
- [ ] PHPCS code style passes
- [ ] Psalm static analysis passes
- [ ] Legacy scripts deleted
- [ ] Atomic commits created
- [ ] Documentation updated (if applicable)

## Common Patterns

### Database Transactions
Always wrap multi-step database operations:
```php
$this->getTransactionManager()->begin();
try {
    // Multiple database operations
    $this->getTransactionManager()->commit();
} catch (\Exception $e) {
    $this->getTransactionManager()->rollback();
    throw $e;
}
```

### Event Logging
Use EventLogService for audit trail:
```php
$this->eventLogService->create(
    $realm,
    EventLog::TYPE_[ACTION],
    'Description of action',
    $userId,
    $objectId
);
```

### Search Indexing
Queue search reindexing for searchable entities:
```php
$this->searchIndexQueueService->queue(
    $realm,
    'core:search:index-[entity]',
    ['id' => $entityId]
);
```

### Authorization
Check permissions before operations:
```php
if (!$this->authorizationService->canCreate($user, $realm, [Feature]::class)) {
    throw new AuthorizationException('User lacks permission to create [feature]');
}
```

## Troubleshooting

### Tests Failing
- Ensure Mock models are returning expected data
- Verify all dependencies are properly injected
- Check that entity properties match test assertions

### Psalm Errors
- Add type hints to all parameters and return types
- Document array shapes with `@param array{key: type}`
- Clear Psalm cache: `vendor/bin/psalm --clear-cache`

### Code Style Issues
- Run `phpcbf` to auto-fix most issues
- Check for trailing whitespace
- Ensure proper PHPDoc formatting

## Summary

This skill provides a systematic approach to modernizing legacy endpoints while maintaining:
- **Quality**: Comprehensive testing and static analysis
- **Maintainability**: Clean OOP architecture with clear separation of concerns
- **Safety**: Transaction management and proper error handling
- **Traceability**: Atomic commits with clear history

Follow this pattern for all future legacy-to-modern conversions in the Core Compliance Platform.

