{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  bzip2,
  libxml2,
  minizip,
  pkg-config,
  pcre-cpp ? null,
  readline,
  uriparser,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collada-dom";
  version = "2.5.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "collada-dom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6V1Ew1YWybgqt0dikNdXwK+4D1odgVN/7NvaikjRqE4=";
  };

  postInstall = ''
    ln -s $out/include/*/* $out/include
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    bzip2
    libxml2
    minizip
    readline
    uriparser
    zlib
  ]
  ++ lib.optional (pcre-cpp != null) pcre-cpp;

  cmakeFlags = [
    (lib.cmakeBool "OPT_COMPILE_TESTS" finalAttrs.doCheck)
  ];

  doCheck = true;

  meta = {
    description = "API that provides a C++ object representation of a COLLADA XML instance document";
    homepage = "https://github.com/Gepetto/collada-dom";
    changelog = "https://github.com/Gepetto/collada-dom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
