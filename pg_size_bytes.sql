create or replace function pg_size_bytes(input text) returns bigint as $$ declare
	size text;
	unit text := 'bytes';
	value numeric := 0;
	n bigint;
begin
	size = trim(regexp_replace(input, E'\\s+', ' ', 'g'));
	unit = lower(regexp_replace(size, E'[\\-\\.0-9]', '', 'g'));
	value = array_to_string(regexp_matches(size, E'^([0-9e\\-\\.]+)', 'i'), '')::numeric;
	if value is null then
		raise exception 'invalid size "%"', input;
	end if;
	if unit ~* 'bytes$' or unit = '' then
		value = value;
	elsif unit ~* 'kb$' then
		value = value * 1024;
	elsif unit ~* 'mb$' then
		value = value * 1024 * 1024;
	elsif unit ~* 'gb$' then
		value = value * 1024 * 1024 * 1024;
	elsif unit ~* 'tb$' then
		value = value * 1024 * 1024 * 1024 * 1024;
	else
		n = value::bigint;
		value = null;
	end if;
	if value is null then
		raise exception 'invalid size "%"', input using
			hint = 'Valid units are "bytes", "kB", "MB", "GB", and "TB"',
			detail = 'Invalid size unit: "' || unit || '"';
	end if;
	return value::bigint;
end; $$ language plpgsql;
