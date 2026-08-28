{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGLU,
  libGL,
  glew,
  libxmu,
  libxext,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencsg";
  version = "1.8.2";

  src = fetchurl {
    url = "https://www.opencsg.org/OpenCSG-${finalAttrs.version}.tar.gz";
    hash = "sha256-WsXfc7GtM0DdZwX/kOAJ8alGu5U2whwiY6b5dCZWZMA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLE=OFF"
  ];

  buildInputs = [
    glew
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
    libxmu
    libxext
    libx11
  ];

  doCheck = false;

  postInstall = ''
    install -D ../copying.txt "$out/share/doc/opencsg/copying.txt"
  '';

  meta = {
    description = "Constructive Solid Geometry library";
    mainProgram = "opencsgexample";
    homepage = "http://www.opencsg.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
