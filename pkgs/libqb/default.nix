{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "libqb";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "libqb";
    rev = "v${version}";
    sha256 = "sha256-AlBGGtZlXa1VngAe1sf8xVuERsEuptJvo/AX1A+YnQs=";
  };

  patches = [
    # add a declaration of fdatasync, missing on darwin https://github.com/ClusterLabs/libqb/pull/496
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxml2 ];

  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/AC_SUBST(\[AM_LDFLAGS\])/ d' configure.ac
  '';

  meta = with lib; {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "Library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
