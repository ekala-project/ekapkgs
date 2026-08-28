{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libkrb5,
}:

stdenv.mkDerivation rec {
  pname = "libtirpc";
  version = "1.3.6";

  src = fetchurl {
    url = "http://git.linux-nfs.org/?p=steved/libtirpc.git;a=snapshot;h=refs/tags/libtirpc-${
      lib.replaceStrings [ "." ] [ "-" ] version
    };sf=tgz";
    hash = "sha256-pTUfqnfHOQKCV0svKF/lo4hq1GlD/+YFjXP2CNygx9I=";
    name = "${pname}-${version}.tar.gz";
  };

  outputs = [
    "out"
    "dev"
  ];

  KRB5_CONFIG = "${libkrb5.dev}/bin/krb5-config";
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libkrb5 ];
  strictDeps = true;

  preConfigure = ''
    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i doc/Makefile.in tirpc/netconfig.h
  '';

  configureFlags = lib.optional (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "LDFLAGS=-Wl,--undefined-version";

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/etc
  '';

  doCheck = true;

  meta = {
    homepage = "https://sourceforge.net/projects/libtirpc/";
    description = "Transport-independent Sun RPC implementation (TI-RPC)";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
