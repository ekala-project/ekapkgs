# System-wide amdgpu_top configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.amdgpu_top;
in

{
  options.programs.amdgpu_top = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install amdgpu_top system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.amdgpu_top;
      description = "amdgpu_top package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
