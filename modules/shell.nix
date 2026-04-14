{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting

      if status is-interactive
        and not set -q TMUX
        fastfetch
        exec tmux new-session -A -s main
      end

      bind \cf 'tmux neww tmux-sessionizer'

      fnm env --use-on-cd --shell fish | source
      set -gx NH_FLAKE /home/ruben/nixos
    '';
    shellAbbrs = {
      lzg     = "lazygit";
      lzd     = "lazydocker";
      rebuild = "nh os switch --hostname asahi -- --impure";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    terminal = "tmux-256color";
    extraConfig = ''
      set -g window-style 'bg=default'
      set -g window-active-style 'bg=default'
    '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
  };

  home.packages = [
    (pkgs.writeTextFile {
      name = "tmux-sessionizer";
      destination = "/bin/tmux-sessionizer";
      executable = true;
      text = builtins.readFile ../scripts/tmux-sessionizer.fish;
    })
    (pkgs.writeTextFile {
      name = "slack";
      destination = "/bin/slack";
      executable = true;
      text = builtins.readFile ../scripts/slack.fish;
    })
  ];
}
