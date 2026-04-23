{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Languages & runtimes
    go
    lua
    nodejs
    python3
    rustup
    zig

    # Python tooling
    pyrefly
    ruff
    uv
    zuban
    (ty.overrideAttrs (old: {
      env = (old.env or { }) // {
        JEMALLOC_SYS_WITH_LG_PAGE = "14";
      };
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

    # Build tools
    gnumake
    just

    # Version control
    gitleaks
    jujutsu
    lazygit
    onefetch

    # Editors / IDEs
    zed
    yazi

    # AI / code assistants
    claude-code
    codex
    opencode

    # Database
    beekeeper-studio
    duckdb
    pgcli
    postgresql

    # Web development
    gh # GitHub CLI
    xh # HTTP client
    mkcert # local HTTPS certificates
    act # run GitHub Actions locally
    tokei # count lines of code by language
    bruno # open-source API client (Postman alternative)

    # Diagrams
    d2
  ];
}
