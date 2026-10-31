{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,

  sdl2-compat,
  boost,
  bullet,
  cmake,
  collada-dom,
  ffmpeg,
  libxt,
  lua5_2_compat,
  luajit,
  lz4,
  mygui,
  openal-soft,
  openscenegraph,
  pkg-config,
  qt6,
  recastnavigation,
  unshield,
  yaml-cpp,

  GLPreference ? "GLVND",
}:
let
  lua = lua5_2_compat;
  inherit (stdenv.hostPlatform) isDarwin isLinux isAarch64;
  isAarch64Linux = isLinux && isAarch64;
in
assert lib.assertOneOf "GLPreference" GLPreference [
  "GLVND"
  "LEGACY"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "openmw";
  version = "0.51.0";

  strictDeps = true;

  osg' = (openscenegraph.override { colladaSupport = true; }).overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (fetchpatch {
        name = "darwin-osg-plugins-fix.patch";
        url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/1305497c009dc0e7a6a70fe14f0a2f92b96cbcb4/macos/osg.patch";
        hash = "sha256-G8Y+fnR6FRGxECWrei/Ixch3A3PkRfH6b5q9iawsSCY=";
      })
    ];
    cmakeFlags =
      (oldAttrs.cmakeFlags or [ ])
      ++ [
        "-Wno-dev"
        (lib.cmakeFeature "OpenGL_GL_PREFERENCE" GLPreference)
        (lib.cmakeBool "BUILD_OSG_PLUGINS_BY_DEFAULT" false)
        (lib.cmakeBool "BUILD_OSG_DEPRECATED_SERIALIZERS" false)
      ]
      ++ (map (plugin: lib.cmakeBool "BUILD_OSG_PLUGIN_${plugin}" true) [
        "BMP"
        "DAE"
        "DDS"
        "FREETYPE"
        "JPEG"
        "OSG"
        "PNG"
        "TGA"
      ]);
  });

  bullet' = bullet.overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      (lib.cmakeFeature "OpenGL_GL_PREFERENCE" GLPreference)
      (lib.cmakeBool "USE_DOUBLE_PRECISION" true)
      (lib.cmakeBool "BULLET2_MULTITHREADING" true)
    ];
  });

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    tag = "openmw-${finalAttrs.version}";
    hash = "sha256-D+2nEQRkAjmDvRoas9bYPmdygQYT3MAv46n73OonE0o=";
  };

  postPatch = ''
    sed '1i#include <memory>' -i components/myguiplatform/myguidatamanager.cpp
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  dontWrapQtApps = isDarwin;

  buildInputs = [
    sdl2-compat
    boost
    collada-dom
    ffmpeg
    libxt
    (if isAarch64Linux then lua else luajit)
    lz4
    mygui
    openal-soft
    recastnavigation
    unshield
    yaml-cpp
    qt6.qttools
  ]
  ++ (with finalAttrs; [
    bullet'
    osg'
  ]);

  cmakeFlags = [
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" GLPreference)
    (lib.cmakeBool "USE_LUAJIT" (!isAarch64Linux))
    (lib.cmakeBool "OPENMW_USE_SYSTEM_RECASTNAVIGATION" true)
  ];

  env.LANG = "C.UTF-8";

  meta = {
    description = "Unofficial open source engine reimplementation of the game Morrowind";
    homepage = "https://openmw.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
