{
  buildFHSEnv,
  symlinkJoin,
  bottles-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  removeWarningPopup ? false,
}:

buildFHSEnv {
  pname = "bottles";
  inherit (bottles-unwrapped) version;

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
