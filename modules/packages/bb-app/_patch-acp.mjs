import assert from "node:assert/strict";

// shortcut: patches BB 0.47.1's bundle; remove when ACP supports pre-session command discovery.
export function patchAcp(source) {
  function replace(before, after) {
    assert.equal(
      source.split(before).length,
      2,
      `BB ACP bridge changed: ${before}`,
    );
    source = source.replace(before, () => after);
  }
  replace("commands:{list:!1}", "commands:{list:!0}");
  replace(
    'a.object({method:a.literal("model/list"),params:NY})',
    'a.object({method:a.literal("commands/list"),params:NY.extend({cwd:a.string().min(1)})}),a.object({method:a.literal("model/list"),params:NY})',
  );
  replace(
    'case"model/list":{let n=_b(e.params.providerOptions);',
    `case "commands/list": {
      it(e.id, await bbAcpListCommands(e.params));
      return;
    }
    case"model/list":{let n=_b(e.params.providerOptions);`,
  );
  return (
    source +
    `
async function bbAcpListCommands(params) {
  const launch = Uu(params.providerOptions);
  if (!launch) throw new Error("ACP command discovery requires acpLaunchSpec");
  const agent = { ...bx(launch), cwd: launch.cwd ?? params.cwd };
  const dialectId = zw({ dialectId: Fu(params.providerOptions), command: agent.command }).id;
  const env = { ...js(process.env), ...agent.envVars, ...Sb(dialectId, "accept-edits") };
  let commands = [];
  let received;
  const available = new Promise((resolve) => { received = resolve; });
  const connection = Vw({
    command: agent.command, args: agent.args, cwd: agent.cwd, env, recordThreadId: null,
    onResponse: () => {},
    onNotification: (method, notification) => {
      if (method !== "session/update" || notification?.update?.sessionUpdate !== "available_commands_update") return;
      const decoded = UX(notification.update.availableCommands);
      if (decoded === null) return;
      commands = Yre(decoded).commands;
      received();
    },
    onRequest: (_method, _params, responder) => responder.error(-32601, "Command discovery does not support requests"),
    onExit: () => {},
  });
  let session = null;
  let timeout;
  let notificationTimeout;
  try {
    await Promise.race([
      (async () => {
        const capabilities = await pd(connection, { parameterizedModelPicker: false, fsAccess: false });
        await Ww({ connection, env, capabilities });
        const created = await connection.request({
          method: "session/new", params: { cwd: agent.cwd, mcpServers: [] },
          resultSchema: a.object({ sessionId: a.string().min(1) }),
        });
        session = { capabilities, sessionId: created.sessionId };
        // shortcut: allow two seconds for post-session commands; revisit if an agent publishes them later.
        await Promise.race([available, new Promise((resolve) => { notificationTimeout = setTimeout(resolve, 2000); })]);
      })(),
      new Promise((_resolve, reject) => {
        timeout = setTimeout(() => { connection.kill(); reject(new Error("ACP command discovery timed out")); }, xs);
      }),
    ]);
    return { commands };
  } finally {
    clearTimeout(timeout);
    clearTimeout(notificationTimeout);
    await E$({ connection, agent, env, dialectId, session });
  }
}
`
  );
}
