{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  luajit,
  libuv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libluv";
  version = "1.52.1-0";

  src = fetchFromGitHub {
    owner = "luvit";
    repo = "luv";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-mU+Gvlpvp6iZE5IpXfTr+21QQ34vZk+tYhnr0b891qg=";
  };

  # Remove bundled deps to ensure we use system ones
  prePatch = ''
    rm -rf deps/lua deps/luajit deps/libuv
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    libuv
    luajit
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_STATIC_LIBS" false)
    "-DBUILD_MODULE=OFF"
    "-DWITH_SHARED_LIBUV=ON"
    "-DLUA_BUILD_TYPE=System"
    "-DWITH_LUA_ENGINE=LuaJit"
  ];

  meta = {
    description = "Bare libuv bindings for Lua";
    homepage = "https://github.com/luvit/luv";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
