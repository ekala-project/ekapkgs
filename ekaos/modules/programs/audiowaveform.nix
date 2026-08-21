# System-wide audiowaveform configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.audiowaveform;
in

{
  options.programs.audiowaveform = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install audiowaveform system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.audiowaveform;
      description = "audiowaveform package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
