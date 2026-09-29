{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  gdk-pixbuf,
  glycin-loaders,
  gtk4,
  gtksourceview5,
  gstreamer,
  libadwaita,
  libglycin,
  libxml2,
  openssl,
  sqlite,
  webkitgtk_6_0,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsflash";
  version = "5.2.5";

  src = fetchFromGitLab {
    owner = "news-flash";
    repo = "news_flash_gtk";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-oii3/VIV0zivHz/ZscVtJVvPm4SSlzpR+o6t0cS8JO8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hR0rfOOLTVt8FuTG0RT80iO8Tt4UwMZwk/VYsBAoLBw=";
  };

  postPatch = ''
    patchShebangs --build build-aux/cargo.sh
    meson rewrite kwargs set project / version '${finalAttrs.version}'
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / 'news_flash_gtk'" \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / 'news_flash_gtk'"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    libglycin.patchVendorHook
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    gtk4.wrapGAppsHook

    # Provides setup hook to fix "Unrecognized image file format"
    gdk-pixbuf
  ];

  buildInputs = [
    glycin-loaders
    gtk4
    gtksourceview5
    libadwaita
    libglycin
    libxml2
    openssl
    sqlite
    webkitgtk_6_0

    # TLS support for loading external content in webkitgtk WebView
    glib-networking
  ]
  ++ (with gstreamer; [
    # Audio & video support for webkitgtk WebView
    gstreamer
    plugins-base
    plugins-good
    plugins-bad
  ]);

  # For https://gitlab.com/news-flash/news_flash_gtk/-/blob/v.4.2.1/src/meson.build#L48
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "Modern feed reader designed for the GNOME desktop";
    homepage = "https://gitlab.com/news-flash/news_flash_gtk";
    changelog = "https://gitlab.com/news-flash/news_flash_gtk/-/raw/${finalAttrs.src.tag}/data/io.gitlab.news_flash.NewsFlash.appdata.xml.in.in#:~:text=%3Crelease%20version=%22${finalAttrs.version}%22,%3C/release%3E";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "io.gitlab.news_flash.NewsFlash";
  };
})
