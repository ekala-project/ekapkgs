# System-wide aws-iam-authenticator configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aws-iam-authenticator;
in

{
  options.programs.aws-iam-authenticator = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aws-iam-authenticator system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aws-iam-authenticator;
      description = "aws-iam-authenticator package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
