{
  buildFHSEnv,
  symlinkJoin,
  bottles-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  removeWarningPopup ? false,
}:

let
  fhsEnv = {
    inherit (bottles-unwrapped) version;
    multiArch = true;

    targetPkgs =
      pkgs:
      with pkgs;
      [
        (bottles-unwrapped.override { inherit removeWarningPopup; })
        vkbasalt
        lsfg-vk
      ]
      ++ extraPkgs pkgs;

    extraLibraries = pkgs: extraLibraries pkgs;
  };
in
buildFHSEnv (
  fhsEnv
  // {
    pname = "bottles";

    runScript = "bottles";

    extraInstallCommands = ''
      mkdir -p $out/share
      ln -s ${bottles-unwrapped}/share/applications $out/share
      ln -s ${bottles-unwrapped}/share/icons $out/share
    '';

    meta = bottles-unwrapped.meta // {
      description = "${bottles-unwrapped.meta.description} (with FHS environment)";
    };
  }
)
