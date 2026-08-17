# System-wide aws-c-s3 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aws-c-s3;
in

{
  options.programs.aws-c-s3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aws-c-s3 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aws-c-s3;
      description = "aws-c-s3 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
