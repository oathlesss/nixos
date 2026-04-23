{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # Wayland / desktop
    evolution
    grim
    nautilus
    slurp
    wev
    widevine-cdm
    wl-clipboard
    xwayland-satellite
    (inputs.noctalia.packages.aarch64-linux.default.override { calendarSupport = true; })

    # Productivity / notes
    libreoffice
    obsidian

    # Documents & reference
    zathura
    zeal

    # CLI essentials
    bat # cat with syntax highlighting
    delta # git diff pager
    dust # intuitive du replacement
    duf # pretty df replacement
    eza # modern ls with git status and icons
    fastfetch
    fd # fast find replacement
    jq # JSON processor
    libsecret
    navi # interactive cheatsheet
    procs # ps replacement
    ripgrep # fast grep
    screenkey
    tealdeer # fast tldr pages
    tree-sitter # tree-sitter CLI
    yq # jq for YAML/TOML/XML

    # System monitoring
    bottom # htop with graphs

    # TUI dashboards
    lazyjournal
    lazysql
    lazyssh
  ];
}
