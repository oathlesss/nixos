{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./modules/apps.nix
    ./modules/noctalia.nix
    ./modules/shell.nix
  ];

  home = {
    username = "ruben";
    homeDirectory = "/home/ruben";
    stateVersion = "25.05";
    packages =
      let
        fontDir = "/home/ruben/nixos/fonts/berkeley-mono-nerd";
        parentDir = builtins.dirOf fontDir;
        canInspectParent = (builtins.tryEval (builtins.readDir parentDir)).success;
        fontDirExists = canInspectParent && builtins.pathExists fontDir;
        hasTtf =
          if fontDirExists
          then builtins.any (name: lib.hasSuffix ".ttf" name) (builtins.attrNames (builtins.readDir fontDir))
          else false;
      in
      (if hasTtf
      then [
        (let
          fontDirPath = builtins.path { path = fontDir; name = "berkeley-mono-nerd"; };
        in
          pkgs.runCommandLocal "berkeley-mono-nerd-font" {} ''
            mkdir -p $out/share/fonts/truetype
            cp ${fontDirPath}/*.ttf $out/share/fonts/truetype/
          '')
      ]
      else if canInspectParent
      then lib.warn "BerkeleyMono Nerd Font not found at ${fontDir} — skipping font install. Patch and copy TTFs there to enable it." []
      else [])
      ++ [
        inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
      ];
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      NIXOS_OZONE_WL = "1";
      UV_PYTHON_DOWNLOADS = "never";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };

  programs = {
    home-manager.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;
    };

    fzf.enable = true;

    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };

    alacritty = {
      enable = true;
      settings = {
        general.import = [ "~/.config/alacritty/themes/noctalia.toml" ];
        window = {
          padding = { x = 10; y = 10; };
          decorations = "None";
        };
        font = {
          size = 13;
          normal = { family = "BerkeleyMono Nerd Font"; style = "Regular"; };
          bold = { family = "BerkeleyMono Nerd Font"; style = "Bold"; };
          italic = { family = "BerkeleyMono Nerd Font"; style = "Oblique"; };
          bold_italic = { family = "BerkeleyMono Nerd Font"; style = "Bold Oblique"; };
        };
      };
    };

    foot = {
      enable = true;
      settings = {
        main = {
          font = "BerkeleyMono Nerd Font:size=13";
        };
        colors = {
          background = "1e1e2e";
          foreground = "cdd6f4";
          regular0 = "45475a";
          regular1 = "f38ba8";
          regular2 = "a6e3a1";
          regular3 = "f9e2af";
          regular4 = "89b4fa";
          regular5 = "f5c2e7";
          regular6 = "94e2d5";
          regular7 = "a6adc8";
          bright0 = "585b70";
          bright1 = "f37799";
          bright2 = "89d88b";
          bright3 = "ebd391";
          bright4 = "74a8fc";
          bright5 = "f2aede";
          bright6 = "6bd7ca";
          bright7 = "bac2de";
        };
        cursor = {
          color = "1e1e2e f5e0dc";
        };
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".extraOptions.IdentityAgent = "~/.1password/agent.sock";
    };

    git = {
      enable = true;
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZuQHRq2R8+AwS2vlglQjyCfkBRfZ/iNFs9WHoTE9ii";
        format = "ssh";
        signByDefault = true;
      };
      ignores = [ "**/.claude/settings.local.json" ];
      includes = [{ condition = "gitdir:~/work/"; path = "~/.config/git/work"; }];
      settings = {
        user = {
          name = "Ruben Hesselink";
          email = "rubenhesselink@outlook.com";
        };
        alias = {
          lg    = "log --oneline --graph --decorate";
          lga   = "log --oneline --graph --decorate --all";
          st    = "status";
          d     = "diff";
          ds    = "diff --staged";
          br    = "branch";
          co    = "checkout";
          sw    = "switch";
          undo  = "reset HEAD~1 --mixed";
          sl    = "stash list";
          sp    = "stash pop";
          amend = "commit --amend --no-edit";
          pushf = "push --force-with-lease";
          who   = "shortlog -sn --no-merges";
        };
        gpg.ssh.program = "/run/current-system/sw/bin/op-ssh-sign";
        commit.template = "~/.config/git/template";
        core = {
          autocrlf = "input";
          compression = 9;
          fsync = "none";
          whitespace = "error";
        };
        advice = {
          addEmptyPathspec = false;
          pushNonFastForward = false;
          statusHints = false;
        };
        blame = {
          coloring = "highlightRecent";
          date = "relative";
        };
        diff = {
          context = 3;
          renames = "copies";
          interHunkContext = 10;
        };
        difftool.prompt = false;
        init.defaultBranch = "main";
        log = {
          abbrevCommit = true;
          graphColors = "blue,yellow,cyan,magenta,green,red";
        };
        status = {
          branch = true;
          short = true;
          showStash = true;
          showUntrackedFiles = "all";
        };
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
        };
        pager.branch = false;
        push = {
          autoSetupRemote = true;
          default = "current";
          followTags = true;
        };
        pull.rebase = true;
        submodule.fetchJobs = 16;
        rebase.autoStash = true;
        "color \"blame\"".highlightRecent = "black bold,1 year ago,white,1 month ago,default,7 days ago,blue";
        "color \"branch\"" = {
          current = "magenta";
          local = "default";
          remote = "yellow";
          upstream = "green";
          plain = "blue";
        };
        "color \"diff\"" = {
          meta = "black bold";
          frag = "magenta";
          context = "white";
          whitespace = "yellow reverse";
        };
        interactive.singlekey = true;
        "url \"git@github.com:\"".insteadOf = "gh:";
      };
    };
  };

  xdg = {
    desktopEntries.slack-app = {
      name = "Slack";
      exec = "slack";
      icon = "slack";
      categories = [ "Network" "InstantMessaging" ];
      comment = "Slack (Firefox app mode)";
    };

    configFile = {
      "git/template".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/git/template";
      "git/work".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/git/work";
      "nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/nvim";
      "niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/niri/config.kdl";
      "niri/noctalia.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/niri/noctalia.kdl";
      "alacritty/themes/noctalia.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/alacritty/themes/noctalia.toml";
    };
  };
}
