# System-wide Elvish shell configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.elvish;
in

{
  options.programs.elvish = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Elvish system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.elvish;
      description = "Elvish package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
