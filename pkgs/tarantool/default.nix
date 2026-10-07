{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cmake,
  zlib,
  openssl,
  c-ares,
  readline,
  icu,
  git,
  gbenchmark,
  nghttp2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tarantool";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "tarantool";
    repo = "tarantool";
    tag = finalAttrs.version;
    hash = "sha256-fkAjzAS7LV+bME8FeImg1OXNfNhXTH6qb53TzHz4SFY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cat <<'EOF' > third_party/luajit/test/cmake/GetLinuxDistro.cmake
    macro(GetLinuxDistro output)
      set(''${output} linux)
    endmacro()
    EOF
  '';

  buildInputs = [
    nghttp2
    git
    readline
    icu
    zlib
    openssl
    c-ares
  ];

  nativeCheckInputs = [ gbenchmark ];

  nativeBuildInputs = [
    autoreconfHook
    cmake
    cmake.configurePhaseHook
  ];

  preAutoreconf = ''
    pushd third_party/libunwind
  '';

  postAutoreconf = ''
    popd
  '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeEntries = {
    ENABLE_DIST = true;
    TARANTOOL_VERSION = "${finalAttrs.version}.builtByNix";
  };
  meta = {
    description = "In-memory computing platform consisting of a database and an application server";
    homepage = "https://www.tarantool.io/";
    license = lib.licenses.bsd2;
    mainProgram = "tarantool";
  };
})
