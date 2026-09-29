# delta — syntax-highlighting pager for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   delta.enable = true;
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.delta;
in
{
  options.delta = {
    enable = lib.mkEnableOption "delta as the git pager";
  };

  config = lib.mkIf cfg.enable {
    environment.packages = [ pkgs.delta ];
    environment.variables.GIT_PAGER = "delta";
  };
}
