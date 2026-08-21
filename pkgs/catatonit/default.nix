{
  stdenv,
  lib,
  autoreconfHook,
  fetchFromGitHub,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catatonit";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "catatonit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-sc/T4WjCPFfwUWxlBx07mQTmcOApblHygfVT824HcJM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isMusl) [
    glibc
    glibc.static
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  installCheckPhase = ''
    readelf -d $out/bin/catatonit | grep 'There is no dynamic section in this file.'
  '';
  meta = {
    description = "Container init that is so simple it's effectively brain-dead";
    homepage = "https://github.com/openSUSE/catatonit";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
    mainProgram = "catatonit";
  };
})
