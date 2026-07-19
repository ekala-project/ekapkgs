{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pegtl";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "taocpp";
    repo = "PEGTL";
    rev = finalAttrs.version;
    hash = "sha256-nPWSO2wPl/qenUQgvQDQu7Oy1dKa/PnNFSclmkaoM8A=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    homepage = "https://github.com/taocpp/pegtl";
    description = "Parsing Expression Grammar Template Library";
    license = lib.licenses.boost;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
