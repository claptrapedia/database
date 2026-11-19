# Claptrapedia database

This repo manages the PostgreSQL database for [Claptrapedia](https://claptrapedia.com).

CI uses dbmate to apply migrations to staging and production.

## Local database

PostgreSQL 17.2 in Docker, listening on `127.0.0.1:5432`.

```sh
pnpm run up
```

`pnpm up` is pnpm's dependency update command, so the database script needs `run`.

```text
postgres://claptrapedia:claptrapedia@127.0.0.1:5432/claptrapedia
```

| Script | Effect |
| --- | --- |
| `pnpm run up` | Build the image and start the database. Waits until it accepts connections. Existing data is kept. |
| `pnpm run down` | Remove the container. Data volume is kept. |
| `pnpm run migrate` | Apply migrations. Placeholder until dbmate is wired in. |
| `pnpm run rebuild` | Remove the container and data volume, start again, then migrate. |
