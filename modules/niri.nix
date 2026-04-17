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
        command =
          let
            theme = "border=#cba6f7;text=#cdd6f4;prompt=#89b4fa;time=#a6adc8;action=#6c7086;button=#cba6f7;container=#181825;title=#b4befe;greet=#cdd6f4;input=#cdd6f4";
          in
          ''
            ${pkgs.bash}/bin/bash -c "
              sleep 2
              ${pkgs.ncurses}/bin/clear
              exec ${pkgs.tuigreet}/bin/tuigreet \
                --time \
                --remember \
                --remember-user-session \
                --asterisks \
                --greeting 'Welcome, Ruben' \
                --cmd 'dbus-run-session niri-session' \
                --theme '${theme}'
            "
          '';
        user = "greeter";
      };
    };
  };

  # Suppress kernel log spam on tuigreet TTY
  # apple-silicon module adds console=tty0 (active-VT mux), so messages always reach the active TTY.
  # NixOS appends loglevel=${boot.consoleLogLevel} last, overriding any loglevel= in boot.kernelParams.
  # Setting boot.consoleLogLevel = 1 wins: only EMERG (0) reaches the console.
  boot.consoleLogLevel = 1;
  boot.kernelParams = [ "console=tty2" "quiet" ];

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
