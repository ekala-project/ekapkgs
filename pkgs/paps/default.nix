{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  fmt,
  glib,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paps";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dov";
    repo = "paps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bNF/kZl/fGAT+He9kMHYj5ERhJwCJJABjhV3H+bs3D0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dov/paps/commit/e9270aaac5e0b8018a6fad9a562ee48e7b2c3113.patch";
      name = "fix-g_utf8_next_char-cast";
      hash = "sha256-fedkyjd8cGFUuUQCbGii7wfMCmK6vye/1/vHWuJiJI4=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  postPatch = ''
    sed -i 's/fmt::localtime(val)/*std::localtime(\&val)/g' src/format_from_dict.cc
  '';

  buildInputs = [
    fmt
    glib
    pango
  ];

  meta = {
    description = "Pango to PostScript converter";
    homepage = "https://github.com/dov/paps";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    mainProgram = "paps";
  };
})
