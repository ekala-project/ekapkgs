{
  lib,
  stdenv,
  fetchFromGitHub,
  apacheHttpd,
  python3,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mod_wsgi";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "mod_wsgi";
    tag = finalAttrs.version;
    hash = "sha256-FhOSU8/4QoWa73bNi/qkgKm3CeEEdboh2MgxgQxcYzE=";
  };

  nativeBuildInputs = [
    apacheHttpd.dev
    python3
  ];

  buildInputs = [
    apacheHttpd
    python3
    ncurses
  ];

  postPatch = ''
    substituteInPlace configure --replace-fail '/usr/bin/lipo' 'lipo'
  '';

  makeFlags = [
    "LIBEXECDIR=$(out)/modules"
  ];

  meta = {
    homepage = "https://github.com/GrahamDumpleton/mod_wsgi";
    description = "Host Python applications in Apache through the WSGI interface";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
