{ config, ... }:
{
  xdg = {
    configFile = {
      "noctalia/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/noctalia/settings.json";
      "noctalia/colors.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/noctalia/colors.json";
      "noctalia/plugins.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/noctalia/plugins.json";
    };
  };
}
