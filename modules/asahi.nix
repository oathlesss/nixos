{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.apple-silicon.overlays.apple-silicon-overlay
  ];
}
