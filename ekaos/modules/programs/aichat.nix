# System-wide aichat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aichat;
in

{
  options.programs.aichat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aichat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aichat;
      description = "aichat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
