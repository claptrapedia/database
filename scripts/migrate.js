import { execFileSync } from "node:child_process";
import { writeFileSync } from "node:fs";

const command = process.argv[2];

if (command !== "migrate" && command !== "rollback" && command !== "reset") {
  console.error("Usage: node scripts/migrate.js migrate|rollback [count]|reset");
  process.exit(1);
}

const url =
  process.env.DATABASE_URL ??
  "postgres://claptrapedia:claptrapedia@127.0.0.1:5432/claptrapedia?sslmode=disable";

function dbmate(...args) {
  return execFileSync("dbmate", ["--url", url, ...args], {
    encoding: "utf8",
    stdio: ["inherit", "pipe", "inherit"],
  });
}

function appliedCount() {
  const status = dbmate("status");
  const applied = Number(status.match(/^Applied:\s+(\d+)/m)?.[1] ?? "NaN");

  if (!Number.isInteger(applied)) {
    console.error("Could not read the applied migration count from dbmate status.");
    process.exit(1);
  }

  return applied;
}

function rollBack(count) {
  const applied = appliedCount();

  if (count > applied) {
    console.error(`Cannot roll back ${count} migration(s). ${applied} applied.`);
    process.exit(1);
  }

  for (let i = 0; i < count; i += 1) {
    process.stdout.write(dbmate("down"));
  }
}

if (command === "migrate") {
  process.stdout.write(dbmate("up"));
} else if (command === "reset") {
  rollBack(appliedCount());
} else {
  const raw = process.argv.slice(3).find((arg) => arg !== "--") ?? "1";

  if (!/^[1-9]\d*$/.test(raw)) {
    console.error("Rollback count must be a positive integer.");
    process.exit(1);
  }

  rollBack(Number(raw));
}

const local = /\/\/(?:[^@/]*@)?(?:127\.0\.0\.1|localhost)(?::\d+)?\//.test(url);

if (!local) {
  process.exit(0);
}

const schema = execFileSync(
  "docker",
  [
    "exec",
    "claptrapedia-postgres",
    "pg_dump",
    "--schema-only",
    "--no-owner",
    "--no-acl",
    "--no-comments",
    "--no-publications",
    "--no-subscriptions",
    "--no-tablespaces",
    "--username",
    "claptrapedia",
    "--dbname",
    "claptrapedia",
  ],
  { encoding: "utf8" },
);

writeFileSync(new URL("../db/schema.sql", import.meta.url), schema);
