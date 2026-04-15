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
        alias ls="eza"
        alias ll="eza -l"
        alias la="eza -la"
        alias lt="eza --tree"
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
