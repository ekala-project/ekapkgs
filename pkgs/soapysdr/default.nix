{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  libusb-compat-0_1 ? null,
  ncurses,
  usePython ? false,
  python ? null,
  swig ? null,
  extraPackages ? [ ],
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapysdr";
  version = "0.8.1-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDR";
    rev = "1551ea0d39ce546b32a15808b9b1241018a89fc8";
    hash = "sha256-k1ocvnkgmucewWeUgj7hY8hj9gOBl3G2iH9KM2h/Sck=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    ncurses
  ]
  ++ lib.optionals (libusb-compat-0_1 != null) [ libusb-compat-0_1 ]
  ++ lib.optionals usePython (
    lib.optionals (python != null) [ python ] ++ lib.optionals (swig != null) [ swig ]
  );

  propagatedBuildInputs = lib.optionals (usePython && python != null) [ python.pkgs.numpy ];

  cmakeFlags = lib.optionals usePython [ "-DUSE_PYTHON_CONFIG=ON" ];

  postFixup = lib.optionalString (extraPackages != [ ]) (
    lib.pipe extraPackages [
      (map (pkg: ''
        ${buildPackages.lndir}/bin/lndir -silent ${pkg} $out
      ''))
      lib.concatStrings
    ]
    + ''
      for file in $out/bin/*; do
          wrapProgram "$file" --prefix SOAPY_SDR_PLUGIN_PATH : ${lib.escapeShellArg (lib.makeSearchPath finalAttrs.passthru.searchPath extraPackages)}
      done
    ''
  );

  passthru = {
    abiVersion = "0.8-3";
    searchPath = "lib/SoapySDR/modules${finalAttrs.passthru.abiVersion}";
  };

  meta = {
    homepage = "https://github.com/pothosware/SoapySDR";
    description = "Vendor and platform neutral SDR support library";
    license = lib.licenses.boost;
    mainProgram = "SoapySDRUtil";
    platforms = lib.platforms.unix;
  };
})
