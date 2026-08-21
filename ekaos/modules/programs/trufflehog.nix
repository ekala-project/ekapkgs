# System-wide trufflehog configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.trufflehog;
in

{
  options.programs.trufflehog = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install trufflehog system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.trufflehog;
      description = "trufflehog package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
