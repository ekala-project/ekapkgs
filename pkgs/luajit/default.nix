{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
}:

let
  buildStdenv =
    if buildPackages.stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.is32bit then
      buildPackages.pkgsi686Linux.buildPackages.stdenv
    else
      buildPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "luajit";
  version = "2.1.1774638290";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "fbb36bb6bfa88716a47c58bcf9ce9f2ef752abac";
    hash = "sha256-BqH66q38mJpIYJgPiSPt7I0B3VLBvuDRRTiMJ7ldkBI=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace ldconfig :
    if test -n "''${dontStrip-}"; then
      substituteInPlace src/Makefile --replace-fail "#CCDEBUG= -g" "CCDEBUG= -g"
    fi
  '';

  dontConfigure = true;

  buildFlags = [
    "amalg"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "DEFAULT_CC=cc"
    "CROSS=${stdenv.cc.targetPrefix}"
    "HOST_CC=${buildStdenv.cc}/bin/cc"
  ]
  ++ lib.optional stdenv.hostPlatform.isStatic "BUILDMODE=static";

  enableParallelBuilding = true;

  postInstall = ''
    ( cd "$out/include"; ln -s luajit-*/* . )
    ln -s "$out"/bin/luajit-* "$out"/bin/lua
    if [[ ! -e "$out"/bin/luajit ]]; then
      ln -s "$out"/bin/luajit* "$out"/bin/luajit
    fi
  '';

  meta = {
    description = "High-performance JIT compiler for Lua 5.1";
    homepage = "https://luajit.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "lua";
    maintainers = [ ];
  };
})
