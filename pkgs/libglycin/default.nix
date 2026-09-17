{
  lib,
  stdenv,
  fetchurl,
  makeSetupHook,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  python3,
  rustPlatform,
  vala,
  gi-docgen,
  glib,
  gobject-introspection,
  fontconfig,
  libseccomp,
  lcms2,
  replaceVars,
  bubblewrap,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libglycin";
  version = "2.1.5";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  setupHook = ./path-hook.sh;

  src = fetchurl {
    url = "mirror://gnome/sources/glycin/${lib.versions.majorMinor finalAttrs.version}/glycin-${finalAttrs.version}.tar.xz";
    hash = "sha256-bAl1fukGMwpgtnBXU6pWvKAHrSGblebjU3UQ1BvDQcg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-6vCucnT3xPWSm3TSi3WzgJdiiBFHvGMpab4d53OfThg=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustc
    cargo
    python3
    rustPlatform.cargoSetupHook
    finalAttrs.passthru.patchVendorHook
    vala
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    fontconfig
    libseccomp
    lcms2
  ];

  propagatedBuildInputs = [
    glib
    fontconfig
    libseccomp
    lcms2
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "glycin-thumbnailer" false)
    (lib.mesonBool "libglycin" true)
    (lib.mesonBool "libglycin-gtk4" false)
    (lib.mesonBool "introspection" true)
    (lib.mesonBool "vapi" true)
    (lib.mesonBool "capi_docs" true)
  ];

  postPatch = ''
    patchShebangs \
      build-aux/crates-version.py
    substituteInPlace libglycin/meson.build --replace-fail \
      "cargo_output = cargo_target_dir / rust_target" \
      "cargo_output = cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target"
  '';

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru = {
    patchVendorHook =
      makeSetupHook
        {
          name = "glycinPatchVendorHook";
        }
        (
          replaceVars ./patch-vendor-hook.sh {
            bwrap = "${bubblewrap}/bin/bwrap";
            jq = "${buildPackages.jq}/bin/jq";
            sponge = "${buildPackages.moreutils}/bin/sponge";
          }
        );
  };

  meta = {
    description = "Sandboxed and extendable image loading library";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
