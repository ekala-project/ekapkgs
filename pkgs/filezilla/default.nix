{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  dbus,
  fzssh,
  gettext,
  gnutls,
  libfilezilla,
  libidn,
  nettle,
  pkg-config,
  pugixml,
  sqlite,
  tinyxml,
  boost,
  gtk3,
  xdg-utils,
  wxwidgets,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filezilla";
  version = "3.70.6";

  src = fetchurl {
    # Upstream download link was made unstable on purpose
    # See https://trac.filezilla-project.org/ticket/13186
    url = "https://sources.archlinux.org/other/filezilla/filezilla-${finalAttrs.version}.tar.xz";
    hash = "sha256-PdJCWpf5bbjMiyEuG2BdeVEljj2jJ5yQEHq/SmqJyD8=";
  };

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
    "--with-wx-prefix=${wxwidgets}"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk3.wrapGAppsHook
    xdg-utils
  ];

  buildInputs = [
    boost
    dbus
    fzssh
    gettext
    gnutls
    libfilezilla
    libidn
    nettle
    pugixml
    sqlite
    tinyxml
    gtk3
  ];

  strictDeps = true;


  preFixup = ''
    gappsWrapperArgs+=(
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"
    )
  '';

  meta = {
    homepage = "https://filezilla-project.org/";
    description = "Graphical FTP, FTPS and SFTP client";
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and macOS are
      provided.
    '';
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
