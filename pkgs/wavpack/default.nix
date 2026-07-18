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
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
    hash = "sha256-V9jRIuDpZYIBohJRouGr2TI32BZMXSNVfavqPl56YO0=";
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
    maintainers = [ ];
  };
}
