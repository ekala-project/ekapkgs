{
  cmake,
  fetchFromGitLab,
  glm,
  jsoncpp,
  lib,
  libGL,
  openxr-loader,
  python3,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencomposite";
  version = "1.0.1521";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-qi1iqlsr0P+Hw63O3ayCBIEGdNtkhl8FCPcs/m0WIzs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  buildInputs = [
    glm
    jsoncpp
    libGL
    vulkan-headers
    vulkan-loader
    libx11
  ];

  cmakeEntries = {
    CMAKE_CXX_FLAGS = "-Wno-error=format-security";
    USE_SYSTEM_OPENXR = false;
    USE_SYSTEM_GLM = true;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencomposite
    cp -r bin/ $out/lib/opencomposite
    touch $out/lib/opencomposite/bin/version.txt
    runHook postInstall
  '';
  meta = {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = lib.licenses.gpl3Only;
    # This can realistically only work on systems that support OpenXR Loader
    inherit (openxr-loader.meta) platforms;
  };
})
