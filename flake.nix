{
  description = "Ekapkgs flake";

  inputs = {
    corepkgs.url = "github:ekala-project/corepkgs";
    cuda.url = "github:ekala-project/cuda-pkgs";
    cuda.flake = false;
    haskell.url = "github:ekala-project/haskell-pkgs";
    haskell.flake = false;
    nix-lib.follows = "corepkgs/nix-lib";
    python.url = "github:ekala-project/python-pkgs";
    python.flake = false;
    r-pkgs.url = "github:ekala-project/r-pkgs";
    r-pkgs.flake = false;
    systems.follows = "corepkgs/systems";
  };

  outputs =
    {
      corepkgs,
      nix-lib,
      self,
      systems,
      ...
    }:
    let
      forAllSystems = nix-lib.lib.genAttrs (import systems);
      pkgsModule = import ./pkgs-module.nix;
    in
    {
      legacyPackages = forAllSystems (
        system:
        import ./. {
          inherit system;
          modules = [ pkgsModule ];
        }
      );

      ekaosSystem =
        {
          modules ? [ ],
          system ? "x86_64-linux",
          config ? { },
          ...
        }@args:
        let
          pkgs = import ./. {
            inherit system config;
            modules = [ pkgsModule ];
          };
          ekapkgsModules = import ./ekaos/modules/module-list.nix;
          extraArgs = builtins.removeAttrs args [
            "modules"
            "system"
            "config"
          ];
          eval =
            (import (corepkgs + "/ekaos/eval-config.nix") {
              lib = pkgs.lib;
              inherit pkgs;
            })
              (
                {
                  modules = ekapkgsModules ++ modules;
                }
                // extraArgs
              );
        in
        eval;

      ekaosConfigurations.jonringer = self.ekaosSystem {
        system = "x86_64-linux";
        config.allowUnfree = true;
        modules = [ ./ekaos/configuration.nix ];
      };

      formatter = corepkgs.formatter;
      nixConfig = {
        extra-substituters = [ "https://ekala-corepkgs.cachix.org" ];
        extra-trusted-public-keys = [
          "ekala-corepkgs.cachix.org-1:DcZV+vegWoEzacbSdXFXU4S7728C0eS9RfGpKeyHd6w="
        ];
      };
    };
}
