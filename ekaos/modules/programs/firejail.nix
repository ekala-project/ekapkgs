# System-wide firejail configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.firejail;

  wrappedBins =
    pkgs.runCommand "firejail-wrapped-binaries"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1;
      }
      ''
        mkdir -p $out/bin
        ${concatStringsSep "\n" (
          mapAttrsToList (name: executable: ''
            cat > $out/bin/${name} <<'WRAPPER'
            #!/bin/sh
            exec /run/wrappers/bin/firejail -- ${executable} "$@"
            WRAPPER
            chmod 0755 $out/bin/${name}
          '') cfg.wrappedBinaries
        )}
      '';
in

{
  options.programs.firejail = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable firejail sandboxing.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.firejail;
      description = "firejail package to use.";
    };

    wrappedBinaries = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Map of command names to executable paths to wrap with firejail.
        Each entry creates a wrapper script that invokes the executable
        through firejail.
      '';
      example = literalExpression ''
        {
          firefox = "''${pkgs.firefox}/bin/firefox";
          mpv = "''${pkgs.mpv}/bin/mpv";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.firejail = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/firejail";
    };

    environment.systemPackages = [ cfg.package ] ++ optional (cfg.wrappedBinaries != { }) wrappedBins;
  };
}
