# System-wide bazelisk configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bazelisk;
in

{
  options.programs.bazelisk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bazelisk system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bazelisk;
      description = "bazelisk package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
