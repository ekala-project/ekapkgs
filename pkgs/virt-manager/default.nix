{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  gtk4,
  docutils,
  gtk-vnc,
  vte,
  dconf,
  gobject-introspection,
  libvirt-glib,
  gsettings-desktop-schemas,
  libosinfo,
  adwaita-icon-theme,
  gtksourceview4,
  libayatana-appindicator,
  spiceSupport ? true,
  spice-gtk ? null,
  gstreamer,
}:

let
  pythonDependencies = with python3.pkgs; [
    pygobject3
    # TODO(corepkgs): port libvirt-python for full libvirt integration
    libxml2
    requests
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "virt-manager";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "virt-manager";
    repo = "virt-manager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nMWLDo2pfWcqsVuEk0JbzLZ1a0lViTohsZ8gEXGhBuI=";
  };

  strictDeps = true;

  mesonEntries = {
    compile-schemas = false;
  };

  mesonFeatures = {
    tests = false;
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gobject-introspection
    docutils
    gtk4.wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    python3
    libvirt-glib
    vte
    dconf
    gtk-vnc
    adwaita-icon-theme
    gsettings-desktop-schemas
    libosinfo
    gtksourceview4
    libayatana-appindicator
  ]
  ++ lib.optionals spiceSupport [
    gstreamer.pkgs.gst-plugins-base
    gstreamer.pkgs.gst-plugins-good
    spice-gtk
  ];

  postInstall = ''
    if ! grep -q StartupWMClass= "$out/share/applications/virt-manager.desktop"; then
        echo "StartupWMClass=.virt-manager-wrapped" >> "$out/share/applications/virt-manager.desktop"
    fi
  '';

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/virt-manager-${finalAttrs.version}/glib-2.0/schemas

    gappsWrapperArgs+=(--set PYTHONPATH "${python3.pkgs.makePythonPath pythonDependencies}")
    # TODO(corepkgs): add xorriso for virt-install ISO injection

    patchShebangs $out/bin
  '';

  meta = {
    description = "Desktop user interface for managing virtual machines";
    homepage = "https://virt-manager.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    mainProgram = "virt-manager";
  };
})
