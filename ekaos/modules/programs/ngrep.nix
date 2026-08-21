# System-wide ngrep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ngrep;
in

{
  options.programs.ngrep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ngrep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ngrep;
      description = "ngrep package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
