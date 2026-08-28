{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  zlib,
  bzip2,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wandio";
  version = "4.2.7-1";

  src = fetchFromGitHub {
    owner = "LibtraceTeam";
    repo = "wandio";
    tag = finalAttrs.version;
    hash = "sha256-2lsECBtbyTc+xlOeuOdEMZr/qdlWtPPaMCbJf+nGHWE=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    zlib
    bzip2
    xz
  ];
  meta = {
    description = "C library for simple and efficient file IO";
    homepage = "https://github.com/LibtraceTeam/wandio";
    changelog = "https://github.com/LibtraceTeam/wandio/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.unix;
  };
})
