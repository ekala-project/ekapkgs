{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  gtk3,
  gspell,
  gmime3 ? gmime,
  gmime,
  gettext,
  intltool,
  itstool,
  libxml2,
  libnotify,
  gnutls,
  gnupg,
  spellChecking ? true,
  gnomeSupport ? true,
  libsecret,
  gcr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pan";
  version = "0.165";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "pan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y9ejT/XTMoWMLSIOePEtPCUy51JThJrBBOCdSUTk2yc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    gettext
    intltool
    itstool
    libxml2
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gmime3
    libnotify
    gnutls
  ]
  ++ lib.optionals spellChecking [ gspell ]
  ++ lib.optionals gnomeSupport [
    libsecret
    gcr
  ];

  cmakeEntries = {
    WANT_GSPELL = spellChecking;
    WANT_GKR = gnomeSupport;
    ENABLE_MANUAL = true;
    WANT_GMIME_CRYPTO = true;
    WANT_WEBKIT = false;
    WANT_NOTIFY = true;
  };

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnupg ]})
  '';

  meta = {
    description = "GTK-based Usenet newsreader good at both text and binaries";
    mainProgram = "pan";
    homepage = "http://pan.rebelbase.com";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl2Only
      fdl11Only
    ];
  };
})
