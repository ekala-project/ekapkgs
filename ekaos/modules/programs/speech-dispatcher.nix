# speech-dispatcher — speech synthesis interface
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.speech-dispatcher;
in

{
  options.programs.speech-dispatcher = {
    enable = mkEnableOption "speech-dispatcher, a speech synthesis interface";

    package = mkOption {
      type = types.package;
      default = pkgs.speech-dispatcher;
      description = "speech-dispatcher package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
