{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice-glue";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice-glue";
    rev = version;
    hash = "sha256-Fu0zQIryESRaTGzDlAaewX9Yo2nPEeUxmcb3yPJLuSI=";
  };

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
