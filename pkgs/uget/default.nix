{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  openssl,
  curl,
  libnotify,
  libappindicator-gtk3 ? null,
  gst_all_1,
  gtk3,
  dconf,
  wrapGAppsHook3,
  aria2,
  aria2Support ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uget";
  version = "2.2.3-1";

  src = fetchurl {
    url = "mirror://sourceforge/urlget/uget-${finalAttrs.version}.tar.gz";
    sha256 = "0jchvgkkphhwp2z7vd4axxr9ns8b6vqc22b2z8a906qm8916wd8i";
  };

  patches = [
    ./fix-match-ugtk_setting_dialog_new-declaration-with-d.patch
  ];

  postPatch = ''
    substituteInPlace ui-gtk/UgtkBanner.h --replace "} banner;" "};"
  '';

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    curl
    libnotify
    gtk3
    (lib.getLib dconf)
  ]
  ++ lib.optionals (libappindicator-gtk3 != null) [
    libappindicator-gtk3
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ])
  ++ (lib.optional aria2Support aria2);

  enableParallelBuilding = true;

  preFixup = lib.optionalString aria2Support ''gappsWrapperArgs+=(--suffix PATH : "${aria2}/bin")'';

  meta = {
    description = "Download manager using GTK and libcurl";
    homepage = "http://www.ugetdm.com";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "uget-gtk";
  };
})
