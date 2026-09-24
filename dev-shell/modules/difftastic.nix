# difftastic — structural diff tool for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   difftastic.enable = true;
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.difftastic;
in
{
  options.difftastic = {
    enable = lib.mkEnableOption "difftastic as the git diff tool";
  };

  config = lib.mkIf cfg.enable {
    environment.packages = [ pkgs.difftastic ];
    environment.variables.GIT_EXTERNAL_DIFF = "difft";
  };
}
