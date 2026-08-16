# System-wide rustscan configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rustscan;
in

{
  options.programs.rustscan = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rustscan system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rustscan;
      description = "rustscan package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
