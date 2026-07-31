# project-start-kit marketplace

A single-plugin Claude Code marketplace hosting `project-start-kit`: a bootstrap kit that takes an empty project folder to a fully governed ICM workspace via an adversarial discovery interview, spec authoring, workspace scaffolding, and governance injection.

## Install

```
/plugin marketplace add ant-augment/project-start-kit
/plugin install project-start-kit@forge-studio
/reload-plugins
```

Then run `/project-start-kit:project-start` in a new project folder to begin.

## What's here

```
.claude-plugin/marketplace.json   Marketplace manifest, lists the one plugin below.
project-start-kit/                The plugin itself. See project-start-kit/README.md for details.
```

Built from the `project-start` pattern authored in The Forge.
