{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnutls,
  libedit,
  libcap,
  libseccomp,
  pps-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chrony";
  version = "4.8";

  src = fetchurl {
    url = "https://chrony-project.org/releases/chrony-${finalAttrs.version}.tar.gz";
    hash = "sha256-M+qOsqTa6qUG6Pyv1dbYkCftby8GCWRcbxSbVg0wFwY=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gnutls
    libedit
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    libseccomp
    pps-tools
  ];

  configureFlags = [
    "--enable-ntp-signd"
    "--sbindir=$(out)/bin"
    "--chronyrundir=/run/chrony"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "--enable-scfilter";

  patches = [
    ./makefile.patch
  ];

  postPatch = ''
    patchShebangs test

    rm test/unit/nts_ke_session.c
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Sets your computer's clock from time servers on the Net";
    homepage = "https://chrony-project.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
