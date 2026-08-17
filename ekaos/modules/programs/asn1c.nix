# System-wide asn1c configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asn1c;
in

{
  options.programs.asn1c = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asn1c system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asn1c;
      description = "asn1c package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
