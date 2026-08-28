{
  lib,
  stdenv,
  meson,
  ninja,
  fetchurl,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gettext,
  makeBinaryWrapper,
  libiconv,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-user-dirs";
  version = "0.20";

  src = fetchurl {
    url = "https://user-dirs.freedesktop.org/releases/xdg-user-dirs-${finalAttrs.version}.tar.xz";
    hash = "sha256-uONChiePT+8+G/6WhcOVzMDrUMFNOi+0lT3QD7/Trzk=";
  };

  outputs = [
    "out"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    makeBinaryWrapper
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    gettext
  ];

  buildInputs = [
    libiconv
    libintl
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  preFixup = ''
    # fallback values need to be last
    wrapProgram "$out/bin/xdg-user-dirs-update" \
      --suffix XDG_CONFIG_DIRS : "$out/etc/xdg"

    # Autostart, because the installed service is never explicitly enabled in NixOS
    substituteInPlace "$out/etc/xdg/autostart/xdg-user-dirs.desktop" \
      --replace-fail "X-systemd-skip=true" "X-systemd-skip=false"
  '';

  meta = {
    description = "Tool to help manage well known user directories like the desktop folder and the music folder";
    homepage = "http://freedesktop.org/wiki/Software/xdg-user-dirs";
    license = lib.licenses.gpl2;
    mainProgram = "xdg-user-dirs-update";
    platforms = lib.platforms.unix;
  };
})
