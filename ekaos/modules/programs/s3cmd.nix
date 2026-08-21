# System-wide s3cmd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.s3cmd;
in

{
  options.programs.s3cmd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install s3cmd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.s3cmd;
      description = "s3cmd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
