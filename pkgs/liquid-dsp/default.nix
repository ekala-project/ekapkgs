{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  # TODO(ekapkgs): support darwin
  # darwin,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "sha256-QRCPdngQCpC+o8fCLVoixPsZ25yI1ZEo8ePreC2S0Yk=";
  };

  patches = [
    # liquid.h uses va_list; needs stdarg.h
    ./include-stdarg.patch
  ];

  # Fix CMake absolute include/lib paths in .pc file, see also
  # - https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace cmake/liquid-dsp.pc.in \
      --replace-fail 'libdir=@libdir_for_pc_file@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=@includedir_for_pc_file@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # TODO(ekapkgs): support darwin
    # darwin.autoSignDarwinBinariesHook
    fixDarwinDylibNames
  ];

  cmakeFlags = [
    # Prevent native cpu arch from leaking into binaries.
    (lib.cmakeBool "ENABLE_SIMD" false)
    (lib.cmakeBool "FIND_SIMD" false)
  ];

  doCheck = true;

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
