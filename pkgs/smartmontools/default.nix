{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnused,
  hostname,
  systemdLibs,
}:

let
  scriptPath = lib.makeBinPath [
    gnused
    hostname
  ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "smartmontools";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "smartmontools";
    repo = "smartmontools";
    tag = "RELEASE_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-/2J73F97yiPlUnGkzewWzU+sARaeqgVc/3ScjVlHhQE=";
  };

  prePatch = ''
    cd smartmontools
  '';
  patches = [
    ./smartmontools.patch
  ];
  postPatch = ''
    ln -sf "$drivedb" drivedb.h
  '';

  configureFlags = [
    "--with-scriptpath=${scriptPath}"
    "--without-update-smart-drivedb"
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (lib.meta.availableOn stdenv.hostPlatform systemdLibs) [ systemdLibs ];
  enableParallelBuilding = true;

  drivedb = fetchFromGitHub {
    owner = "smartmontools";
    repo = "smartmontools";
    rev = "794fa5069ee298c82f93ff0a7f7ef6a5fdd10e5e";
    hash = "sha256-WBed5elI+WsIiIJ1YVkdVGJ4XMrGRFIFWqk6ffVl0bU=";
    postFetch = ''
      mv "$out/smartmontools/drivedb.h" "$TMPDIR/drivedb.h"
      rm -rf "$out"
      mv "$TMPDIR/drivedb.h" "$out"
    '';
  };

  meta = {
    description = "Tools for monitoring the health of hard drives";
    homepage = "https://www.smartmontools.org/";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "smartctl";
  };
})
