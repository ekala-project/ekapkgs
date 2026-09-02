{
  lib,
  stdenv,
  fetchFromGitHub,
  hwdata,
  pkg-config,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lshw";
  version = "02.20";

  src = fetchFromGitHub {
    owner = "lyonel";
    repo = "lshw";
    rev = "B.${finalAttrs.version}";
    hash = "sha256-4etC7ymMgn1Q4f98DNASv8vn0AT55dYPdacZo6GRDw0=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    hwdata
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${finalAttrs.src.rev}"
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isStatic [ "fortify" ];

  enableParallelBuilding = true;

  meta = {
    description = "Provide detailed information on the hardware configuration of the machine";
    homepage = "https://ezix.org/project/wiki/HardwareLiSter";
    license = lib.licenses.gpl2;
    mainProgram = "lshw";
    platforms = lib.platforms.linux;
  };
})
