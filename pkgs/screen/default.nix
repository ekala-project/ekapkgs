{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  texinfo,
  ncurses,
  libxcrypt,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "screen";
  version = "5.0.1";

  src = fetchurl {
    url = "mirror://gnu/screen/screen-${finalAttrs.version}.tar.gz";
    hash = "sha256-La429Ns3n/zRS2kVlrpuwYrDqeIrxHrCOXiatYQJhp0=";
  };

  patches = [
    (fetchpatch {
      url = "https://file.savannah.gnu.org/file/0001-test-fix-unit-tests.patch?file_id=57558";
      stripLen = 1;
      hash = "sha256-q3jQQrzweLf2T/V5X9iL4ZZK342QEXLG5fZTaMOB4tY=";
    })
    (fetchpatch {
      name = "screen.info-1st.patch";
      url = "https://cgit.git.savannah.gnu.org/cgit/screen.git/patch/?id=7333452aa52d61a170b1fc199869ea6059849058";
      stripLen = 1;
      hash = "sha256-fYkljMNefDJtf+uA9qPotQEOxwhlQj0nZfTszhl/oik=";
    })
    (fetchpatch {
      name = "screen.info-2nd.patch";
      url = "https://cgit.git.savannah.gnu.org/cgit/screen.git/patch/?id=6790fb8e1931783646c07a364657fadb5c9d1e63";
      stripLen = 1;
      hash = "sha256-+fRPfCbJKYUW/ZE6C63xB2WEtTv6KPi8waXLt9N+AuU=";
    })
    (fetchpatch {
      name = "screen.info-3rd.patch";
      url = "https://cgit.git.savannah.gnu.org/cgit/screen.git/patch/?id=94c3e1fd81826ce3b677d49f7a452e6fe77ed63b";
      stripLen = 1;
      hash = "sha256-Wq4Bx5wCqsOWtrfUON5wTuhpBH8JxyoOiHHfDT2CsHw=";
    })
  ];

  configureFlags = [
    "--enable-telnet"
    "--enable-pam"
  ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE=1";

  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];

  buildInputs = [
    ncurses
    libxcrypt
    pam
  ];

  outputs = [
    "out"
    "info"
    "man"
  ];

  meta = {
    homepage = "https://www.gnu.org/software/screen/";
    description = "Window manager that multiplexes a physical terminal";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
