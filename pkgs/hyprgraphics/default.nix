{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cairo,
  file,
  hyprutils,
  lcms2,
  libGL,
  libdrm,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libwebp,
  pango,
  pixman,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-48DubZbx8PDfuJkksNgi5aWFnX/Rq1OUaLsUvsdf2Bo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    cairo
    file
    hyprutils
    lcms2
    libGL
    libdrm
    libjpeg
    libjxl
    librsvg
    libspng
    libwebp
    pango
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/hyprwm/hyprgraphics";
    changelog = "https://github.com/hyprwm/hyprgraphics/releases/tag/v${finalAttrs.version}";
    description = "Cpp graphics library for Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
