# AGENTS.md

## Purpose
This file defines how coding agents should propose, validate, and apply changes in this repository.

Primary audience: autonomous or semi-autonomous coding agents.

## Repository Structure
Keep the existing architecture and place changes in the owning layer.

- System layer (machine-level NixOS):
  - `flake.nix`
  - `configuration.nix`
  - `modules/asahi.nix`
  - `modules/niri.nix`
- Home layer (user-level Home Manager):
  - `home.nix`
  - `modules/apps.nix`
  - `modules/shell.nix`
  - `modules/noctalia.nix`
- User config sources synced by Home Manager symlinks:
  - `config/*` (for example `config/nvim`, `config/niri`, `config/noctalia`, `config/git`, `config/alacritty`)
- Utility scripts:
  - `scripts/*`

Do not move responsibilities across layers unless explicitly requested.

## Working Rules
- Keep edits minimal, targeted, and local to the owning module/layer.
- Preserve the existing symlink flow in `home.nix` (`xdg.configFile.*.source` using out-of-store symlinks).
- Do not introduce broad refactors during focused fixes.
- Do not commit secrets, private tokens, or machine-local sensitive data.
- For risky changes (login/session/shell/display/boot paths), include a rollback note in the proposal.

## Documentation-First Requirement
Before suggesting or making changes, read and reference documentation for each touched subsystem.

Minimum requirement per touched subsystem:
- At least one primary source (official NixOS options/manual, Home Manager options manual, or relevant upstream project docs such as Niri/Noctalia).
- A short note describing what the documentation changed or confirmed in your approach.

If no reliable primary source is available, state that explicitly and use the most conservative change strategy.

## Validation And Lint Matrix
Run targeted checks matching the scope of changes. Avoid unrelated full rebuilds.

### Nix Linting (required after Nix edits)
- `deadnix .`
  - Treat findings as blocking by default.
  - Only keep exceptions with explicit justification.
- `statix check .`
  - Treat findings as advisory by default.
  - Apply suggestions selectively; avoid style-only churn unless requested.
  - Escalate to required fixes when a finding implies correctness or maintainability risk.

### System Layer Changes
When editing system-level NixOS files (for example `configuration.nix`, `modules/niri.nix`, `modules/asahi.nix`, system-related `flake.nix` outputs):
- `nix flake check`
- `nix build .#nixosConfigurations.asahi.config.system.build.toplevel`

### Home Layer Changes
When editing Home Manager files (for example `home.nix`, `modules/apps.nix`, `modules/shell.nix`, `modules/noctalia.nix`, home-related `flake.nix` outputs):
- `nix flake check`
- `nix build .#homeConfigurations.ruben.activationPackage`

### Config And Script Changes
- For `config/*` changes, run the nearest relevant validation for the owning subsystem (NixOS/Home Manager eval/build as above).
- For `scripts/*` changes, run script-level sanity checks when possible (`bash -n`, `fish -n`, or command-specific dry runs).

## Change Proposal Format
Every significant change proposal should include:
- Scope: files/subsystems touched.
- Docs consulted: primary references used.
- Plan: minimal set of edits.
- Validation: exact commands to run and expected signal.
- Risk/rollback: only when change touches critical paths.

## Safety
- Never run destructive commands unless explicitly requested.
- Prefer reversible operations and incremental changes.
- If repository state is unexpectedly dirty in relevant files, stop and clarify before proceeding.
