{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.5.1";
  pname = "sshguard";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/sshguard-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-mXoeDsKyFltHV8QviUgWLrU0GDlGr1LvxAaIXZfLifw=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  configureFlags = [ "--sysconfdir=/etc" ];

  meta = {
    description = "Protects hosts from brute-force attacks";
    mainProgram = "sshguard";
    homepage = "https://sshguard.net";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
