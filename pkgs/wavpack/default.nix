{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  autoreconfHook,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
    hash = "sha256-bG2RGYoJyNX2NObccA3TF1O0Lj/R531hlm/CiNCOCmM=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    gettext
  ];
  buildInputs = [ libiconv ];

  # autogen.sh:9
  preAutoreconf = ''
    cp ${gettext}/share/gettext/config.rpath .
    export ACLOCAL_PATH="${gettext}/share/gettext/m4''${ACLOCAL_PATH:+:$ACLOCAL_PATH}"
  '';

  meta = {
    description = "Hybrid audio compression format";
    homepage = "https://www.wavpack.com/";
    changelog = "https://github.com/dbry/WavPack/releases/tag/${version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
