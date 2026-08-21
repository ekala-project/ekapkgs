# System-wide rust-script configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rust-script;
in

{
  options.programs.rust-script = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rust-script system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rust-script;
      description = "rust-script package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
