{
  description = "Ekapkgs flake";

  inputs = {
    corepkgs.url = "github:ekala-project/corepkgs";
    cuda.url = "github:ekala-project/cuda-pkgs";
    cuda.flake = false;
    haskell.url = "github:ekala-project/haskell-pkgs";
    haskell.flake = false;
    nix-lib.follows = "corepkgs/nix-lib";
    treefmt-nix.follows = "corepkgs/treefmt-nix";
    python.url = "github:ekala-project/python-pkgs";
    python.flake = false;
    r-pkgs.url = "github:ekala-project/r-pkgs";
    r-pkgs.flake = false;
    vim-plugins.url = "github:ekala-project/vim-plugins";
    vim-plugins.flake = false;
    systems.follows = "corepkgs/systems";
  };

  outputs =
    {
      corepkgs,
      nix-lib,
      self,
      systems,
      treefmt-nix,
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

      # ISO images
      packages.x86_64-linux =
        let
          pkgs = self.legacyPackages.x86_64-linux;
          evalIso =
            configuration:
            import ./ekaos {
              system = "x86_64-linux";
              inherit pkgs;
              lib = pkgs.lib;
              configuration = configuration;
            };
        in
        {
          iso-gnome = (evalIso (
            import ./ekaos/modules/installer/installation-cd-graphical-gnome.nix
          )).config.system.build.isoImage;
        };

      packages.aarch64-linux =
        let
          pkgs = self.legacyPackages.aarch64-linux;
          evalIso =
            configuration:
            import ./ekaos {
              system = "aarch64-linux";
              inherit pkgs;
              lib = pkgs.lib;
              configuration = configuration;
            };
        in
        {
          iso-gnome = (evalIso (
            import ./ekaos/modules/installer/installation-cd-graphical-gnome.nix
          )).config.system.build.isoImage;
        };

      lib = {
        mkFlake = import ./lib/mk-flake.nix treefmt-nix;
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
