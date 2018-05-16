
dbsize.got: dbsize.sql pg_size_bytes.sql
	psql -Upostgres -hlocalhost --no-psqlrc --echo-all -v ON_ERROR_STOP=1 < pg_size_bytes.sql
	psql -Upostgres -hlocalhost --no-psqlrc --echo-all < dbsize.sql &> $@.tmp
	grep -E -v 'CONTEXT|PL/pgSQL function pg_size_bytes' < $@.tmp > $@
	rm -f $@.tmp

.PHONY: test
test: dbsize.out dbsize.got
	colordiff -y -B -b dbsize.out dbsize.got

.PHONY: clean
clean:
	rm -f dbsize.got
