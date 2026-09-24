# starship — cross-shell prompt customization for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   starship.enable = true;
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.starship;
in
{
  options.starship = {
    enable = lib.mkEnableOption "the Starship cross-shell prompt";
  };

  config = lib.mkIf cfg.enable {
    environment.packages = [ pkgs.starship ];
  };
}
