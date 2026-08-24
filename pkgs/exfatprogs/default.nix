{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  file,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exfatprogs";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    rev = finalAttrs.version;
    sha256 = "sha256-twzHX8Uee0Uf8w1OsXWjecOl+Qs51jdJXK1sqdt6+4k=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    file
  ];

  buildInputs = [
    util-linux
  ];

  meta = {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
