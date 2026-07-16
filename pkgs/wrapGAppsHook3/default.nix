{
  lib,
  stdenv,
  makeSetupHook,
  makeWrapper,
  gtk3,
  librsvg,
  dconf,
  targetPackages,
}:

makeSetupHook {
  name = "wrap-gapps-hook3";
  propagatedBuildInputs = [
    makeWrapper
    gtk3
    librsvg
  ];

  depsTargetTargetPropagated =
    assert (!targetPackages ? raw || throw "wrapGAppsHook3 must be in nativeBuildInputs");
    [
      librsvg
      gtk3
    ]
    ++ lib.optionals (!stdenv.targetPlatform.isDarwin) [
      dconf.lib
    ];

  meta.license = lib.licenses.mit;
} ./wrap-gapps-hook.sh
