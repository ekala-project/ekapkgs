# System-wide acpi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.acpi;
in

{
  options.programs.acpi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install acpi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.acpi;
      description = "acpi package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
