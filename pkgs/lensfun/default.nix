{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  zlib,
  libpng,
  cmake,
  python3,
  python3Packages,
}:

let
  version = "0.3.4";
  pname = "lensfun";

  lensfunDatabase = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "a1510e6f33ce9bc8b5056a823c6d5bc6b8cba033";
    sha256 = "sha256-qdONyKk873Tq11M33JmznhJMAGd4dqp5KdXdVhfy/Ak=";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "v${version}";
    sha256 = "sha256-FyYilIz9ssSHG6S02Z2bXy7fjSY51+SWW3v8bm7sLvY=";
  };

  prePatch = ''
    rm -R data/db
    python3 ${lensfunDatabase}/tools/lensfun_convert_db_v2_to_v1.py $TMPDIR ${lensfunDatabase}/data/db
    mkdir -p data/db
    tar xvf $TMPDIR/db/version_1.tar -C data/db
    date +%s > data/db/timestamp.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
    python3Packages.setuptools
    python3Packages.lxml
  ];

  buildInputs = [
    glib
    zlib
    libpng
  ];

  cmakeFlags = [ "-DINSTALL_HELPER_SCRIPTS=OFF" ];

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3;
    description = "Opensource database of photographic lenses and their characteristics";
    homepage = "https://lensfun.github.io";
  };
}
