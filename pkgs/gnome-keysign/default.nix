{
  lib,
  fetchFromGitLab,
  fetchpatch,
  python3,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  glib,
  gst_all_1,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gnome-keysign";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-keysign";
    rev = finalAttrs.version;
    hash = "sha256-k77z8Yligzs4rHpPckRGcC5qnCHynHQRjdDkzxwt1Ss=";
  };

  patches = [
    # Remove broken future dependency
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-keysign/-/commit/ea197254baf70a499a371678369eda85aff7a4c5.patch";
      hash = "sha256-Msd0NzNAkoAAxZ/WNiM3xV382lnx+xT6gyQiNGDEMM8=";
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ]
  ++ (with python3.pkgs; [
    babel
    # TODO: babelgladeextractor not yet available in ekapkgs
    babelgladeextractor
  ]);

  buildInputs = [
    # TODO: avahi not yet available in ekapkgs
    # avahi
    gtk3
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    # TODO: gst-plugins-good.override { gtkSupport = true; } needs override in top-level
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    # TODO: gst-plugins-bad.override { enableZbar = true; } needs override in top-level
    (gst_all_1.gst-plugins-bad.override { enableZbar = true; }) # for zbar plug-in
  ];

  propagatedBuildInputs = (with python3.pkgs; [
    dbus-python
    # TODO: gpg (python bindings for gpgme) not yet available in ekapkgs
    gpg
    pybluez
    qrcode
    requests
    twisted
  ]) ++ lib.optional (python3.pkgs ? magic-wormhole) python3.pkgs.magic-wormhole
    ++ lib.optional (python3.pkgs ? pygobject3) python3.pkgs.pygobject3;

  # bunch of linting
  doCheck = false;

  meta = {
    description = "GTK/GNOME application to use GnuPG for signing other peoples' keys";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-keysign";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
