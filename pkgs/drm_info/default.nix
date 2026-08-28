{
  lib,
  stdenv,
  fetchFromGitLab,
  libdrm,
  libdisplay-info,
  json_c,
  pciutils,
  meson,
  ninja,
  pkg-config,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drm_info";
  version = "2.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "drm_info";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QKF0frDPelwHOzf3r0tzSo7i1WfGhcFGJfxf2bj1+OE=";
  };

  strictDeps = true;

  postPatch = ''
    # Replace the libdrm version check block with a direct fourcc_h assignment
    # Our libdrm is older than 2.4.134, but the subproject fallback isn't available
    substituteInPlace meson.build \
      --replace-fail "if libdrm.version().version_compare('<2.4.134')" "if false"
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    libdrm
    libdisplay-info
    json_c
    pciutils
  ];

  meta = {
    description = "Small utility to dump info about DRM devices";
    mainProgram = "drm_info";
    homepage = "https://gitlab.freedesktop.org/emersion/drm_info";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
