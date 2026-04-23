{ pkgs, ... }:
{
  home.packages = with pkgs; [
    comma # run any nix binary without installing: ,ffprobe
    deadnix
    nix-index # nix-locate: find which package provides a file
    nixfmt-rfc-style
    nh
    nix-output-monitor
    statix
  ];
}
