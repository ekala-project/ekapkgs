{
  fetchurl,
  fetchpatch,
  runCommand,
  lib,
  stdenv,
  pkg-config,
  gettext,
  gobject-introspection,
  cairo,
  pango,
  ninja,
  meson,
  gtk4,
  glib,
  graphene,
  libdrm,
  libinput,
  pipewire,
  wayland,
  wayland-protocols,
  libxkbcommon,
  mesa,
  libcanberra,
  gnome-desktop,
  gsettings-desktop-schemas,
  libgudev,
  dbus,
  python3,
  libei,
  xwayland,
  egl-wayland,
  fribidi,
  harfbuzz,
  atk,
  libadwaita,
  libxcvt,
  colord,
  lcms2,
  libwacom,
  libstartup_notification,
  libsm,
  libice,
  libdisplay-info,
  libepoxy,
  libgbm,
  libGL,
  gnome-settings-daemon,
  # TODO: sysprof is available but marked broken in ekapkgs
  sysprof ? null,
  libsysprof-capture,
  # TODO: libglycin is not yet available in ekapkgs
  libglycin ? null,
  mesa-gl-headers,
  gi-docgen,
  desktop-file-utils,
  docutils,
  # TODO: xvfb-run is not yet available in ekapkgs
  xvfb-run ? null,
  xorg-server,
  wayland-scanner,
  wrapGAppsHook4,
  udevCheckHook,
  libxcb,
  # X11 libs from xorg set (available)
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mutter";
  version = "50.4";

  outputs = [
    "out"
    "dev"
    "man"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.major finalAttrs.version}/mutter-${finalAttrs.version}.tar.xz";
    hash = "sha256-Jz0zyHWry0tsvqP07ARdGBVfvFEMNSH8fkeSY3ExCYg=";
  };

  patches = [
    # Fix HDR corruption by reverting a problematic commit. See:
    # - https://gitlab.gnome.org/GNOME/mutter/-/work_items/4952
    # - https://gitlab.gnome.org/GNOME/mutter/-/work_items/4967
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/a1ae71798ef1ab2e0d2f753f5c98b38b1039b056.patch";
      hash = "sha256-J2eKhM3YEFEVmcpMq2SxSOsPeEWrJTv+UcBDO+gRC4M=";
      revert = true;
    })
  ];

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false"
    "-Dtests=disabled"
    # For NVIDIA proprietary driver up to 470.
    # https://src.fedoraproject.org/rpms/mutter/pull-request/49
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
    # This should be auto detected, but it looks like it manages a false
    # positive.
    "-Dxwayland_initfd=disabled"
    "-Ddocs=true"
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect mutter-mtk
    graphene
    mesa-gl-headers
  ];

  nativeBuildInputs = [
    gettext
    glib
    libxcvt
    meson
    ninja
    pkg-config
    python3
    gobject-introspection
    desktop-file-utils
    wayland-scanner
    wrapGAppsHook4
    gi-docgen
    docutils # for rst2man
    xorg-server
    udevCheckHook
  ]
  ++ lib.optional (xvfb-run != null) xvfb-run;

  buildInputs = [
    cairo
    egl-wayland
    glib
    gnome-desktop
    gsettings-desktop-schemas
    atk
    fribidi
    harfbuzz
    libcanberra
    libdrm
    libadwaita
    libei
    libgudev
    libinput
    libstartup_notification
    libwacom
    libsm
    colord
    lcms2
    pango
    pipewire
    xwayland
    wayland
    wayland-protocols
    # X11 client
    gtk4
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.xkeyboardconfig
    libxkbcommon
    libxcb
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXau

    # TODO: pygobject3, dbus-python not available in ekapkgs python packages
    python3
    gnome-settings-daemon
    libgbm
    libepoxy
    libdisplay-info
    libGL
    libsysprof-capture
  ]
  ++ lib.optional (libglycin != null) libglycin
  ++ lib.optional (sysprof != null) sysprof; # for D-Bus interfaces

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py

    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3981
    substituteInPlace src/frames/main.c \
      --replace-fail "libadwaita-1.so.0" "${libadwaita}/lib/libadwaita-1.so.0"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    # TODO: Move this into a directory devhelp can find.
    moveToOutput "share/mutter-${finalAttrs.passthru.libmutter_api_version}/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  env.PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;
  strictDeps = true;

  doInstallCheck = true;

  passthru = {
    libmutter_api_version = "18"; # bumped each dev cycle
    libdir = "${finalAttrs.finalPackage}/lib/mutter-${finalAttrs.passthru.libmutter_api_version}";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" { } ''
        if [[ ! -d ${finalAttrs.finalPackage.libdir} ]]; then
          echo "passthru.libdir should contain a directory, "${finalAttrs.finalPackage.libdir}" is not one."
          exit 1
        fi
        touch $out
      '';
    };
  };

  meta = {
    description = "Window manager for GNOME";
    mainProgram = "mutter";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    changelog = "https://gitlab.gnome.org/GNOME/mutter/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
