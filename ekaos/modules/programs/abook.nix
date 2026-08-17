# System-wide abook configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.abook;
in

{
  options.programs.abook = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install abook system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.abook;
      description = "abook package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
