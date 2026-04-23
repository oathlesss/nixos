{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Creative / game development
    aseprite # pixel art editor
    (blender.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ sse2neon ];
    }))
    gimp
    godot
    krita # digital painting for game assets

    # Video / audio
    audacity # audio editing
    ffmpeg # video/audio conversion and processing
    kdePackages.kdenlive
    obs-studio

    # Image processing
    imagemagick # batch image manipulation
    loupe
    viu

    # Media control
    playerctl
  ];
}
