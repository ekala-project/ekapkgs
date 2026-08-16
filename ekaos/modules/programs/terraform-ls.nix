# System-wide terraform-ls configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.terraform-ls;
in

{
  options.programs.terraform-ls = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install terraform-ls system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.terraform-ls;
      description = "terraform-ls package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
