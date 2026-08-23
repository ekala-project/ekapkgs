{
  stdenv,
  lib,
  lightdm-gtk-greeter,
  fetchurl,
  lightdm ? null,
  pkg-config,
  intltool ? null,
  linkFarm,
  wrapGAppsHook3,
  gtk3,
  xfce4-dev-tools ? null,
  at-spi2-core,
  librsvg,
  hicolor-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lightdm-gtk-greeter";
  version = "2.0.9";

  src = fetchurl {
    url = "https://github.com/Xubuntu/lightdm-gtk-greeter/releases/download/lightdm-gtk-greeter-${finalAttrs.version}/lightdm-gtk-greeter-${finalAttrs.version}.tar.gz";
    hash = "sha256-yP3xmKqaP50NrQtI3+I8Ine3kQfo/PxillKQ8QgfZF0=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    lightdm
    librsvg
    hicolor-icon-theme
    gtk3
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-indicator-services-command"
    "--sbindir=${placeholder "out"}/bin"
  ];

  postPatch = ''
    cp data/badges/xfce{,-wayland}_badge-symbolic.svg
  '';

  preConfigure = ''
    configureFlagsArray+=( --enable-at-spi-command="${at-spi2-core}/libexec/at-spi-bus-launcher --launch-immediately" )
  '';

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
      --replace-fail "Exec=lightdm-gtk-greeter" "Exec=$out/bin/lightdm-gtk-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-gtk-greeter-xgreeters" [
    {
      path = "${lightdm-gtk-greeter}/share/xgreeters/lightdm-gtk-greeter.desktop";
      name = "lightdm-gtk-greeter.desktop";
    }
  ];

  meta = {
    homepage = "https://github.com/Xubuntu/lightdm-gtk-greeter";
    description = "GTK greeter for LightDM";
    mainProgram = "lightdm-gtk-greeter";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
