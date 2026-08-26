{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  expat,
  pkg-config,
  systemdLibs,
  version ? "1.5.0",
}:
let
  sources = {
    "1.5.0" = {
      hash = "sha256-oO8QNffwNI245AEPdutOGqxj4qyusZYK3bZWLh2Lcag=";
    };
    "2.2.1" = {
      hash = "sha256-uC31StWk3qATPyshX7MkwrxEcBASeIv4e5/jtgzZzMQ=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sdbus-cpp";
  inherit version;

  src = fetchFromGitHub {
    owner = "kistler-group";
    repo = "sdbus-cpp";
    rev = "v${version}";
    inherit (sources.${version}) hash;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    expat
    systemdLibs
  ];

  cmakeFlags = [
    (lib.cmakeBool (
      if lib.versionOlder finalAttrs.version "2.0.0" then "BUILD_CODE_GEN" else "SDBUSCPP_BUILD_CODEGEN"
    ) true)
  ];

  meta = {
    homepage = "https://github.com/Kistler-Group/sdbus-cpp";
    changelog = "https://github.com/Kistler-Group/sdbus-cpp/blob/v${version}/ChangeLog";
    description = "High-level C++ D-Bus library designed to provide easy-to-use yet powerful API";
    license = lib.licenses.lgpl2Only;
    maintainers = [ ];
    mainProgram = "sdbus-c++-xml2cpp";
    platforms = lib.platforms.linux;
  };
})
