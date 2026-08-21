# System-wide hey configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hey;
in

{
  options.programs.hey = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hey system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hey;
      description = "hey package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
