# System-wide oxipng configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.oxipng;
in

{
  options.programs.oxipng = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install oxipng system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.oxipng;
      description = "oxipng package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
