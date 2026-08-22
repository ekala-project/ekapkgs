{
  lib,
  autoreconfHook,
  bison,
  fetchFromGitLab,
  flex,
  perlPackages,
  pkg-config,
  spirv-headers,
  stdenv,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkd3d";
  version = "2.0";

  src = fetchFromGitLab {
    domain = "gitlab.winehq.org";
    owner = "wine";
    repo = "vkd3d";
    tag = "vkd3d-${finalAttrs.version}";
    hash = "sha256-S0sQaDt0aYYi2Rs/MNRIQ9oOuHm9/LsxaSL93M5jBRw=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perlPackages.perl
    perlPackages.JSON
    pkg-config
  ];

  buildInputs = [
    spirv-headers
    vulkan-headers
    vulkan-loader
  ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.winehq.org/wine/vkd3d";
    description = "Direct3D to Vulkan translation library";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "vkd3d-compiler";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
