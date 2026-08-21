# System-wide rush configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rush;

  indent =
    text:
    concatStringsSep "\n" (map (line: "  " + line) (filter (line: line != "") (splitString "\n" text)));

  rushrcText = concatStringsSep "\n\n" (
    filter (s: s != "") [
      "rush 2.0"
      (optionalString (cfg.global != "") "global\n${indent cfg.global}")
      (concatStringsSep "\n\n" (
        mapAttrsToList (name: content: "rule ${name}\n${indent content}") cfg.rules
      ))
    ]
  );
in

{
  options.programs.rush = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable rush restricted shell.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rush;
      description = "rush package to use.";
    };

    global = mkOption {
      type = types.lines;
      default = "";
      description = "Global configuration section for rush.rc.";
    };

    rules = mkOption {
      type = types.attrsOf types.lines;
      default = { };
      description = "Named rule configurations for rush.rc.";
      example = literalExpression ''
        {
          default = '''
            command = /bin/sh
          ''';
        }
      '';
    };

    wrap = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the setuid wrapper for rush.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."rush.rc".text = rushrcText;

    security.wrappers.rush = mkIf cfg.wrap {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/rush";
    };
  };
}
