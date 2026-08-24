{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  lua5_4,
  curl,
  libxml2,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbfc-linux";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "nbfc-linux";
    repo = "nbfc-linux";
    tag = finalAttrs.version;
    hash = "sha256-x2boeFlTDnoVnazzQkCukZxZBFIW2rLjglarflNy334=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    lua5_4
    curl
    libxml2
    openssl
  ];

  configureFlags = [
    "--bindir=${placeholder "out"}/bin"
  ];

  meta = {
    description = "C port of Stefan Hirschmann's NoteBook FanControl";
    longDescription = ''
      nbfc-linux provides fan control service for notebooks
    '';
    homepage = "https://github.com/nbfc-linux/nbfc-linux";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "nbfc";
    platforms = lib.platforms.linux;
  };
})
