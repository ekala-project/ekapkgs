{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  icu,
  meson,
  ninja,
  pkg-config,
  python3,
  xapian,
  xz,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzim";
  version = "9.8.1";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "libzim";
    tag = finalAttrs.version;
    hash = "sha256-XgUB3Nrz7qTinf9Xp1k+R8b+AfzpMAFlFUV6mej7TDU=";
  };

  nativeBuildInputs = [
    ninja
    meson
    meson.configurePhaseHook
    pkg-config
    python3
  ];

  buildInputs = [
    icu
    zstd
  ];

  propagatedBuildInputs = [
    xapian
    xz
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  mesonFlags = [
    # Tests are located at https://github.com/openzim/zim-testing-suite
    # "...some tests need up to 16GB of memory..."
    "-Dtest_data_dir=none"
  ];

  passthru.meta = {
    description = "Reference implementation of the ZIM specification";
    homepage = "https://github.com/openzim/libzim";
    changelog = "https://github.com/openzim/libzim/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
