{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
  withDebug ? false,
}:

stdenv.mkDerivation rec {
  pname = "tinyproxy";
  version = "1.11.3";

  src = fetchFromGitHub {
    hash = "sha256-In/ZG50i2jKl0x7yfSs3KHlBdm8NdXtspMJPiv4BW6g=";
    rev = version;
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

  # perl is needed for man page generation.
  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  configureFlags = lib.optionals withDebug [ "--enable-debug" ];

  meta = with lib; {
    homepage = "https://tinyproxy.github.io/";
    description = "Light-weight HTTP/HTTPS proxy daemon for POSIX operating systems";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    mainProgram = "tinyproxy";
  };
}
