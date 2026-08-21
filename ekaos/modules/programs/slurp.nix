# System-wide slurp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.slurp;
in

{
  options.programs.slurp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install slurp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.slurp;
      description = "slurp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
