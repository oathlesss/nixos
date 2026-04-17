{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting

        if status is-interactive
          and not set -q TMUX
          exec tmux new-session -A -s main
        end

        bind \cf 'tmux neww tmux-sessionizer'
        fastfetch

        fnm env --use-on-cd --shell fish | source
        set -gx NH_FLAKE /home/ruben/nixos
      '';
      shellAbbrs = {
        lzg     = "lazygit";
        lzd     = "lazydocker";
        rebuild = "nh os switch --hostname asahi -- --impure";
        hrebuild = "home-manager switch -b backup --impure --flake /home/ruben/nixos#ruben";
        k       = "kubectl";
        kctx    = "kubectx";
        kns     = "kubens";
      };
      shellInit = ''
        alias kubectl="kubecolor"
        alias cat="bat"
        alias ls="eza --icons"
        alias ll="eza -l --icons --git"
        alias la="eza -la --icons --git"
        alias lt="eza --tree --icons"
      '';
      plugins = with pkgs.fishPlugins; [
        { name = "fzf-fish"; inherit (fzf-fish) src; }
        { name = "autopair"; inherit (autopair) src; }
        { name = "done"; inherit (done) src; }
        { name = "sponge"; inherit (sponge) src; }
        { name = "bass"; inherit (bass) src; }
        { name = "colored-man-pages"; inherit (colored-man-pages) src; }
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    tmux = {
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
        set -ag terminal-overrides ",alacritty:RGB"
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
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "basic"
            set -g @catppuccin_window_text "#{pane_current_command}"
            set -g @catppuccin_window_current_text "#{pane_current_command}"
            set -g @catppuccin_status_left_separator ""
            set -g @catppuccin_status_right_separator ""
            set -g status-left "#{E:@catppuccin_status_session}"
            set -g status-right "#{E:@catppuccin_status_directory}"
            set -g status-left-length 100
            set -g status-right-length 100
          '';
        }
      ];
    };
  };

  home.packages = [
    (pkgs.writeTextFile {
      name = "tmux-sessionizer";
      destination = "/bin/tmux-sessionizer";
      executable = true;
      text = builtins.readFile ../scripts/tmux-sessionizer.fish;
    })
  ];
}
