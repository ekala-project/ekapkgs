{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2.7.0";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libplist";
    rev = version;
    hash = "sha256-Rc1KwJR+Pb2lN8019q5ywERrR7WA2LuLRiEvNsZSxXc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [
    "--enable-debug"
    "--without-cython"
  ];

  doCheck = true;

  meta = {
    description = "Library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "plistutil";
  };
}
