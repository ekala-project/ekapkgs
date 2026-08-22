{
  stdenv,
  lib,
  fetchFromSourcehut,
  asciidoc,
  cmocka,
  docbook_xsl,
  libxslt,
  meson,
  ninja,
  pkg-config,
  tinyxxd,
  icu,
  pango,
  inih,
  withWindowSystem ? "all",
  libx11,
  libxcb,
  libxkbcommon,
  libGL,
  wayland,
  wayland-protocols,
  wayland-scanner,
  withBackends ? [
    "farbfeld"
    "libtiff"
    "libjpeg"
    "libpng"
    "librsvg"
    "libnsgif"
    "libnsbmp"
    "libwebp"
    "qoi"
  ],
  libtiff,
  libjpeg_turbo,
  libjxl ? null,
  libpng,
  librsvg,
  libnsgif,
  libheif ? null,
  libnsbmp,
  libwebp,
  qoi,
}:

let
  windowSystems = {
    all = windowSystems.x11 ++ windowSystems.wayland;
    x11 = [
      libxcb
      libx11
    ];
    wayland = [
      wayland
      wayland-scanner
      wayland-protocols
    ];
  };

  backends = {
    inherit
      libtiff
      libpng
      librsvg
      libheif
      libjxl
      libnsgif
      libnsbmp
      libwebp
      qoi
      ;
    farbfeld = null; # builtin
    libjpeg = libjpeg_turbo;
  };

  backendFlags = map (b: lib.mesonEnable b (lib.elem b withBackends)) (lib.attrNames backends);
in

# check that given window system is valid
assert lib.assertOneOf "withWindowSystem" withWindowSystem (builtins.attrNames windowSystems);
# check that every given backend is valid
assert builtins.all (
  b: lib.assertOneOf "each backend" b (builtins.attrNames backends)
) withBackends;

stdenv.mkDerivation (finalAttrs: {
  pname = "imv";
  version = "5.0.1";
  outputs = [
    "out"
  ];

  src = fetchFromSourcehut {
    owner = "~exec64";
    repo = "imv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2JTs/hj6t9wEZKoUpcLDFulbdU/grDlQkuEAE7uayDs=";
  };

  mesonFlags = [
    (lib.mesonOption "windows" withWindowSystem)
    (lib.mesonEnable "test" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "man" false)
  ]
  ++ backendFlags;

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libGL
    icu
    libxkbcommon
    pango
    inih
  ]
  ++ windowSystems."${withWindowSystem}"
  ++ map (b: backends."${b}") withBackends;

  doCheck = true;
  nativeCheckInputs = [
    tinyxxd
  ];
  checkInputs = [
    cmocka
  ];

  meta = {
    description = "Command line image viewer for tiling window managers";
    homepage = "https://sr.ht/~exec64/imv/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "imv";
  };
})
