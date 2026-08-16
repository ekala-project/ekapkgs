# System-wide peco configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.peco;
in

{
  options.programs.peco = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install peco system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.peco;
      description = "peco package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
