{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  intltool,
  json_c,
  libtool,
  pkg-config,
  python3,
  gettext,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmypaint";
  version = "1.6.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "libmypaint";
    rev = "v${finalAttrs.version}";
    sha256 = "1ppgpmnhph9h8ayx9776f79a0bxbdszfw9c6bw7c3ffy2yk40178";
  };

  patches = [
    ./0001-configure-use-regular-GETTEXT-unconditionally.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    libtool
    pkg-config
    python3
  ];

  buildInputs = [
    glib
  ];

  propagatedBuildInputs = [
    json_c
  ];

  doCheck = true;

  preConfigure = ''
    export AUTOMAKE=automake
    export ACLOCAL=aclocal
    ./autogen.sh
  '';

  meta = {
    homepage = "http://mypaint.org/";
    description = "Library for making brushstrokes which is used by MyPaint and other projects";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
