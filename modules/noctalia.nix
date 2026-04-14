{ lib, ... }:
let
  noctaliaConfigDir = "/home/ruben/nixos/config/noctalia";
in
{
  home.activation.deployNoctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/noctalia"
    ln -sf ${noctaliaConfigDir}/settings.json "$HOME/.config/noctalia/settings.json"
    ln -sf ${noctaliaConfigDir}/colors.json   "$HOME/.config/noctalia/colors.json"
    ln -sf ${noctaliaConfigDir}/plugins.json  "$HOME/.config/noctalia/plugins.json"
  '';
}
