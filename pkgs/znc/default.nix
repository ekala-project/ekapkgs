{
  lib,
  stdenv,
  fetchurl,
  cmake,
  openssl,
  pkg-config,
  withPerl ? false,
  perl ? null,
  withPython ? false,
  python3 ? null,
  withTcl ? false,
  tcl ? null,
  withCyrus ? true,
  cyrus_sasl ? null,
  withUnicode ? true,
  icu ? null,
  withZlib ? true,
  zlib ? null,
  withIPv6 ? true,
  withDebug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "znc";
  version = "1.10.1";

  src = fetchurl {
    url = "https://znc.in/releases/archive/znc-${finalAttrs.version}.tar.gz";
    hash = "sha256-Tm52hR2/JgYYWXK1PsXeytaP5TtjpW5N+LizwKbEaAA=";
  };

  postPatch = ''
    substituteInPlace znc.pc.cmake.in \
      --replace-fail 'bindir=''${exec_prefix}/@CMAKE_INSTALL_BINDIR@' "bindir=@CMAKE_INSTALL_FULL_BINDIR@" \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' "libdir=@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace-fail 'datadir=''${prefix}/@CMAKE_INSTALL_DATADIR@' "datadir=@CMAKE_INSTALL_FULL_DATADIR@" \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' "includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail 'datarootdir=''${prefix}/@CMAKE_INSTALL_DATAROOTDIR@' "datarootdir=@CMAKE_INSTALL_FULL_DATAROOTDIR@"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional withPerl perl
  ++ lib.optional withPython python3
  ++ lib.optional withTcl tcl
  ++ lib.optional withCyrus cyrus_sasl
  ++ lib.optional withUnicode icu
  ++ lib.optional withZlib zlib;

  cmakeFlags = [
    (lib.cmakeBool "WANT_PERL" withPerl)
    (lib.cmakeBool "WANT_PYTHON" withPython)
    (lib.cmakeBool "WANT_TCL" withTcl)
    (lib.cmakeBool "WANT_CYRUS" withCyrus)
    (lib.cmakeBool "WANT_IPV6" withIPv6)
  ]
  ++ lib.optionals withTcl [ "-DTCL_LIBRARY=${tcl}/lib" ];

  meta = {
    description = "Advanced IRC bouncer";
    homepage = "https://wiki.znc.in/ZNC";
    maintainers = [ ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "znc" ];
  };
})
