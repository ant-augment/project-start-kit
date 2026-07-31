# project-start-kit

A Claude Code plugin packaging of the `project-start` pattern: a bootstrap kit that takes an empty project folder to a fully governed ICM workspace in one flow, via an adversarial discovery interview, spec authoring, workspace scaffolding, and governance injection.

Full pattern documentation (what it does, when to use it, the worked example) lives in `docs/project-start/`. This file covers installing and running it as a plugin specifically.

## Install

```
/plugin marketplace add ant-augment/project-start-kit
/plugin install project-start-kit@forge-studio
/reload-plugins
```

Or point Claude Code at this plugin directory directly if you cloned the repo locally instead.

## Running it

Once installed, commands are namespaced by plugin name. The commands documented throughout `docs/project-start/` as `/project-start` and `/icm-sync` are invoked as:

```
/project-start-kit:project-start
/project-start-kit:icm-sync
```

Everywhere the bundled docs and skills say `/project-start` or `/icm-sync`, read it as the namespaced form above.

## What's inside

```
commands/project-start.md   Thin wrapper: loads project-scoping (Stage A+B), then icm-architect (Stage C+D).
commands/icm-sync.md        Full workspace drift audit; the manual fallback after hooks.
skills/project-scoping/     Stage A adversarial interview + Stage B spec authoring.
skills/icm-architect/       Stage C scaffold + Stage D governance injection + sync mode.
hooks/project-start/        PostToolUse drift-check hook, wired via hooks/hooks.json.
docs/project-start/         Full pattern documentation, worked example, changelog.
```

The drift-check hook fires automatically on every `Write`/`Edit` once this plugin is installed and active; you do not need to run anything to enable it.
