# System-wide sing-box configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sing-box;
in

{
  options.programs.sing-box = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sing-box system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sing-box;
      description = "sing-box package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
