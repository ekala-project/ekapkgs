{
  lib,
  stdenv,
  bash-completion,
  fetchurl,
  fetchpatch,
  gdbm,
  glib,
  gst_all_1,
  gsettings-desktop-schemas,
  gtk-vnc,
  gtk3,
  intltool,
  libcap,
  libgovirt,
  ovirtSupport ? false,
  libvirt,
  libvirt-glib ? null,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  shared-mime-info,
  spice-gtk ? null,
  spice-protocol,
  spiceSupport ? (spice-gtk != null),
  vte,
  wrapGAppsHook3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "virt-viewer";
  version = "11.0";

  src = fetchurl {
    url = "https://releases.pagure.org/virt-viewer/virt-viewer-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-pD+iMlxMHHelyMmAZaww7wURohrJjlkPIjQIabrZq9A=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/virt-viewer/virt-viewer/-/commit/98d9f202ef768f22ae21b5c43a080a1aa64a7107.patch";
      sha256 = "sha256-3AbnkbhWOh0aNjUkmVoSV/9jFQtvTllOr7plnkntb2o=";
    })
  ];

  nativeBuildInputs = [
    glib
    intltool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    shared-mime-info
    wrapGAppsHook3
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    bash-completion
    glib
    gsettings-desktop-schemas
    gtk-vnc
    gtk3
    libvirt
    libxml2
    vte
  ]
  ++ lib.optional (libvirt-glib != null) libvirt-glib
  ++ lib.optionals ovirtSupport [
    libgovirt
  ]
  ++ lib.optionals spiceSupport [
    gdbm
    spice-gtk
    spice-protocol
    libcap
  ];

  propagatedUserEnvPkgs = lib.optional (spiceSupport && spice-gtk != null) spice-gtk;

  mesonFlags = [
    (lib.mesonEnable "ovirt" ovirtSupport)
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs build-aux/post_install.py
  '';

  meta = {
    homepage = "https://virt-manager.org/";
    description = "Viewer for remote virtual machines";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    mainProgram = "virt-viewer";
  };
})
