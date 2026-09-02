{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  ncurses,
  enableCApi ? true,
  enablePythonApi ? true,
  python3,
  enableExamples ? false,
  enableUtils ? true,
  libusb1,
  enableDpdk ? false,
  dpdk ? null,
  enableOctoClock ? true,
  enableMpmd ? true,
  enableB100 ? true,
  enableB200 ? true,
  enableUsrp1 ? true,
  enableUsrp2 ? true,
  enableX300 ? true,
  enableX400 ? true,
  enableN300 ? true,
  enableN320 ? true,
  enableE300 ? true,
  enableE320 ? true,
}:

let
  inherit (lib) optionals cmakeBool;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "uhd";
  version = "4.10.0.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nqazjHfYIVbqFnfiHdkz1Glws4+t5rgWmojWbi0Ymk8=";
  };

  uhdImagesSrc = fetchurl {
    url = "https://github.com/EttusResearch/uhd/releases/download/v${finalAttrs.version}/uhd-images_${finalAttrs.version}.tar.xz";
    sha256 = "1pqx5ajg1z8jk1lfh44m58sqf6ypbvn9jm89walfc1h38q4ykj38";
  };

  patches = [
    ./downstream-pkgs-boost1.89-fix.patch
  ];

  inherit (finalAttrs.finalPackage.passthru) pythonPath;
  passthru = {
    runtimePython = python3.withPackages (ps: finalAttrs.finalPackage.passthru.pythonPath);
    pythonPath =
      optionals (enablePythonApi || enableUtils) [
        python3.pkgs.numpy
        python3.pkgs.setuptools
      ]
      ++ optionals enableUtils [
        python3.pkgs.requests
        python3.pkgs.six
      ];
  };

  cmakeFlags = [
    (cmakeBool "ENABLE_LIBUHD" true)
    (cmakeBool "ENABLE_USB" true)
    (cmakeBool "ENABLE_TESTS" true)
    (cmakeBool "ENABLE_EXAMPLES" enableExamples)
    (cmakeBool "ENABLE_UTILS" enableUtils)
    (cmakeBool "ENABLE_C_API" enableCApi)
    (cmakeBool "ENABLE_PYTHON_API" enablePythonApi)
    "-DRUNTIME_PYTHON_EXECUTABLE=${lib.getExe finalAttrs.passthru.runtimePython}"
    (cmakeBool "ENABLE_DPDK" enableDpdk)
    (cmakeBool "ENABLE_OCTOCLOCK" enableOctoClock)
    (cmakeBool "ENABLE_MPMD" enableMpmd)
    (cmakeBool "ENABLE_B100" enableB100)
    (cmakeBool "ENABLE_B200" enableB200)
    (cmakeBool "ENABLE_USRP1" enableUsrp1)
    (cmakeBool "ENABLE_USRP2" enableUsrp2)
    (cmakeBool "ENABLE_X300" enableX300)
    (cmakeBool "ENABLE_X400" enableX400)
    (cmakeBool "ENABLE_N300" enableN300)
    (cmakeBool "ENABLE_N320" enableN320)
    (cmakeBool "ENABLE_E300" enableE300)
    (cmakeBool "ENABLE_E320" enableE320)
  ]
  ++ optionals stdenv.hostPlatform.isAarch32 [
    "-DCMAKE_CXX_FLAGS=-Wno-psabi"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
    python3.pkgs.mako
    python3.pkgs.wrapPython
  ];
  buildInputs =
    finalAttrs.pythonPath
    ++ [
      boost
      libusb1
    ]
    ++ optionals enableExamples [
      ncurses
      ncurses.dev
    ]
    ++ optionals enableDpdk [
      dpdk
    ];

  doCheck = true;

  doInstallCheck = true;

  # Build only the host software
  preConfigure = "cd host";

  postPhases = [
    "installFirmware"
    "removeInstalledTests"
  ]
  ++ optionals (enableUtils && stdenv.hostPlatform.isLinux) [
    "moveUdevRules"
  ];

  installFirmware = ''
    mkdir -p "$out/share/uhd/images"
    tar --strip-components=1 -xvf "${finalAttrs.uhdImagesSrc}" -C "$out/share/uhd/images"
  '';

  removeInstalledTests = ''
    rm -r $out/lib/uhd/tests
  '';

  moveUdevRules = ''
    mkdir -p $out/lib/udev/rules.d
    mv $out/lib/uhd/utils/uhd-usrp.rules $out/lib/udev/rules.d/
  '';

  postFixup = lib.optionalString (enablePythonApi && enableUtils) ''
    wrapPythonPrograms
  '';
  disallowedReferences = optionals (!enablePythonApi && !enableUtils) [
    python3
  ];

  meta = {
    description = "USRP Hardware Driver (for Software Defined Radio)";
    longDescription = ''
      The USRP Hardware Driver (UHD) software is the hardware driver for all
      USRP (Universal Software Radio Peripheral) devices.

      USRP devices are designed and sold by Ettus Research, LLC and its parent
      company, National Instruments.
    '';
    homepage = "https://uhd.ettus.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
