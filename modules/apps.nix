{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    brave
    obsidian
    xwayland-satellite
    grim
    slurp
    wl-clipboard
    inputs.noctalia.packages.aarch64-linux.default
    libsecret
    claude-code
    opencode
    codex
    viu
    bash-language-server
    vscode-langservers-extracted
    docker-language-server
    emmet-language-server
    lua
    lua-language-server
    (pkgs.writeShellScriptBin "python3" ''exec ${pkgs.python3}/bin/python3 "$@"'')
    (pkgs.writeShellScriptBin "python3.11" ''exec ${pkgs.python311}/bin/python3.11 "$@"'')
    (pkgs.writeShellScriptBin "python3.12" ''exec ${pkgs.python312}/bin/python3.12 "$@"'')
    (pkgs.writeShellScriptBin "python3.13" ''exec ${pkgs.python313}/bin/python3.13 "$@"'')
    (pkgs.writeShellScriptBin "python3.14" ''exec ${pkgs.python314}/bin/python3.14 "$@"'')
    ruff
    (ty.overrideAttrs (old: {
      env = (old.env or {}) // { JEMALLOC_SYS_WITH_LG_PAGE = "14"; };
    }))
    pyrefly
    zuban
    uv
    taplo
    vtsls
    yaml-language-server
    fnm
    rustup
    go
    godot
    zellij
    zed
    zig
    fastfetch
    jujutsu
    lazyssh
    lazygit
    lazydocker
    lazysql
    lazyjournal
    gnumake
    just
    swaylock
    obs-studio
    yazi
    nautilus
    playerctl
    wev
    swayidle
    marksman
    nix-output-monitor
    nh
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
    widevine-cdm
  ];
}
