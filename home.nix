{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./modules/apps.nix
    ./modules/noctalia.nix
    ./modules/shell.nix
    ./modules/swaylock.nix
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
        pkgs.libnotify
        (pkgs.writeShellScriptBin "vpn-toggle" ''
          CONNECTION="office"

          if nmcli con show --active | grep -q "$CONNECTION"; then
            nmcli con down "$CONNECTION"
            notify-send "VPN" "Office VPN disconnected"
          else
            nmcli con up "$CONNECTION"
            notify-send "VPN" "Office VPN connected"
          fi
        '')
      ];
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      NIXOS_OZONE_WL = "1";
      UV_PYTHON_DOWNLOADS = "never";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk4.theme = null;
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
      extraPackages = [ pkgs.gcc ];
    };

    fzf.enable = true;

    chromium = {
      enable = true;
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--disable-features=VaapiVideoEncoder,VaapiVideoDecoder"
        "--disable-accelerated-video-decode"
        "--disable-accelerated-video-encode"
      ];
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-devedition.overrideAttrs (old: {
        buildCommand =
          old.buildCommand
          + ''
            mkdir -p "$out/gmp-widevinecdm/system-installed"
            ln -s "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json" \
              "$out/gmp-widevinecdm/system-installed/manifest.json"
            ln -s "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so" \
              "$out/gmp-widevinecdm/system-installed/libwidevinecdm.so"
            wrapProgram "$oldExe" --set MOZ_GMP_PATH "$out/gmp-widevinecdm/system-installed"
          '';
      });
    };

    ghostty = {
      enable = true;
      settings = {
        font-family = "BerkeleyMono Nerd Font";
        font-size = 13;
        window-decoration = false;
        window-padding-x = 10;
        window-padding-y = 10;
        background-opacity = 0.92;
        # Catppuccin Mocha
        background = "1e1e2e";
        foreground = "cdd6f4";
        cursor-color = "f5e0dc";
        cursor-text = "1e1e2e";
        selection-background = "585b70";
        selection-foreground = "cdd6f4";
        palette = [
          "0=#45475a"
          "1=#f38ba8"
          "2=#a6e3a1"
          "3=#f9e2af"
          "4=#89b4fa"
          "5=#f5c2e7"
          "6=#94e2d5"
          "7=#a6adc8"
          "8=#585b70"
          "9=#f37799"
          "10=#89d88b"
          "11=#ebd391"
          "12=#74a8fc"
          "13=#f2aede"
          "14=#6bd7ca"
          "15=#bac2de"
        ];
      };
    };

    alacritty = {
      enable = true;
      settings = {
        general.import = [ "~/.config/alacritty/themes/noctalia.toml" ];
        window = {
          padding = { x = 10; y = 10; };
          decorations = "None";
          opacity = 0.92;
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
      ignores = [ "**/.claude/settings.local.json" ".direnv/" ];
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

  # Transcode FaceTime HD NV12 → MJPEG so Chromium's WebRTC handles it correctly on ARM64
  systemd.user.services.virtual-camera = {
    Unit = {
      Description = "FaceTime HD NV12→MJPEG virtual camera for Chromium WebRTC";
      After = [ "basic.target" ];
      ConditionPathExists = "/dev/video0";
    };
    Service = {
      ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg -f v4l2 -input_format nv12 -video_size 1280x720 -framerate 30 -i /dev/video0 -f v4l2 -vcodec mjpeg -q:v 5 /dev/video10";
      Restart = "on-failure";
      RestartSec = "3";
    };
    Install.WantedBy = [ "default.target" ];
  };

  xdg = {
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
