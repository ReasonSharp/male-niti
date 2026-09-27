-- The structure of a database's platform schemas, one line per column,
-- constraint, index, extension and sequence, sorted -- so two databases can
-- be compared with a plain diff (mn's adopt-unversioned-db: is an existing,
-- unversioned database really what migration 001 creates?). Column order,
-- data and dbupdater's own `setting` table are deliberately ignored.
SELECT 'col ' || table_schema || '.' || table_name || '.' || column_name || ' ' || data_type || ' ' || coalesce(udt_name, '') || ' null=' || is_nullable || ' def=' || coalesce(column_default, '-')
FROM information_schema.columns WHERE table_schema IN ('public', 'atodo') AND table_name <> 'setting'
UNION ALL
SELECT 'con ' || n.nspname || '.' || cl.relname || ' ' || c.conname || ' ' || pg_get_constraintdef(c.oid)
FROM pg_constraint c JOIN pg_class cl ON cl.oid = c.conrelid JOIN pg_namespace n ON n.oid = cl.relnamespace
WHERE n.nspname IN ('public', 'atodo') AND cl.relname <> 'setting'
UNION ALL
SELECT 'idx ' || schemaname || ' ' || indexdef FROM pg_indexes WHERE schemaname IN ('public', 'atodo') AND tablename <> 'setting'
UNION ALL
SELECT 'ext ' || extname FROM pg_extension
UNION ALL
SELECT 'seq ' || sequence_schema || '.' || sequence_name FROM information_schema.sequences WHERE sequence_schema IN ('public', 'atodo')
ORDER BY 1;
