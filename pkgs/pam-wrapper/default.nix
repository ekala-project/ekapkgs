{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  pam,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_wrapper";
  version = "1.1.7";

  src = fetchFromGitLab {
    owner = "cwrap";
    repo = "pam_wrapper";
    tag = "pam_wrapper-${finalAttrs.version}";
    hash = "sha256-KAlZI3uS7ETyN/7JgUyquDsEfvKGvcXL9S/BMxNSwoo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
  ];

  buildInputs = [ pam ];

  meta = {
    description = "PAM wrapper library for testing PAM modules";
    homepage = "https://cwrap.org/pam_wrapper.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
