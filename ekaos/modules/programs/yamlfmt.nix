# System-wide yamlfmt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.yamlfmt;
in

{
  options.programs.yamlfmt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install yamlfmt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.yamlfmt;
      description = "yamlfmt package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
