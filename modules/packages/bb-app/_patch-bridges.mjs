import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFileSync, writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";
import { patchAcp } from "./_patch-acp.mjs";

// shortcut: patches BB 0.47.1's published bundle; remove when upstream supports Pi commands.
export function patchPi(source) {
  function replace(before, after) {
    assert.equal(
      source.split(before).length,
      2,
      `BB Pi bridge changed: ${before}`,
    );
    source = source.replace(before, () => after);
  }

  replace("commands:{list:!1}", "commands:{list:!0}");
  replace(
    'i.object({method:i.literal("model/list"),params:HE})',
    'i.object({method:i.literal("commands/list"),params:i.object({cwd:i.string().min(1)})}),i.object({method:i.literal("model/list"),params:HE})',
  );
  replace(
    'case"model/list":await N4(e.id,e.params);break;',
    `case "commands/list": {
      const catalog = await Oa(e.params.cwd, or());
      pe(e.id, { commands: await catalog.listCommands() });
      break;
    }
    case"model/list":await N4(e.id,e.params);break;`,
  );
  replace(
    "rawModels:p,probe:m,",
    `rawModels:p,probe:m,
    async listCommands() {
      const active = a();
      await active.ready;
      const result = await active.child.requestOk({ type: "get_commands" });
      n();
      return bbPiCommands(result);
    },`,
  );
  replace(
    "async getState(t){",
    `async getCommands() {
      return bbPiCommands(await this.requireChild().requestOk({ type: "get_commands" }));
    }
    async getState(t){`,
  );
  replace(
    "M4(e,t,l)}",
    `M4(e,t,l);
    try {
      const commands = await te.get(t).session.getCommands();
      zo(t, [{ kind: "extension.state", extensionKind: "bb/provider-commands", payload: { commands } }]);
    } catch (error) {
      process.stderr.write("Pi command discovery failed: " + String(error) + "\\n");
    }
    }`,
  );

  // Preserve Pi's prompt disposition through the existing authentication retry path.
  replace("await t.requestOk(n,r);return", "return await t.requestOk(n,r)");
  replace(
    'this.isProcessing=!0;let o=this.trackPendingInputConsumption("followUp")',
    'const bbRunsStarted = this.agentRunsStarted;this.isProcessing=!0;let o=this.trackPendingInputConsumption("followUp")',
  );
  replace(
    ".then(async()=>o.pending.queuedText!==null?(this.dropRunSettlement(),null):(this.resolvePendingInputConsumption(o.pending),await a),l=>",
    `.then(async (result) => {
      if (o.pending.queuedText !== null) {
        this.dropRunSettlement();
        return null;
      }
      this.resolvePendingInputConsumption(o.pending);
      if (result?.disposition === "handled" && this.agentRunsStarted === bbRunsStarted) {
        this.isProcessing = false;
        this.dropRunSettlement();
        return {};
      }
      return await a;
    },l=>`,
  );

  return (
    source +
    `
function bbPiCommands(result) {
  if (!Array.isArray(result?.commands)) throw new Error("Invalid Pi command catalog");
  const seen = new Set();
  return result.commands.filter((command) => {
    if (!command || !["extension", "prompt"].includes(command.source) ||
        typeof command.name !== "string" || !/^[^\\s/$]+$/u.test(command.name) ||
        seen.has(command.name)) return false;
    seen.add(command.name);
    return true;
  }).slice(0, 500).map(({ name, description }) => ({
    name, description: typeof description === "string" ? description : "",
  }));
}
`
  );
}

if (
  process.argv[1] &&
  import.meta.url === pathToFileURL(process.argv[1]).href
) {
  for (const [provider, patch] of [
    ["pi", patchPi],
    ["acp", patchAcp],
  ]) {
    const directory = `${process.argv[2]}/server/dist/builtin-plugins/provider-${provider}/dist`;
    const source = patch(readFileSync(`${directory}/host.js`, "utf8"));
    writeFileSync(`${directory}/host.js`, source);
    const metadata = JSON.parse(
      readFileSync(`${directory}/host.meta.json`, "utf8"),
    );
    metadata.artifactDigest = createHash("sha256").update(source).digest("hex");
    writeFileSync(
      `${directory}/host.meta.json`,
      JSON.stringify(metadata, null, 2) + "\n",
    );
  }
}
