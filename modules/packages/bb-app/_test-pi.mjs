import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

const directory = `${process.argv[2]}/server/dist/builtin-plugins/provider-pi/dist`;
const source = readFileSync(`${directory}/host.js`, "utf8");
const metadata = JSON.parse(
  readFileSync(`${directory}/host.meta.json`, "utf8"),
);
assert.equal(
  metadata.artifactDigest,
  createHash("sha256").update(source).digest("hex"),
);

const temporary = mkdtempSync(join(tmpdir(), "bb-pi-test-"));
try {
  const modulePath = join(temporary, "host.mjs");
  writeFileSync(
    modulePath,
    source +
      "\nexport { er as Session, S4 as decode, bbPiCommands, A4 as request, Jt as catalogs };\n",
  );
  const { Session, decode, bbPiCommands, request, catalogs } = await import(
    pathToFileURL(modulePath)
  );
  const commands = [
    { name: "antigravity", source: "extension", description: "Accounts" },
    { name: "template", source: "prompt" },
    { name: "skill:example", source: "skill" },
    { name: "antigravity", source: "extension" },
    { name: "/invalid", source: "extension" },
    null,
  ];
  const expected = [
    { name: "antigravity", description: "Accounts" },
    { name: "template", description: "" },
  ];
  assert.deepEqual(bbPiCommands({ commands }), expected);
  assert.throws(() => bbPiCommands({}), /Invalid Pi command catalog/);
  assert.equal(
    decode({
      jsonrpc: "2.0",
      id: 1,
      method: "commands/list",
      params: { cwd: "/tmp" },
    }).kind,
    "request",
  );
  assert.equal(
    decode({ jsonrpc: "2.0", id: 1, method: "commands/list", params: {} }).kind,
    "invalid-params",
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
    catalogs.set(
      "/tmp",
      Promise.resolve({ listCommands: async () => expected }),
    );
    await request({ id: 2, method: "commands/list", params: { cwd: "/tmp" } });
    assert.deepEqual(messages.pop().result.commands, expected);
  } finally {
    process.stdout.write = originalWrite;
  }

  function session(reply) {
    const instance = new Session(
      {},
      () => {},
      () => {},
      () => {},
    );
    instance.child = { exited: false, requestOk: async () => reply };
    return instance;
  }

  const handled = session({ disposition: "handled" });
  const command = handled.prompt("/antigravity");
  await command.consumed;
  assert.deepEqual(await command.settled, {});
  assert.equal(handled.isProcessing, false);
  assert.equal(handled.pendingRunSettlements.length, 0);

  for (const reply of [{ disposition: "started" }, undefined]) {
    const normal = session(reply);
    const turn = normal.prompt("hello");
    await turn.consumed;
    let settled = false;
    void turn.settled.then(() => {
      settled = true;
    });
    await Promise.resolve();
    assert.equal(settled, false, "Normal prompts must await agent settlement");
    normal.settleRun({ messages: [] });
    assert.deepEqual(await turn.settled, { boundaryDelivered: true });
  }

  const startsAgent = session({ disposition: "handled" });
  startsAgent.child.requestOk = async () => {
    startsAgent.trackProcessingState({ type: "agent_start" });
    return { disposition: "handled" };
  };
  const turn = startsAgent.prompt("/command-that-starts-agent");
  await turn.consumed;
  assert.equal(startsAgent.pendingRunSettlements.length, 1);
  startsAgent.settleRun({ messages: [] });
  assert.deepEqual(await turn.settled, { boundaryDelivered: true });

  const failure = session();
  failure.child.requestOk = async () => {
    throw new Error("command failed");
  };
  const failed = failure.prompt("/broken");
  await assert.rejects(failed.consumed, /command failed/);
  assert.match((await failed.settled).error.message, /command failed/);

  console.log(
    "BB Pi bridge: discovery, metadata, handled commands, agent settlement, and errors passed",
  );
} finally {
  rmSync(temporary, { recursive: true, force: true });
}
