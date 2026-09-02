{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surgescript";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "alemart";
    repo = "surgescript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m6H9cyoUY8Mgr0FDqPb98PRJTgF7DgSa+jC+EM0TDEw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/alemart/surgescript/commit/21a9c0696d592b7cc21e07db828fb93a12c95a7e.patch?full_index=1";
      hash = "sha256-d0l0xSrhJPIE5dMpEHdRlAMaD3f9x1IGBUpvjcMwDMs=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  meta = {
    mainProgram = "surgescript";
    description = "Scripting language for games";
    homepage = "https://docs.opensurge2d.org/";
    downloadPage = "https://github.com/alemart/surgescript";
    changelog = "https://github.com/alemart/surgescript/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
