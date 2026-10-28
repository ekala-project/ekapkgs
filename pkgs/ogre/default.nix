{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  unzip,
  sdl2-compat,
  boost,
  freetype,
  libpng,
  ois,
  pugixml,
  zziplib,
  # linux
  libglut,
  libGL,
  libGLU,
  libice,
  libsm,
  libx11,
  libxaw,
  libxmu,
  libxrandr,
  libxrender,
  libxt,
  libxxf86vm,
  xorgproto,

  withNvidiaCg ? false,
  nvidia_cg_toolkit,
  withSamples ? false,
}:

let
  imguiSrc = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v1.92.9b";
    hash = "sha256-IjW+qddzKu9jOj3QCGhkChVK2UOvwl493ffUIIn/ZVQ=";
  };

  imguiVersion = "1.92.9b";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ogre";
  version = "14.6.0";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dgMSn3kwgcToAhFDWRfL+E8zz/4rF4qqc7lCSiyeV68=";
  };

  postPatch = ''
    mkdir -p build
    cp -R ${imguiSrc} build/imgui-${imguiVersion}
    chmod -R u+w build/imgui-${imguiVersion}
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    unzip
  ];

  buildInputs = [
    sdl2-compat
    boost
    freetype
    libpng
    ois
    pugixml
    zziplib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libglut
    libGL
    libGLU
    libice
    libsm
    libx11
    libxaw
    libxmu
    libxrandr
    libxrender
    libxt
    libxxf86vm
    xorgproto
  ]
  ++ lib.optionals withNvidiaCg [
    nvidia_cg_toolkit
  ];

  cmakeEntries = {
    OGRE_BUILD_DEPENDENCIES = false;
    OGRE_BUILD_SAMPLES = withSamples;
  };

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "OGRE_BUILD_LIBS_AS_FRAMEWORK" false)
  ];

  meta = {
    description = "3D Object-Oriented Graphics Rendering Engine";
    homepage = "https://www.ogre3d.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
