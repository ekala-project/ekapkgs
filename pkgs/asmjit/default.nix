{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
}:

stdenv.mkDerivation {
  pname = "asmjit";
  version = "0-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "0bd5787b54b575ed94bf32ac452153b34385c514";
    hash = "sha256-mBnpoTG2c6RrTjOYSIeIANQKE6Uvd3/dnBGDnw3AfSA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  strictDeps = true;

  meta = {
    description = "Machine code generation for C++";
    longDescription = ''
      AsmJit is a lightweight library for machine code generation written in
      C++ language. It can generate machine code for X86, X86_64, and AArch64
      architectures and supports baseline instructions and all recent
      extensions.
    '';
    homepage = "https://asmjit.com/";
    license = lib.licenses.zlib;
  };
}
