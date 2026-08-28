{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lm_sensors,
  yaml-cpp,
  pkg-config,
  procps,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thinkfan";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "vmatare";
    repo = "thinkfan";
    tag = finalAttrs.version;
    hash = "sha256-QqDWPOXy8E+TY5t0fFRAS8BGA7ZH90xecv5UsFfDssk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc" "$out/etc"
    substituteInPlace rcscripts/systemd/thinkfan-sleep.service \
      --replace-fail "/usr/bin/pkill" "${lib.getExe' procps "pkill"}"
    substituteInPlace rcscripts/systemd/thinkfan-sleep.service \
      --replace-fail "ExecStart=sleep " "ExecStart=${lib.getExe' coreutils "sleep"} "
    substituteInPlace rcscripts/systemd/thinkfan-wakeup.service \
      --replace-fail "/usr/bin/pkill" "${lib.getExe' procps "pkill"}"
    substituteInPlace rcscripts/systemd/thinkfan.service.cmake \
      --replace-fail "/bin/kill" "${lib.getExe' procps "kill"}"
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_DOCDIR=share/doc/thinkfan"
    "-DUSE_NVML=OFF"
    "-DSYSTEMD_FOUND=ON"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    lm_sensors
    yaml-cpp
  ];

  meta = {
    description = "Simple, lightweight fan control program";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/vmatare/thinkfan";
    platforms = lib.platforms.linux;
    mainProgram = "thinkfan";
  };
})
