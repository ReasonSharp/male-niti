# Male Niti Platform

Builds and runs the whole Male Niti platform with Docker Compose: the API
(`male-niti-api`, which also serves A-To-Do's backend), the website
(`male-niti-web`, maleniti.com), the admin site (`male-niti-admin`), the
A-To-Do client (`atodo`), a Postgres database and the TLS proxy in front of
it all — plus dnh.hr, which is hosted here but is not part of the platform.

Everything goes through `./mn` (run it without arguments for a summary).

## Setting up

```bash
./mn            # first run: creates .env from env.template -- edit it
./mn build-platform [version]
```

`build-platform` sets up everything from scratch: certificates, dnh.hr, the
TLS proxy, and the platform's services via `deploy` (below). On a fresh
database the migrations create the whole schema — on `ENV=dev` with demo
data (`demo@a-to-do.test` / `demo-password`).

## Releases

A release is a version `yyyy.MM.dd.x` (e.g. `2026.10.05.1`), tagged with
that same name in every platform repo — api, web, admin, atodo, and this
one — even the ones that didn't change, so a version always names a set of
services known to work together.

```bash
./mn deploy 2026.10.05.1   # deploy a release
./mn deploy                # dev: every repo's main branch, as dev-<timestamp>
./mn rollback              # back to the release deployed before
./mn status                # what's deployed, maintenance, api health
```

A deploy:

1. checks out the release in every service repo and builds its images,
   tagged with the version, while the current release keeps serving;
2. if the database needs migrations: switches **maintenance mode** on, stops
   the api, **backs the database up** (`files/backups/`), and migrates;
3. starts the new release and waits for the api's `/health` to confirm it
   runs the right version against the right database version;
4. switches maintenance off, records the release (`files/deployed-version`,
   `files/deploy-history.log`), and keeps the previous release's images for
   `rollback` (older ones are removed).

If a migration fails, nothing changes: each database version is applied in
one transaction, and the previous release is started again. If the new
release doesn't come up healthy, maintenance stays on — `./mn rollback`.

`rollback` restarts the previous release's images and, if the database has
migrations that release doesn't know, reverts them with their downgrade
scripts. Some migrations forbid that (`minAllowedVersion` — e.g. the one
creating A-To-Do's accounts and fiscal receipts); then rollback changes
nothing and the way back is restoring the backup taken before the deploy.

## Database

The schema lives in the API repo as versioned migrations
(`male-niti-api/db/migrations/`), run by
[dbupdater](https://github.com/maleniti/dbupdater)'s `pgupgrade` /
`pgdowngrade`. The database records its version in its `setting` table; the
API refuses to serve (503) unless it's exactly the version its code expects.

```bash
./mn db status             # database version vs. the latest migration
./mn db backup             # a backup now (files/backups/)
./mn db restore <file>     # restore one (then deploy the matching release)
./mn db reset              # ENV=dev only: rebuild from the migrations + demo data
```

A database that predates versioning (the CMS tables, no version record) is
adopted by the first deploy: its structure is compared with migration 001
(`containers/postgres/catalog.sql`) and, if identical, recorded as version
001; later migrations then run as usual. If it differs, the deploy stops
and shows the differences.

## Maintenance mode

While maintenance is on, the TLS proxy answers every page of maleniti.com,
admin and A-To-Do with a "being updated" page, and every A-To-Do API request
with `503 MAINTENANCE` (the app keeps unsaved changes queued and says it's
updating; Stripe re-delivers webhooks later). Deploys switch it on and off
by themselves; by hand:

```bash
./mn maintenance on | off | status
./mn maintenance announce '2026-10-05 22:00' 15   # tell A-To-Do users in advance
./mn maintenance clear                            # withdraw the announcement
```

The flag, page and status file live in `files/maintenance/`
(`containers/nginx/maintenance.html` is the page's source). The status file,
`/_status.json` on atodo.maleniti.com, also names the live client version,
so open A-To-Do tabs running an older one offer a reload.

## Other services

```bash
./mn update [-f] dnh | tlsoffloader
./mn rebuild-dnh
./mn ps | logs | exec      # docker compose passthroughs
```
