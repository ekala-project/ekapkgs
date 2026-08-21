# System-wide apfs-fuse configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apfs-fuse;
in

{
  options.programs.apfs-fuse = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apfs-fuse system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apfs-fuse;
      description = "apfs-fuse package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
