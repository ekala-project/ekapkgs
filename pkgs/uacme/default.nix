{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  curl,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "uacme";
  version = "1.8.1-1";

  src = fetchFromGitHub {
    owner = "ndilieto";
    repo = "uacme";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-PyH+uwzqn9f2k1oqNVc9oEJAmVzGi3z/65OK2+AFcaA=";
  };

  configureFlags = [ "--with-openssl" ];

  nativeBuildInputs = [
    asciidoc
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
  ];

  meta = {
    description = "ACMEv2 client written in plain C with minimal dependencies";
    homepage = "https://github.com/ndilieto/uacme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
