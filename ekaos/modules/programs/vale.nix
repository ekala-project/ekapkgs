# System-wide vale configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.vale;
in

{
  options.programs.vale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install vale system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vale;
      description = "vale package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
