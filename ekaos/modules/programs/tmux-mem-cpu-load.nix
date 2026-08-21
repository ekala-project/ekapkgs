# System-wide tmux-mem-cpu-load configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tmux-mem-cpu-load;
in

{
  options.programs.tmux-mem-cpu-load = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tmux-mem-cpu-load system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tmux-mem-cpu-load;
      description = "tmux-mem-cpu-load package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
