# scala-tools — build tools for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.scala.sbt.enable = true;  # default: false
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.scala;
in
{
  options.languages.scala = {
    sbt = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include sbt.";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    environment.packages = lib.optional cfg.sbt.enable pkgs.sbt;
  };
}
