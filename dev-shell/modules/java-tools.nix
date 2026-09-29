# java-tools — build tools for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.java.maven.enable = true;   # default: false
#   languages.java.gradle.enable = true;  # default: false
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.java;
in
{
  options.languages.java = {
    maven = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include Maven.";
      };
    };

    gradle = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include Gradle.";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    environment.packages =
      lib.optional cfg.maven.enable pkgs.maven ++ lib.optional cfg.gradle.enable pkgs.gradle;
  };
}
