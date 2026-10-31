{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  doxygen,
  libidn2,
  openssl,
  unbound,

  enableStubOnly ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "getdns";
  version = "1.7.3";

  outputs = [ "out" "dev" "lib" "man" ];

  src = fetchurl {
    url = "https://getdnsapi.net/releases/getdns-${lib.concatStringsSep "-" (lib.splitVersion finalAttrs.version)}/getdns-${finalAttrs.version}.tar.gz";
    sha256 = "f1404ca250f02e37a118aa00cf0ec2cbe11896e060c6d369c6761baea7d55a2c";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    doxygen
  ];

  buildInputs = [
    libidn2
    openssl
  ]
  ++ lib.optional (!enableStubOnly) unbound;

  cmakeEntries = {
    ENABLE_STUB_ONLY = enableStubOnly;
  };

  postPatch = ''
    substituteInPlace getdns.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postInstall = "rm -r $out/share/doc";

  meta = {
    description = "Modern asynchronous DNS API";
    homepage = "https://getdnsapi.net";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
