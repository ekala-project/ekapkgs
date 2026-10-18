{
  version,
  src-hash,
  sigcxxVariant ? "v2",
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  boost,
  meson,
  ninja,
  pkg-config,
  cairo,
  fontconfig,
  libsigcxx,
  libsigcxx30,
}:

let
  sigcxx = if sigcxxVariant == "v3" then libsigcxx30 else libsigcxx;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "cairomm";
  inherit version;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.cairographics.org/releases/cairomm-${version}.tar.xz";
    sha256 = src-hash;
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    boost # for tests
    fontconfig
  ];

  propagatedBuildInputs = [
    cairo
    sigcxx
  ];

  mesonEntries = {
    build-tests = true;
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "C++ bindings for the Cairo vector graphics library";
    homepage = "https://www.cairographics.org/";
    license = with lib.licenses; [
      lgpl2Plus
      mpl10
    ];
    platforms = lib.platforms.unix;
  };
})
