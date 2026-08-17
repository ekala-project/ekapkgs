# System-wide amfora configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.amfora;
in

{
  options.programs.amfora = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install amfora system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.amfora;
      description = "amfora package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
