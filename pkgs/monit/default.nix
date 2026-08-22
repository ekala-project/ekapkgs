{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  zlib,
  libxcrypt,
  usePAM ? true,
  pam,
  useSSL ? true,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monit";
  version = "5.35.2";

  src = fetchurl {
    url = "https://mmonit.com/monit/dist/monit-${finalAttrs.version}.tar.gz";
    hash = "sha256-Tf71QynmPZdyqeHDasmbxBFzt5lj3A2CNfLDL0ueB48=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    zlib.dev
    libxcrypt
  ]
  ++ lib.optionals useSSL [ openssl ]
  ++ lib.optionals usePAM [ pam ];

  configureFlags = [
    (lib.withFeature usePAM "pam")
  ]
  ++ (
    if useSSL then
      [
        "--with-ssl-incl-dir=${openssl.dev}/include"
        "--with-ssl-lib-dir=${lib.getLib openssl}/lib"
      ]
    else
      [
        "--without-ssl"
      ]
  )
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "libmonit_cv_setjmp_available=yes"
    "libmonit_cv_vsnprintf_c99_conformant=yes"
  ];

  meta = {
    homepage = "https://mmonit.com/monit/";
    description = "Monitoring system";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "monit";
  };
})
