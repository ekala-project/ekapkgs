{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gettext,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tre";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "laurikari";
    repo = "tre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5O8yqzv+SR8x0X7GtC2Pjo94gp0799M2Va8wJ4EKyf8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];

  preConfigure = ''
    ./utils/autogen.sh
  '';

  meta = {
    description = "Lightweight and robust POSIX compliant regexp matching library";
    homepage = "https://laurikari.net/tre/";
    changelog = "https://github.com/laurikari/tre/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    mainProgram = "agrep";
    platforms = lib.platforms.unix;
  };
})
