<div align="center">

![banner](Images/banner.svg)

![Last Commit](https://img.shields.io/github/last-commit/oathlesss/nixos?color=a6e3a1&style=flat-square)
![Repo Size](https://img.shields.io/github/repo-size/oathlesss/nixos?color=cba6f7&style=flat-square)
![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?logo=nixos&logoColor=white&style=flat-square)
![Flakes](https://img.shields.io/badge/Flakes-enabled-5277C3?logo=nixos&logoColor=white&style=flat-square)

![screenshot](Images/NixOS%20Setup.png)

</div>

NixOS configuration for an Apple Silicon MacBook running [Asahi Linux](https://asahilinux.org/), managed with [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://github.com/nix-community/home-manager).

## System

| Component | |
|---|---|
| **Host** | `asahi` — MacBook Pro 14", M2 Pro, aarch64-linux |
| **Nixpkgs** | unstable channel |
| **Desktop** | [Niri](https://github.com/YaLTeR/niri) Wayland tiling compositor |
| **Shell / Bar** | Fish + [Noctalia](https://github.com/noctalia-dev/noctalia-shell) |
| **Terminals** | Alacritty (primary), Ghostty (secondary) |
| **Editor** | Neovim (full LSP) + Zed |
| **Font** | Berkeley Mono Nerd Font |
| **Theme** | Catppuccin Mocha throughout |

---

## Architecture

```mermaid
graph TD
    F(flake.nix)

    F --> SYS(nixosConfigurations)
    F --> HM(homeConfigurations)

    SYS --> CFG(hosts/asahi/configuration.nix)
    CFG --> M1(modules/asahi.nix\nApple Silicon overlay)
    CFG --> M2(modules/niri.nix\nWM + login)

    HM --> HOME(hosts/asahi/home.nix)
    HOME --> H1(modules/shell.nix\nFish · tmux · starship)
    HOME --> H2(modules/swaylock.nix\nLock screen)
    HOME --> H3(modules/noctalia.nix\nShell bar)
    HOME --> H4(modules/home/desktop.nix\nGUI apps)
    HOME --> H5(modules/home/dev.nix\nLanguages · LSP · editors)
    HOME --> H6(modules/home/k8s.nix\nKubernetes tooling)
    HOME --> H7(modules/home/media.nix\nAudio · media)
    HOME --> H8(modules/home/nix-tools.nix\nNix utilities)

    style F fill:#89b4fa,color:#1e1e2e,stroke:none
    style SYS fill:#cba6f7,color:#1e1e2e,stroke:none
    style HM fill:#cba6f7,color:#1e1e2e,stroke:none
    style CFG fill:#313244,color:#cdd6f4,stroke:#45475a
    style HOME fill:#313244,color:#cdd6f4,stroke:#45475a
    style M1 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style M2 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H1 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H2 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H3 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H4 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H5 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H6 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H7 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
    style H8 fill:#1e1e2e,color:#a6e3a1,stroke:#45475a
```

---

## Repository Structure

<details>
<summary>Expand file tree</summary>

```
├── flake.nix                  # Inputs and system/home outputs
├── hosts/
│   └── asahi/
│       ├── configuration.nix  # System-level NixOS config
│       ├── hardware-configuration.nix # Apple Silicon hardware
│       └── home.nix           # Home Manager entry point
├── modules/
│   ├── asahi.nix              # Apple Silicon overlay (system)
│   ├── niri.nix               # Niri WM, greetd/tuigreet login (system)
│   ├── shell.nix              # Fish, tmux, direnv, zoxide, starship (home)
│   ├── swaylock.nix           # Lock screen with blur/vignette (home)
│   ├── noctalia.nix           # Noctalia config symlinks (home)
│   └── home/
│       ├── desktop.nix        # Desktop apps and GUI tools (home)
│       ├── dev.nix            # Developer tools and languages (home)
│       ├── k8s.nix            # Kubernetes tooling (home)
│       ├── media.nix          # Media and audio packages (home)
│       └── nix-tools.nix      # Nix utilities and helpers (home)
├── config/
│   ├── niri/                  # Niri window manager config (KDL)
│   ├── nvim/                  # Neovim config (Lua)
│   ├── alacritty/             # Alacritty terminal config
│   ├── git/                   # Git config, templates, work overrides
│   └── noctalia/              # Noctalia shell settings and theme
├── scripts/
│   ├── tmux-sessionizer.fish  # FZF-based project switcher (Ctrl+F)
│   └── work-flake-bootstrap.sh # devShell generator for work projects
└── fonts/                     # Berkeley Mono Nerd Font TTF files
```

Config files under `config/` are managed as out-of-store symlinks via `xdg.configFile` in `home.nix`.

</details>

---

## Usage

<details>
<summary>Rebuild and validation commands</summary>

**System rebuild**
```bash
nh os switch --hostname asahi -- --impure
# Fish abbreviation: rebuild
```

**Home Manager rebuild**
```bash
home-manager switch -b backup --impure --flake /home/ruben/nixos#ruben
# Fish abbreviation: hrebuild
```

**Lint**
```bash
deadnix .
statix check .
```

**Build checks**
```bash
# System
nix flake check
nix build .#nixosConfigurations.asahi.config.system.build.toplevel

# Home
nix flake check
nix build .#homeConfigurations.ruben.activationPackage
```

</details>

---

## Notable Features

<details>
<summary>Expand</summary>

**Hardware & peripherals**
- Apple Silicon support via [nixos-apple-silicon](https://github.com/tpwrules/nixos-apple-silicon)
- DisplayLink dock (LG 4K, 3840×2160 @ 1.5× scale) alongside MacBook built-in (3024×1890 @ 2.0× scale)
- Sony WH-1000XM5 Bluetooth headset auto-connect with volume stabilization (Wireplumber)
- Virtual camera service: FaceTime HD (NV12) → MJPEG transcoding via ffmpeg for Chromium WebRTC

**Shell & workflow**
- Fish auto-attaches to a tmux session on terminal launch
- `Ctrl+F` opens `tmux-sessionizer`: FZF project picker across `~/repos`, `~/work`, `~/nixos`
- `work-flake-bootstrap`: generates a `flake.nix` + `.envrc` for work projects (mokum, centric, rodk, bigdatarepublic, muxyard)
- Tmux prefix `Ctrl+Space`, session auto-restore via resurrect + continuum

**Development**
- Languages: Go, Lua, Python 3.13, Rust, Zig
- Python tooling: uv, ruff, pyrefly, ty (JEMALLOC override for ARM)
- LSP servers: Bash, Docker, Lua, Emmet, VTSLS, YAML, Marksman, Taplo
- Kubernetes: kubectl (→ kubecolor), k9s, kubectx, helm, kustomize, kind, stern

**Identity & security**
- 1Password: SSH agent, git commit signing, CLI
- Git SSH signing with conditional work config (email override for `~/work/`)
- Git pager: delta

</details>
