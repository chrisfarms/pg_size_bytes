# pg_size_bytes

## Overview

Postgres 9.6+ ships with a builtin function [pg_size_bytes(text)](https://www.postgresql.org/docs/9.6/static/functions-admin.html) that converts filesizes expressed with units to bytes. ie "1 kB" => 1024.

`pg_size_bytes.sql` contains a plpgsql function that can be loaded for earlier versions of postgres to mimic this.

## Usage

```
postgres=# select pg_size_bytes('1 GB');
┌───────────────┐
│ pg_size_bytes │
├───────────────┤
│    1073741824 │
└───────────────┘
(1 row)
```

## Test

Tests are created by copying the postgres regression output for dbsize and tweaking it a bit since our error output is not the same.

Tests assumes a postgres 9.5 instance running on localhost, spin one up with docker via:

```
docker run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD= -d postgres:9.5
```

Then run and compare regression output:

```
make clean test
```
