# System-wide age-plugin-yubikey configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.age-plugin-yubikey;
in

{
  options.programs.age-plugin-yubikey = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install age-plugin-yubikey system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.age-plugin-yubikey;
      description = "age-plugin-yubikey package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
