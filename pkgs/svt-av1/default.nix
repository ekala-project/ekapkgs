{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  nasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1";
  version = "2.3.0";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JMOFWke/qO3cWHuhWJChzaH+sD5AVqYCTTz0Q0+r2AE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    nasm
  ];

  cmakeFlags = [
    "-DSVT_AV1_LTO=ON"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/AOMediaCodec/SVT-AV1";
    description = "AV1-compliant encoder/decoder library core";
    changelog = "https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with licenses; [
      aom
      bsd3
    ];
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
