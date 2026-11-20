import { styleText } from "node:util";

export function error(message) {
  console.error(styleText("red", message));
}

export function paint(text) {
  const trailingNewline = text.endsWith("\n");
  const lines = text.split("\n");

  if (trailingNewline) {
    lines.pop();
  }

  const painted = lines.map((line) => paintLine(line)).join("\n");

  return trailingNewline ? `${painted}\n` : painted;
}

function paintLine(line) {
  if (/^(Applying|Applied|Creating migration):/.test(line)) {
    return styleText("green", line);
  }

  if (/^(Rolling back|Rolled back):/.test(line)) {
    return styleText("yellow", line);
  }

  if (line.startsWith("[X]") || /^Applied:\s+/.test(line)) {
    return styleText("green", line);
  }

  if (line.startsWith("[ ]")) {
    return styleText("dim", line);
  }

  if (/^Pending:\s+/.test(line)) {
    return styleText("cyan", line);
  }

  if (/^Error:/.test(line)) {
    return styleText("red", line);
  }

  return line;
}
