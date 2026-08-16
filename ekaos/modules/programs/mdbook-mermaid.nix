# System-wide mdbook-mermaid configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mdbook-mermaid;
in

{
  options.programs.mdbook-mermaid = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mdbook-mermaid system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mdbook-mermaid;
      description = "mdbook-mermaid package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
