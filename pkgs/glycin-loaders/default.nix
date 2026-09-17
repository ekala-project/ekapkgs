{
  stdenv,
  lib,
  cairo,
  cargo,
  gettext,
  glib,
  gtk4,
  libglycin,
  lcms2,
  libheif,
  libjxl,
  librsvg,
  libseccomp,
  libxml2,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,

  enabledLoaders ? [
    "heif"
    "image-rs"
    "jxl"
    "svg"
  ],
}:

assert enabledLoaders != [ ];

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";

  inherit (libglycin) version src cargoDeps;

  nativeBuildInputs = [
    cargo
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    cairo
    libheif
    libxml2
    librsvg
    libseccomp
    libjxl
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" true)
    (lib.mesonBool "glycin-thumbnailer" false)
    (lib.mesonBool "libglycin" false)
    (lib.mesonBool "libglycin-gtk4" false)
    (lib.mesonBool "vapi" false)
    (lib.mesonBool "tests" false)
    (lib.mesonOption "loaders" (
      lib.concatMapStringsSep "," (loader: "glycin-${loader}") enabledLoaders
    ))
  ];

  postPatch = ''
    substituteInPlace glycin-loaders/meson.build \
      --replace-fail "cargo_target_dir / rust_target / loader," "cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / loader,"
  '';

  postInstall = ''
    rm -r $out/share/thumbnailers
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
