# System-wide noisetorch configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.noisetorch;
in

{
  options.programs.noisetorch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable noisetorch with cap_sys_resource capability.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.noisetorch;
      description = "noisetorch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.noisetorch = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_resource=+ep";
      source = "${cfg.package}/bin/noisetorch";
    };
  };
}
