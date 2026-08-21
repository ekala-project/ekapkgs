# System-wide git-interactive-rebase-tool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.git-interactive-rebase-tool;
in

{
  options.programs.git-interactive-rebase-tool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install git-interactive-rebase-tool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git-interactive-rebase-tool;
      description = "git-interactive-rebase-tool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
