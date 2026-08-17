# System-wide autojump configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autojump;
in

{
  options.programs.autojump = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autojump system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autojump;
      description = "autojump package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
