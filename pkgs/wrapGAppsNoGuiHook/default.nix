{
  stdenv,
  lib,
  makeSetupHook,
  makeBinaryWrapper,
  isGraphical ? false,
  gtk3,
  librsvg,
  dconf,
  targetPackages,
}:

makeSetupHook {
  name = "wrap-gapps-hook";
  propagatedBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals isGraphical [
    gtk3
    librsvg
  ];

  depsTargetTargetPropagated =
    lib.optionals isGraphical [
      librsvg
      gtk3
    ]
    ++
      lib.optionals (!stdenv.targetPlatform.isDarwin && lib.meta.availableOn stdenv.targetPlatform dconf)
        [
          dconf.lib
        ];
  meta.license = lib.licenses.mit;
} ./wrap-gapps-hook.sh
