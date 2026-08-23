{
  lib,
  stdenv,
  fetchFromGitHub,
  libmowgli,
  pkg-config,
  git,
  gettext,
  pcre2,
  libidn,
  libxcrypt,
  cracklib,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atheme";
  version = "7.2.12";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "atheme";
    rev = "b8b23c51cda120f2cfc5af9ac639cd257575f2ce";
    hash = "sha256-Dx+j+a+Sp2OErARdhcgajnpnpnFw63wkJC5i9FSVmE4=";
    # for modules and pinned libmowgli
    fetchSubmodules = true;
    # configure checks for git tree
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    pkg-config
    git
    gettext
  ];

  buildInputs = [
    libmowgli
    pcre2
    libidn
    libxcrypt
    cracklib
    openssl
  ];

  configureFlags = [
    "--with-pcre"
    "--with-libidn"
    "--with-cracklib"
    "--enable-large-net"
    "--enable-contrib"
    "--enable-reproducible-builds"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Set of services for IRC networks";
    homepage = "https://atheme.github.io/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
