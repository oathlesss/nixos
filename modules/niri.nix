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
  # loglevel=3: only show severity < 3 (EMERG/ALERT/CRIT); ERR-level Asahi driver errors are silenced
  boot.kernelParams = [ "console=tty2" "quiet" "loglevel=1" ];

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
