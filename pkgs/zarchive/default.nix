{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zarchive";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Exzap";
    repo = "ZArchive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hX637O/mVLTzmG0a9swJu9w+3o26VHo+K/9RhMuf1lI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [ zstd ];

  meta = {
    description = "File archive format supporting random-access reads";
    homepage = "https://github.com/Exzap/ZArchive";
    license = lib.licenses.mit0;
    mainProgram = "zarchive";
  };
})
