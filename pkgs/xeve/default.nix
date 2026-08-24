{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeve";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xeve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QA9+0PsPyg3gQYR2TpIO1nwL5H/BFpOtCX8xBQ4Qjmg=";
  };

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags =
    let
      inherit (lib) cmakeBool cmakeFeature optional;
      inherit (stdenv.hostPlatform) isAarch64 isDarwin;
    in
    optional isAarch64 (cmakeBool "ARM" true)
    ++ optional isDarwin (cmakeFeature "CMAKE_SYSTEM_NAME" "Darwin");

  env.NIX_CFLAGS_COMPILE = toString (
    map (w: "-Wno-" + w) [
      "parentheses-equality"
      "unknown-warning-option"

      # Fixed upstream in 325fd9f94f3fdf0231fa931a31ebb72e63dc3498 but might
      # change behavior, therefore opted to leave it out for now.
      "for-loop-analysis"
    ]
  );

  postInstall = ''
    ln $dev/include/xeve/* $dev/include/
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];
  meta = {
    homepage = "https://github.com/mpeg5/xeve";
    description = "eXtra-fast Essential Video Encoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xeve_app";
    maintainers = [ ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
})
