# System-wide tack configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tack;
in

{
  options.programs.tack = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tack system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tack;
      description = "tack package to use.";
    };

    nixConfTokens = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable tack reading access tokens from nix.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables = mkIf cfg.nixConfTokens {
      TACK_NIX_CONF_TOKENS = "1";
    };
  };
}
