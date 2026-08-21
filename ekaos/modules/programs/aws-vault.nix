# System-wide aws-vault configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aws-vault;
in

{
  options.programs.aws-vault = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aws-vault system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aws-vault;
      description = "aws-vault package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
