{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  autoreconfHook,
  autoconf-archive,
  libx11,
  libxext,
  libxfixes,
  libxcomposite,
  libxinerama,
  libxrandr,
  pkg-config,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrot";
  version = "2.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "scrot";
    tag = finalAttrs.version;
    hash = "sha256-sxvopl04sMHyI3v2SH5O+QnlMneWThJKgFzYIe7t/58=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    libx11
    libxext
    libxfixes
    libxcomposite
    libxinerama
    libxrandr
    libbsd
  ];
  meta = {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "Command-line screen capture utility";
    mainProgram = "scrot";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.mitAdvertising;
  };
})
