{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  perl,
  openssl,
  db,
  cyrus_sasl,
  zlib,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isync";
  version = "1.5.1";

  src = fetchgit {
    url = "https://git.code.sf.net/p/isync/isync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l0jL4CzAdFtQGekbywic1Kuihy3ZQi4ozhSEcbJI0t0=";
  };

  env.NIX_CFLAGS_COMPILE = "-DQPRINTF_BUFF=4000";

  autoreconfPhase = ''
    echo "${finalAttrs.version}" > VERSION
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
    db
    cyrus_sasl
    zlib
  ];

  doCheck = true;

  meta = {
    homepage = "https://isync.sourceforge.io";
    changelog = "https://sourceforge.net/p/isync/isync/ci/v${finalAttrs.version}/tree/NEWS";
    description = "Free IMAP and MailDir mailbox synchronizer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "mbsync";
  };
})
