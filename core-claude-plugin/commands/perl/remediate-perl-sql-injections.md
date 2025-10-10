# Remediate SQL Injection Vulnerabilities in $ARGUMENTS

The objective of this script is to remediate all SQL injection
vulnerabilities in ARGUMENTS.

# Rules

1. If you find no SQL injection vulnerabilities. **STOP** and say
   "$ARGUMENTS has no SQL injection vulnerabilities to remediate."
2. If you find SQL injection vulnerabilities, convert the code run queries
   using prepared statements to remediate the vulnerabilities.
3. Remediate the vulnerabilitity without changing runtime behavior. If you
   cannot, stop and say "I can't determine how to fix a SQL injection
   risk in $ARGUMENTS without changing behavior." Then follow that up with
   your reasoning.
4. Where SQL queries are build by concatenating multiple strings together,
   convert the SQL query to a string unless if possible. If there is logic
   that conditionally changes the SQL query, it is acceptable to use string
   interpolation to build them.
5. If you find a SQL update being performed via the update() subprocedure:
    - Go find the update subprocedure in cron/LIB500.pl and build a firm
      understanding of the function.
    - Replace the call to update() with a direct SQL update query, using
      stored procedures to make it secure.
6. If SQL queries are only used once and do not require application logic to
   customize the queries, avoid defining the query in a variable and passing
   to the database functions. Instead, inline the query directly into the
   function call.
7. If you find calls to other Perl scripts, re-run this command with those
   scripts as arguments.

