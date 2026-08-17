# System-wide asciidoctorj configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asciidoctorj;
in

{
  options.programs.asciidoctorj = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asciidoctorj system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asciidoctorj;
      description = "asciidoctorj package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
