{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ansifilter";
  version = "2.22";

  src = fetchFromGitLab {
    owner = "saalen";
    repo = "ansifilter";
    tag = finalAttrs.version;
    hash = "sha256-jCgucC5mHkDwVtTKP92RBStxpouQCR7PHWkDt0y+9BM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  postPatch = ''
    # avoid timestamp non-determinism with '-n'
    substituteInPlace makefile --replace-fail 'gzip -9f' 'gzip -9nf'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "conf_dir=/etc/ansifilter"
  ];

  meta = {
    description = "ANSI sequence filter";
    mainProgram = "ansifilter";
    homepage = "https://gitlab.com/saalen/ansifilter";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
