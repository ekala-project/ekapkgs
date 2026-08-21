# System-wide memtester configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.memtester;
in

{
  options.programs.memtester = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install memtester system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.memtester;
      description = "memtester package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
