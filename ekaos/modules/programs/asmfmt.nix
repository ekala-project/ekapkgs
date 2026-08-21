# System-wide asmfmt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asmfmt;
in

{
  options.programs.asmfmt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asmfmt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asmfmt;
      description = "asmfmt package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
