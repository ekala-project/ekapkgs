{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2.8.0";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libplist";
    rev = version;
    hash = "sha256-RhYF0268U/UrsnxxnDEVWDpkwBjKd01EJQ0Ml7IU760=";
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
    platforms = lib.platforms.unix;
    mainProgram = "plistutil";
  };
}
