# System-wide chezmoi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.chezmoi;
in

{
  options.programs.chezmoi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install chezmoi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.chezmoi;
      description = "chezmoi package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
