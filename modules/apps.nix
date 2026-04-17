{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    (blender.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ sse2neon ];
    }))

    # Browsers

    # Desktop / Wayland
    grim
    nautilus
    obs-studio
    slurp
    swayidle
    wev
    widevine-cdm
    wl-clipboard
    xwayland-satellite
    inputs.noctalia.packages.aarch64-linux.default

    # Media
    gimp
    kdePackages.kdenlive
    libreoffice
    loupe
    playerctl
    viu
    spotify

    # Notes / productivity
    obsidian

    # AI / code assistants
    claude-code
    codex
    opencode

    # Editors / IDEs
    zed

    # File managers
    yazi

    # Terminal multiplexers
    zellij

    # Version control
    gitleaks
    jujutsu
    lazygit
    onefetch

    # TUI dashboards
    lazydocker
    lazyjournal
    lazysql
    lazyssh

    # Build tools
    gnumake
    just

    # Languages & runtimes
    fnm
    go
    lua
    rustup
    zig
    (pkgs.writeShellScriptBin "python3" ''exec ${pkgs.python3}/bin/python3 "$@"'')
    (pkgs.writeShellScriptBin "python3.11" ''exec ${pkgs.python311}/bin/python3.11 "$@"'')
    (pkgs.writeShellScriptBin "python3.12" ''exec ${pkgs.python312}/bin/python3.12 "$@"'')
    (pkgs.writeShellScriptBin "python3.13" ''exec ${pkgs.python313}/bin/python3.13 "$@"'')
    (pkgs.writeShellScriptBin "python3.14" ''exec ${pkgs.python314}/bin/python3.14 "$@"'')

    # Python tooling
    pyrefly
    ruff
    uv
    zuban
    (ty.overrideAttrs (old: {
      env = (old.env or {}) // { JEMALLOC_SYS_WITH_LG_PAGE = "14"; };
    }))

    # Language servers
    bash-language-server
    docker-language-server
    emmet-language-server
    lua-language-server
    marksman
    taplo
    vscode-langservers-extracted
    vtsls
    yaml-language-server

    # CLI essentials
    bat        # cat with syntax highlighting
    delta      # git diff pager
    dust       # intuitive du replacement
    duf        # pretty df replacement
    fd         # fast find replacement
    jq         # JSON processor
    navi       # interactive cheatsheet
    procs      # ps replacement
    ripgrep    # fast grep
    tealdeer   # fast tldr pages
    tree-sitter # tree-sitter CLI
    yq         # jq for YAML/TOML/XML

    # System monitoring
    bottom     # htop with graphs

    # Kubernetes
    kubectl
    k9s
    kubectx    # includes kubens
    helm
    kustomize
    kind       # local clusters in Docker
    stern      # multi-pod log tailing
    kubecolor  # colorized kubectl output

    # Nix tooling
    deadnix
    nh
    nix-output-monitor
    statix

    # Database
    beekeeper-studio
    d2
    duckdb
    pgcli
    postgresql
    postgresql.dev
    (pkgs.writeShellScriptBin "pg_config" ''
      config="${pkgs.postgresql.dev}/nix-support/pg_config.expected"
      if [ "$#" -eq 0 ]; then
        cat "$config"
        exit 0
      fi
      for arg in "$@"; do
        key="$(echo "''${arg#--}" | tr '[:lower:]' '[:upper:]')"
        value="$(grep "^$key = " "$config" | sed "s/^$key = //")"
        echo "$value"
      done
    '')

    # Web development
    gh        # GitHub CLI
    xh        # HTTP client
    mkcert    # local HTTPS certificates
    act       # run GitHub Actions locally
    tokei     # count lines of code by language
    bruno     # open-source API client (Postman alternative)

    # Containers / DevOps
    dive      # explore Docker image layers
    podman
    podman-compose
    trivy     # vulnerability scanner for containers

    # Documents
    zathura

    # Media processing
    audacity  # audio editing
    ffmpeg    # video/audio conversion and processing
    imagemagick # batch image manipulation

    # Game development
    aseprite  # pixel art editor
    krita     # digital painting for game assets

    # CLI essentials
    eza       # modern ls with git status and icons

    # System utilities
    fastfetch
    screenkey
    godot
    libsecret
  ];
}
