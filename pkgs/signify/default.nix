{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "signify";
  version = "33";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "signify";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-cBeCnhLwhRnIVa/naNl5AysSg5RncnOtQpmTHNicHAo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libbsd ];

  postPatch = ''
    substituteInPlace Makefile --replace "shell pkg-config" "shell $PKG_CONFIG"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "OpenBSD signing tool";
    mainProgram = "signify";
    homepage = "https://www.tedunangst.com/flak/post/signify";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
  };
})
