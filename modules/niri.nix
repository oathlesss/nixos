{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.bash}/bin/bash -c '
            sleep 2
            ${pkgs.ncurses}/bin/clear
            exec ${pkgs.tuigreet}/bin/tuigreet \
              --time \
              --remember \
              --remember-user-session \
              --asterisks \
              --greeting "Welcome, Ruben" \
              --cmd "dbus-run-session niri-session"
          '
        '';
        user = "greeter";
      };
    };
  };

  # Suppress kernel log spam on tuigreet TTY
  boot.kernelParams = [ "console=tty2" ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.niri.default = [ "wlr" "gtk" ];
    config.common.default = [ "gtk" ];
  };
}
