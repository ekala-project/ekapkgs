{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxcb,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-render-util";
  version = "0.3.10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-renderutil-${finalAttrs.version}.tar.xz";
    hash = "sha256-PhXU8OItjdv7ufXXfbQ+rNejBAKb8lphZsxjyqltBLo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxcb
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "XCB convenience functions for the Render extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-render-util";
    license = with lib.licenses; [
      hpndSellVariant
      x11
    ];
    pkgConfigModules = [ "xcb-renderutil" ];
    platforms = lib.platforms.unix;
  };
})
