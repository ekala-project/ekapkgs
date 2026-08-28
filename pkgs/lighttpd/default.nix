{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  pkg-config,
  pcre2,
  libxml2,
  zlib,
  bzip2,
  which,
  file,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lighttpd";
  version = "1.4.84";

  src = fetchurl {
    url = "https://download.lighttpd.net/lighttpd/releases-${lib.versions.majorMinor finalAttrs.version}.x/lighttpd-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-B23UO+yPK6nObbfnyn6K1yJxzVKYBerSQAtW76oCb3A=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    pcre2
    pcre2.dev
    libxml2
    zlib
    bzip2
    which
    file
    openssl
  ];

  configureFlags = [
    "--with-openssl"
  ];

  preConfigure = ''
    export PATH=$PATH:${pcre2.dev}/bin
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  doCheck = false;

  postInstall = ''
    mkdir -p "$out/share/lighttpd/doc/config"
    cp -vr doc/config "$out/share/lighttpd/doc/"
    rm "$out/share/lighttpd/doc/config/Makefile"*
    rm "$out/share/lighttpd/doc/config/conf.d/Makefile"*
    rm "$out/share/lighttpd/doc/config/vhosts.d/Makefile"*
  '';

  meta = {
    description = "Lightweight high-performance web server";
    homepage = "http://www.lighttpd.net/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "lighttpd";
  };
})
