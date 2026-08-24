{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libtasn1,
  openssl,
  glib,
  libseccomp,
  json-glib,
  libtpms,
  unixtools,
  expect,
  socat,
  gnutls,
  perl,
  python3,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swtpm";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iG4yiND/w0YZYm+wj89QPIahIFh1Y6gA4u+eADGkwn8=";
  };

  nativeBuildInputs = [
    pkg-config
    unixtools.netstat
    expect
    socat
    perl
    python3
    autoreconfHook
  ];

  nativeCheckInputs = [
    which
  ];

  buildInputs = [
    libtpms
    openssl
    libtasn1
    glib
    json-glib
    gnutls
    libseccomp
  ];

  configureFlags = [
    "--localstatedir=/var"
  ];

  postPatch = ''
    patchShebangs tests/*

    substituteInPlace configure.ac --replace-fail 'pkg-config' '${stdenv.cc.targetPrefix}pkg-config'

    substituteInPlace samples/Makefile.am \
        --replace 'install-data-local:' 'do-not-execute:'

    substituteInPlace src/swtpm_localca/swtpm_localca.c \
      --replace \
        '# define CERTTOOL_NAME "gnutls-certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"' \
      --replace \
        '# define CERTTOOL_NAME "certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"'

    substituteInPlace tests/common --replace \
        'CERTTOOL=gnutls-certtool;;' \
        'CERTTOOL=certtool;;'

    substituteInPlace tests/common tests/sed-inplace --replace \
        'if [[ "$(uname -s)" =~ (Linux|CYGWIN_NT-) ]]; then' \
        'if [[ "$(uname -s)" =~ (Linux|Darwin|CYGWIN_NT-) ]]; then'

    substituteInPlace tests/test_swtpm_setup_create_cert --replace \
        '$CERTTOOL' \
        'LC_ALL=C.UTF-8 $CERTTOOL'

    substituteInPlace tests/test_tpm2_swtpm_cert --replace \
        'certtool' \
        'LC_ALL=C.UTF-8 certtool'
  '';

  doCheck = false;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  meta = with lib; {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "swtpm";
    platforms = platforms.all;
  };
})
