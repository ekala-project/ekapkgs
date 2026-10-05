{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orocos-kdl";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "orocos";
    repo = "orocos_kinematics_dynamics";
    tag = finalAttrs.version;
    hash = "sha256-0ImnuCx6IHIGFEmxOiYsC9C0Jgd5zz0UlgcQbxhngI4=";
    fetchSubmodules = true; # Needed to build Python bindings
  };

  sourceRoot = "${finalAttrs.src.name}/orocos_kdl";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  propagatedBuildInputs = [ eigen ];

  meta = {
    description = "Kinematics and Dynamics Library";
    homepage = "https://www.orocos.org/kdl.html";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
  };
})
