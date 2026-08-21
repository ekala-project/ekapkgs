{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  meson,
  ninja,
  python3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphene";
  version = "1.10.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = "graphene";
    rev = finalAttrs.version;
    sha256 = "P6JQhSktzvyMHatP/iojNGXPmcsxsFxdYerXzS23ojI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ebassi/graphene/commit/4fbdd07ea3bcd0964cca3966010bf71cb6fa8209.patch";
      sha256 = "uFkkH0u4HuQ/ua1mfO7sJZ7MPrQdV/JON7mTYB4DW80=";
      includes = [ "tests/simd.c" ];
      revert = true;
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dintrospection=disabled"
    "-Dinstalled_tests=false"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    "-Darm_neon=false"
  ];

  postPatch = ''
    patchShebangs tests/gen-installed-test.py
  '';

  meta = {
    description = "Thin layer of graphic data types";
    homepage = "https://github.com/ebassi/graphene";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
