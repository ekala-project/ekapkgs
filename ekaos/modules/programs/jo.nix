# System-wide jo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.jo;
in

{
  options.programs.jo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install jo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.jo;
      description = "jo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
