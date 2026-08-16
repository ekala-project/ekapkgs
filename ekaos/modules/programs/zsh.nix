# System-wide zsh shell configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zsh;
in

{
  options.programs.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install zsh system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = "zsh package to use.";
    };

    interactiveShellInit = mkOption {
      type = types.lines;
      default = "";
      description = "zsh interactive init commands.";
    };

    promptInit = mkOption {
      type = types.lines;
      default = "";
      description = "zsh prompt initialization.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.package ];
    }

    (mkIf (cfg.interactiveShellInit != "") {
      environment.etc."zsh/zshrc.local".text = cfg.interactiveShellInit;
    })

    (mkIf (cfg.promptInit != "") {
      environment.etc."zsh/zprofile.local".text = cfg.promptInit;
    })
  ]);
}
