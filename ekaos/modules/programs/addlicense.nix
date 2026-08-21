# System-wide addlicense configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.addlicense;
in

{
  options.programs.addlicense = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install addlicense system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.addlicense;
      description = "addlicense package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
