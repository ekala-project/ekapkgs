# System-wide mdbook-toc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mdbook-toc;
in

{
  options.programs.mdbook-toc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mdbook-toc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mdbook-toc;
      description = "mdbook-toc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
