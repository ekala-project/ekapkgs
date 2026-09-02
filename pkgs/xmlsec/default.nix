{
  stdenv,
  fetchurl,
  fetchpatch,
  libxml2,
  gnutls,
  libxslt,
  pkg-config,
  libgcrypt,
  libtool,
  openssl,
  nss,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlsec";
  version = "1.3.7";

  src = fetchurl {
    urls = [
      "https://www.aleksey.com/xmlsec/download/xmlsec1-${finalAttrs.version}.tar.gz"
      "https://www.aleksey.com/xmlsec/download/older-releases/xmlsec1-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-2C6TtpuKogWmFrYpF6JpMiv2Oj6q+zd1AU5hdSsgE+o=";
  };

  patches = [
    ./lt_dladdsearchdir.patch
    ./remove_bsd_base64_decode_flag.patch
    (fetchpatch {
      url = "https://github.com/lsh123/xmlsec/commit/ef0e3b5cac04db13ce070b1e5bcad7dd7b0eb49b.patch?full_index=1";
      hash = "sha256-Hv8PaJXkXLq++NuCAJ4IvsYBPj8wkN7dBTniYucq18o=";
    })
  ];

  postPatch = ''
    substituteAllInPlace src/dl.c
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxml2
    gnutls
    libgcrypt
    libtool
    openssl
    nss
  ];

  propagatedBuildInputs = [
    libxslt
  ];

  enableParallelBuilding = true;

  configureFlags = [ "--enable-soap" ];

  env.NIX_LDFLAGS = "-lgcrypt";

  postInstall = ''
    moveToOutput "bin/xmlsec1-config" "$dev"
    moveToOutput "lib/xmlsec1Conf.sh" "$dev"
  '';

  meta = {
    description = "XML Security Library in C based on libxml2";
    homepage = "https://www.aleksey.com/xmlsec/";
    downloadPage = "https://www.aleksey.com/xmlsec/download.html";
    license = lib.licenses.mit;
    mainProgram = "xmlsec1";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
