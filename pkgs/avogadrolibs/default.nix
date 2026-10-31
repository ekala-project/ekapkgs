{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  eigen,
  libGL,
  spglib,
  mmtf-cpp,
  glew,
  python3,
  libarchive,
  libmsym,
  jkqtplotter,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avogadrolibs";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadrolibs";
    tag = finalAttrs.version;
    hash = "sha256-Un1TSXFucCFmHq8DoWQS7RaNgtXiD2JcXGueavugU64=";
  };

  postUnpack =
    let
      moleculesRepo = fetchFromGitHub {
        owner = "OpenChemistry";
        repo = "molecules";
        tag = finalAttrs.version;
        hash = "sha256-hMLf0gYYnQpjSGKcPy4tihNbmpRR7UxnXF/hyhforgI=";
      };
      crystalsRepo = fetchFromGitHub {
        owner = "OpenChemistry";
        repo = "crystals";
        tag = finalAttrs.version;
        hash = "sha256-WhzFldaOt/wJy1kk+ypOkw1OYFT3hqD7j5qGdq9g+IY=";
      };
      fragmentsRepo = fetchFromGitHub {
        owner = "OpenChemistry";
        repo = "fragments";
        tag = finalAttrs.version;
        hash = "sha256-OLLcQX3a9j9rEJtBziEU4fCZB2DiDDzql2mr2KfSp70=";
      };
    in
    ''
      cp -r ${moleculesRepo} molecules
      cp -r ${crystalsRepo} crystals
      cp -r ${fragmentsRepo} fragments
    '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    python3
  ];

  buildInputs = [
    eigen
    zlib
    libGL
    spglib
    mmtf-cpp
    glew
    libarchive
    libmsym
    jkqtplotter
    qt6.qttools
  ];

  postInstall = ''
    substituteInPlace $out/lib/cmake/avogadrolibs/AvogadroLibsConfig.cmake \
      --replace-fail "$out/" ""

    substituteInPlace $out/lib/cmake/avogadrolibs/AvogadroLibsTargets.cmake \
      --replace-fail "_IMPORT_PREFIX \"$out\"" '_IMPORT_PREFIX "/"'
  '';

  meta = {
    description = "Molecule editor and visualizer";
    homepage = "https://github.com/OpenChemistry/avogadrolibs";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
})
