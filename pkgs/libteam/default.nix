{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libnl,
  libdaemon,
  jansson,
  dbus,
  swig,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libteam";
  version = "1.32";

  src = fetchFromGitHub {
    owner = "jpirko";
    repo = "libteam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/IPlt1mDvi0qPJBBeOHxMYwr9+rr++Q3kR26bhZt5jo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    swig
  ];

  buildInputs = [
    libnl
    libdaemon
    jansson
    dbus
    python3
  ];

  meta = {
    description = "Library for controlling team network device in Linux kernel";
    homepage = "https://github.com/jpirko/libteam";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
