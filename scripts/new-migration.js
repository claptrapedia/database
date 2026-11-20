import { execFileSync } from "node:child_process";
import { error, paint } from "./cli.js";

const args = process.argv.slice(2).filter((arg) => arg !== "--");
const prefixes = {
  struc: "STRUC",
  data: "DATA",
};

const kind = args[0]?.toLowerCase();
const name = args[1];

if (args.length !== 2 || !prefixes[kind]) {
  error("Usage: pnpm run new <struc|data> <name>");
  process.exit(1);
}

const output = execFileSync("dbmate", ["new", `${prefixes[kind]}_${name}`], {
  encoding: "utf8",
  stdio: ["inherit", "pipe", "inherit"],
});

process.stdout.write(paint(output));
