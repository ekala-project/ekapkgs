{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "sha256-I9fpqbprxunK4B+Qheo68DRKWkcX9H838PJ3Bx4qh5Q=";
  };

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-archflags=\"-mmacosx-version-min=10.14\""
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
