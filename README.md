# Claptrapedia database

This repo manages the PostgreSQL database for [Claptrapedia](https://claptrapedia.com).

CI uses dbmate to apply migrations to staging and production.

## Local database

PostgreSQL 17.2 in Docker, listening on `127.0.0.1:5432`.

```sh
pnpm run rebuild
```

```text
postgres://claptrapedia:claptrapedia@127.0.0.1:5432/claptrapedia
```

| Script | Effect |
| --- | --- |
| `pnpm run rebuild` | Remove the container and data volume, start again, then migrate. |
| `pnpm run migrate` | Apply migrations that have not run and refresh `db/schema.sql`. |
| `pnpm run rollback` | Roll back the latest migration. `pnpm run rollback -- 2` rolls back that many. |
| `pnpm run reset` | Roll back every migration, to the point before any migration has run. |
| `pnpm run seed` | Load seed data. Placeholder for now. |
