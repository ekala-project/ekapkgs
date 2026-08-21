{
  lib,
  stdenv,
  fetchurl,
  openssl,
  systemdLibs,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stunnel";
  version = "5.79";

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchurl {
    url = "https://www.stunnel.org/archive/${lib.versions.major finalAttrs.version}.x/stunnel-${finalAttrs.version}.tar.gz";
    hash = "sha256-jqDebl6nbzjqmH+oMcf9R/eh8efdRl/W+oYi7fMNOkU=";
  };

  enableParallelBuilding = true;

  buildInputs = [
    openssl
  ]
  ++ lib.optionals systemdSupport [
    systemdLibs
  ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.enableFeature systemdSupport "systemd")
  ];

  postInstall = ''
    # remove legacy compatibility-wrapper that would require perl
    rm $out/bin/stunnel3
  '';

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "Universal tls/ssl wrapper";
    homepage = "https://www.stunnel.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "stunnel";
    maintainers = [ ];
  };
})
