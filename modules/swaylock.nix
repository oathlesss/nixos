{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Live screenshot with blur + vignette
      screenshots = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";

      # Ring indicator — mauve primary, blue verifying, red wrong, green clear
      ring-color = "cba6f7";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "f38ba8";
      ring-clear-color = "a6e3a1";

      # Inside circle — always Catppuccin base
      inside-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      inside-clear-color = "1e1e2e";

      # Text on indicator
      text-color = "cdd6f4";
      text-ver-color = "89b4fa";
      text-wrong-color = "f38ba8";
      text-clear-color = "a6e3a1";

      # Separator + outer line — transparent
      separator-color = "00000000";
      line-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      line-clear-color = "00000000";

      # Key highlight
      key-hl-color = "cba6f7";
      bs-hl-color = "f38ba8";

      # Font + indicator geometry
      font = "BerkeleyMono Nerd Font";
      font-size = 16;
      indicator-radius = 100;
      indicator-thickness = 7;

      # Clock
      clock = true;
      timestr = "%H:%M";
      datestr = "%a, %d %B";

      # Misc
      ignore-empty-password = true;
      show-failed-attempts = true;
      fade-in = "0.2";
    };
  };
}
