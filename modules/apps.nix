{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    (blender.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ sse2neon ];
    }))

    # Desktop / Wayland
    evolution
    grim
    nautilus
    obs-studio
    slurp
    wev
    widevine-cdm
    wl-clipboard
    xwayland-satellite
    (inputs.noctalia.packages.aarch64-linux.default.override { calendarSupport = true; })

    # Media
    gimp
    kdePackages.kdenlive
    libreoffice
    loupe
    playerctl
    viu

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
    go
    lua
    python3
    rustup
    zig

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
    duckdb
    pgcli
    postgresql

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

    # Diagrams
    d2

    # Game development
    aseprite  # pixel art editor
    godot
    krita     # digital painting for game assets

    # System utilities
    eza       # modern ls with git status and icons
    fastfetch
    libsecret
    screenkey
  ];
}
