{
  lib,
  symlinkJoin,
  binaryPlugins ? [ ],
  krita-unwrapped,
  gtk3,
}:
symlinkJoin {
  pname = "krita";
  inherit (krita-unwrapped)
    version
    buildInputs
    meta
    ;

  nativeBuildInputs = krita-unwrapped.nativeBuildInputs ++ [
    gtk3.wrapGAppsHook
  ];

  paths = [ krita-unwrapped ] ++ binaryPlugins;

  postBuild = ''
    gappsWrapperArgsHook
    wrapQtApp "$out/bin/krita" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set KRITA_PLUGIN_PATH "$out/lib/kritaplugins"
  '';

  passthru = {
    inherit binaryPlugins;
    unwrapped = krita-unwrapped;
  };
}
