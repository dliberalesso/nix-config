import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

const directory = `${process.argv[2]}/server/dist/builtin-plugins/provider-acp/dist`;
const source = readFileSync(`${directory}/host.js`, "utf8");
const metadata = JSON.parse(
  readFileSync(`${directory}/host.meta.json`, "utf8"),
);
assert.equal(
  metadata.artifactDigest,
  createHash("sha256").update(source).digest("hex"),
);

const temporary = mkdtempSync(join(tmpdir(), "bb-acp-test-"));
try {
  const modulePath = join(temporary, "host.mjs");
  writeFileSync(
    modulePath,
    source + "\nexport { ese as request, Xoe as decode, bbAcpListCommands };\n",
  );
  const { request, decode, bbAcpListCommands } = await import(
    pathToFileURL(modulePath)
  );
  const messages = [];
  const originalWrite = process.stdout.write;
  process.stdout.write = (line) => {
    messages.push(JSON.parse(line));
    return true;
  };
  try {
    await request({ id: 1, method: "initialize" });
    assert.equal(messages.pop().result.capabilities.commands.list, true);
  } finally {
    process.stdout.write = originalWrite;
  }
  assert.equal(
    decode({
      jsonrpc: "2.0",
      id: 1,
      method: "commands/list",
      params: { cwd: temporary },
    }).kind,
    "request",
  );
  assert.equal(
    decode({ jsonrpc: "2.0", id: 1, method: "commands/list", params: {} }).kind,
    "invalid-params",
  );
  await assert.rejects(
    bbAcpListCommands({ cwd: temporary }),
    /requires acpLaunchSpec/,
  );

  const fixture = join(temporary, "agent.mjs");
  const log = join(temporary, "requests.jsonl");
  writeFileSync(
    fixture,
    `
import { appendFileSync } from "node:fs";
import { createInterface } from "node:readline";
const send = (message) => process.stdout.write(JSON.stringify({ jsonrpc: "2.0", ...message }) + "\\n");
createInterface({ input: process.stdin }).on("line", (line) => {
  const request = JSON.parse(line);
  appendFileSync(process.env.BB_COMMAND_TEST_LOG, JSON.stringify({method: request.method, pid: process.pid}) + "\\n");
  if (request.method === "initialize") {
    send({ id: request.id, result: { protocolVersion: 1, agentCapabilities: {}, authMethods: [] } });
  } else if (request.method === "session/new") {
    if (process.env.BB_COMMAND_TEST_FAIL) {
      send({ id: request.id, error: { code: -32000, message: "discovery failed" } });
      return;
    }
    send({ id: request.id, result: { sessionId: "discovery" } });
    if (process.env.BB_COMMAND_TEST_SILENT) return;
    setTimeout(() => send({ method: "session/update", params: { sessionId: "discovery", update: {
      sessionUpdate: "available_commands_update",
      availableCommands: process.env.BB_COMMAND_TEST_EMPTY ? [] : [
        { name: "review", description: "Review changes", input: { hint: "commit" } },
        { name: "", description: "invalid" },
        null,
      ],
    } } }), 20);
  } else {
    send({ id: request.id, error: { code: -32601, message: "Unexpected method" } });
  }
});
`,
  );
  const params = {
    cwd: temporary,
    providerOptions: {
      acpDialect: "opencode",
      acpLaunchSpec: {
        displayName: "Test",
        command: process.execPath,
        args: [fixture],
        env: { BB_COMMAND_TEST_LOG: log },
      },
    },
  };
  assert.deepEqual(await bbAcpListCommands(params), {
    commands: [
      { name: "review", description: "Review changes", inputHint: "commit" },
    ],
  });
  params.providerOptions.acpLaunchSpec.env.BB_COMMAND_TEST_EMPTY = "1";
  assert.deepEqual(await bbAcpListCommands(params), { commands: [] });
  params.providerOptions.acpLaunchSpec.env.BB_COMMAND_TEST_SILENT = "1";
  assert.deepEqual(await bbAcpListCommands(params), { commands: [] });
  params.providerOptions.acpLaunchSpec.env.BB_COMMAND_TEST_FAIL = "1";
  await assert.rejects(bbAcpListCommands(params), /discovery failed/);
  const requests = readFileSync(log, "utf8").trim().split("\n").map(JSON.parse);
  assert.deepEqual(
    requests.map(({ method }) => method),
    Array.from({ length: 4 }, () => ["initialize", "session/new"]).flat(),
  );
  for (const pid of new Set(requests.map(({ pid }) => pid))) {
    assert.throws(() => process.kill(pid, 0), { code: "ESRCH" });
  }
  console.log(
    "BB ACP bridge: discovery, delayed notifications, empty catalogs, validation, and cleanup passed",
  );
} finally {
  rmSync(temporary, { recursive: true, force: true });
}
