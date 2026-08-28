{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdds";
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "mdds";
    repo = "mdds";
    rev = finalAttrs.version;
    hash = "sha256-8xI0RmxMDvXp2rPWEd6Yu2i7q3ba8nSLBMF8SKjdIBs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    mkdir -p $out/lib/
    mv $out/share/pkgconfig $out/lib/
  '';

  meta = {
    homepage = "https://gitlab.com/mdds/mdds";
    description = "Collection of multi-dimensional data structure and indexing algorithms";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
