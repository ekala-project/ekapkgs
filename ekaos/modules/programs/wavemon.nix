# System-wide wavemon configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wavemon;
in

{
  options.programs.wavemon = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wavemon system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wavemon;
      description = "wavemon package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
