{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  docopt_cpp,
  file,
  gumbo,
  mustache-hpp,
  libzim,
  icu,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zim-tools";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "zim-tools";
    tag = finalAttrs.version;
    hash = "sha256-8+/3+FOq35FSYzpQdpqs5MTMtUO5SYbKLPECFi+IIKw=";
  };

  patches = [
    ./fix_build_with_icu76.patch
  ];

  postPatch = ''
    # Disable werror, since the use of deprecated functions in libzim causes the build to fail
    substituteInPlace meson.build \
      --replace-fail "'werror=true', " ""
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    docopt_cpp
    file
    gumbo
    mustache-hpp
    libzim
    icu
    zlib
  ];

  strictDeps = true;

  meta = {
    description = "Various ZIM command line tools";
    homepage = "https://github.com/openzim/zim-tools";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
