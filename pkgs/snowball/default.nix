{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snowball";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FpvV2brpjl0/l/EmrHN9tWFrXUUz9BDUH548MAjiTa8=";
  };

  nativeBuildInputs = [ perl ];

  preBuild = ''
    chmod +x libstemmer/mkalgorithms.pl libstemmer/mkmodules.pl
    patchShebangs .
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  installTargets = [ "install" ];

  meta = {
    description = "Snowball stemming language and C/Java library";
    homepage = "https://snowballstem.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
