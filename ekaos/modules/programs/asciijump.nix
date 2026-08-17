# System-wide asciijump configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asciijump;
in

{
  options.programs.asciijump = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asciijump system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asciijump;
      description = "asciijump package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
