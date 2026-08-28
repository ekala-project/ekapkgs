{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  xorgproto,
  libx11,
  libxt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "appres";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/appres-${finalAttrs.version}.tar.xz";
    hash = "sha256-ERSxiSOf2HqNHbQz7ctEhjRtKZEhMrkeru5WZ/E7gZ8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    xorgproto
    libx11
    libxt
  ];

  meta = {
    description = "Utility to list X application resource database";
    longDescription = ''
      The appres program prints the resources seen by an application (or subhierarchy of an
      application) with the specified class and instance names.
      It can be used to determine which resources a particular program will load.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/appres";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "appres";
    platforms = lib.platforms.unix;
  };
})
