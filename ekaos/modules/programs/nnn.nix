# System-wide nnn configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nnn;
in

{
  options.programs.nnn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nnn system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nnn;
      description = "nnn package to use.";
    };

    plugins = mkOption {
      type = types.str;
      default = "";
      description = "Colon-separated plugin list for NNN_PLUG.";
    };

    bookmarks = mkOption {
      type = types.str;
      default = "";
      description = "Bookmarks for NNN_BMS.";
    };

    extraFlags = mkOption {
      type = types.str;
      default = "";
      description = "Default flags for NNN_OPTS.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables = mkMerge [
      (mkIf (cfg.plugins != "") { NNN_PLUG = cfg.plugins; })
      (mkIf (cfg.bookmarks != "") { NNN_BMS = cfg.bookmarks; })
      (mkIf (cfg.extraFlags != "") { NNN_OPTS = cfg.extraFlags; })
    ];
  };
}
