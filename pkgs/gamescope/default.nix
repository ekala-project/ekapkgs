{
  stdenv,
  buildPackages,
  fetchFromGitHub,
  fetchpatch,
  lib,
  meson,
  pkg-config,
  ninja,
  cmake,
  libxxf86vm,
  libxtst,
  libxres,
  libxrender,
  libxmu,
  libxi,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  xwininfo,
  xprop,
  libxcb,
  libdrm,
  libei,
  vulkan-loader,
  vulkan-headers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  glm,
  libcap,
  libavif,
  sdl2-compat,
  pipewire,
  pixman,
  python3,
  libinput,
  glslang,
  hwdata,
  stb,
  wlroots,
  libdecor,
  lcms,
  luajit,
  makeBinaryWrapper,
  patchelf,
  enableExecutable ? true,
  enableWsi ? false,
}:
let
  frogShaders = fetchFromGitHub {
    owner = "misyltoad";
    repo = "GamescopeShaders";
    rev = "v0.1";
    hash = "sha256-gR1AeAHV/Kn4ntiEDUSPxASLMFusV6hgSGrTbMCBUZA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gamescope";
  version = "3.16.25";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-KPIUoHMzArqEVbhS8hrvzQUV906MydBPm5ZmV/CVS3A=";
  };

  patches = [
    # Make it look for data in the right place
    ./shaders-path.patch
    # patch relative gamescopereaper path with absolute
    ./gamescopereaper.patch

    # Pending upstream patch to allow using system libraries
    # See: https://github.com/ValveSoftware/gamescope/pull/1846
    (fetchpatch {
      url = "https://github.com/ValveSoftware/gamescope/commit/4ce1a91fb219f570b0871071a2ec8ac97d90c0bc.diff";
      hash = "sha256-O358ScIIndfkc1S0A8g2jKvFWoCzcXB/g6lRJamqOI4=";
    })

    # Pending upstream patch to support stb_image_resize2.h
    # See: https://github.com/ValveSoftware/gamescope/pull/2130
    (fetchpatch {
      url = "https://github.com/ValveSoftware/gamescope/commit/d49a2aded261030e649fee42ad295f1ef56b736b.diff";
      hash = "sha256-Uh08ZRaV912ZOsl1DMpbVLxIgh4jEXevgihQf2W9KFk=";
    })
  ];

  # We can't substitute the patch itself because substituteAll is itself a derivation,
  # so `placeholder "out"` ends up pointing to the wrong place
  postPatch = ''
    substituteInPlace src/Utils/DirHelpers.cpp --replace-fail "@out@" "$out"

    # Patching shebangs in the main `libdisplay-info` build
    patchShebangs subprojects/libdisplay-info/tool/gen-search-table.py

    # Replace gamescopereaper with absolute path
    substituteInPlace src/Utils/Process.cpp --subst-var-by "gamescopereaper" "$out/bin/gamescopereaper"
    patchShebangs default_extras_install.sh
  '';

  mesonEntries = {
    enable_gamescope = enableExecutable;
    enable_gamescope_wsi_layer = enableWsi;
    enable_tests = false;
    benchmark = "disabled";
    glm_include_dir = "${lib.getInclude glm}/include";
    stb_include_dir = "${lib.getInclude stb}/include/stb";
  };

  # don't install vendored vkroots etc
  mesonInstallFlags = [ "--skip-subprojects" ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
    wayland-scanner

    # For OpenVR
    cmake

    # calls git describe to encode its own version into the build
    (buildPackages.writeShellScriptBin "git" "echo ${finalAttrs.version}")
  ]
  ++ lib.optionals enableExecutable [
    makeBinaryWrapper
    glslang

    # For `libdisplay-info`
    python3
    hwdata
  ];

  buildInputs = [
    pipewire
    hwdata
    libx11
    libxcb
    wayland
    wayland-protocols
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals enableExecutable (
    wlroots.buildInputs
    ++ [
      # gamescope uses a custom wlroots branch
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxi
      libxmu
      libxrender
      libxres
      libxtst
      libxxf86vm
      libavif
      libdrm
      libei
      sdl2-compat
      libdecor
      libinput
      libxkbcommon
      pixman
      libcap
      lcms
      luajit
    ]
  );

  postInstall = lib.optionalString enableExecutable ''
    ${lib.getExe patchelf} $out/bin/gamescope \
      --add-rpath ${vulkan-loader}/lib --add-needed libvulkan.so.1

    # --debug-layers flag expects these in the path
    wrapProgram "$out/bin/gamescope" \
      --prefix PATH : ${
        lib.makeBinPath [
          xprop
          xwininfo
        ]
      }

    # Install ReShade shaders
    mkdir -p $out/share/gamescope/reshade
    cp -r ${frogShaders}/* $out/share/gamescope/reshade/
  '';

  meta = {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/ValveSoftware/gamescope";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    mainProgram = "gamescope";
  };
})
