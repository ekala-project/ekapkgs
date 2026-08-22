{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf269,
  autoreconfHook,
  pkg-config,
  libmysqlclient,
  libaio,
  luajit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysbench";
  version = "1.0.20";

  nativeBuildInputs = [
    autoconf269
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libmysqlclient
    luajit
    libaio
  ];
  depsBuildBuild = [ pkg-config ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = finalAttrs.version;
    sha256 = "1sanvl2a52ff4shj62nw395zzgdgywplqvwip74ky8q7s6qjf5qy";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--with-system-luajit"
    "--with-mysql-includes=${lib.getDev libmysqlclient}/include/mysql"
    "--with-mysql-libs=${libmysqlclient}/lib/mysql"
  ];

  postPatch = ''
    substituteInPlace \
      third_party/concurrency_kit/ck/configure \
        --replace-fail \
          'COMPILER=`./.1 2> /dev/null`' \
          "COMPILER=${
            if stdenv.cc.isGNU then
              "gcc"
            else if stdenv.cc.isClang then
              "clang"
            else
              throw "Unsupported compiler"
          }" \
        --replace-fail \
          'PLATFORM=`uname -m 2> /dev/null`' \
          "PLATFORM=${stdenv.hostPlatform.parsed.cpu.name}"
    substituteInPlace \
      third_party/concurrency_kit/ck/src/Makefile.in \
        --replace-fail \
          "ar rcs" \
          "${stdenv.cc.targetPrefix}ar rcs"
  '';

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    mainProgram = "sysbench";
    homepage = "https://github.com/akopytov/sysbench";
    changelog = "https://github.com/akopytov/sysbench/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
