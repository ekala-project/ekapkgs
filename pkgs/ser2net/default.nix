{
  autoreconfHook,
  fetchFromGitHub,
  gensio,
  lib,
  libxcrypt,
  libyaml,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ser2net";
  version = "4.6.8";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "ser2net";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9PK+P9LO5X4M1q1ExiWngkqRRflJbg70rCoSJ0fqdWk=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    gensio
    libxcrypt
    libyaml
  ];

  meta = {
    description = "Serial to network connection server";
    homepage = "https://github.com/cminyard/ser2net";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "ser2net";
    maintainers = [ ];
  };
})
