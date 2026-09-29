{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  pkg-config,
  help2man,
  adwaita-icon-theme,
  alsa-lib,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  gtksourceview4,
  librsvg,
  libsndfile,
  libxml2,
  libzip,
  poppler,
  portaudio,
  qpdf,
  zlib,
  withLua ? true,
  lua,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xournalpp";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CvuHgZ824jLF/L0/PAnbT4RXFLV+Uh2RJ30DA4PEEbE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
    pkg-config
    gtk3.wrapGAppsHook
    help2man
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    librsvg
    libsndfile
    libxml2
    libzip
    poppler
    portaudio
    qpdf
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional withLua lua.v5_3;

  buildFlags = [ "translations" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/share/thumbnailers/com.github.xournalpp.xournalpp.thumbnailer \
      --replace-fail "Exec=xournalpp-thumbnailer" "Exec=$out/bin/xournalpp-thumbnailer"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share"
    )
  '';

  meta = {
    description = "Xournal++ is a handwriting notetaking software with PDF annotation support";
    homepage = "https://xournalpp.github.io/";
    changelog = "https://github.com/xournalpp/xournalpp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "xournalpp";
  };
})
