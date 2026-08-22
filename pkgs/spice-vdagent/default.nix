{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  alsa-lib,
  spice-protocol,
  glib,
  libpciaccess ? null,
  libxcb,
  libxrandr,
  libxinerama,
  libxfixes,
  dbus,
  libdrm,
  systemd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spice-vdagent";
  version = "0.23.0";
  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/spice-vdagent-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Y+D5vVWXxGOKz9bxDXojVPWZvZ31sx5EMnDKzwfhakA=";
  };

  patches = [
    (fetchpatch {
      name = "gcc16-unused-variable-device-info.patch";
      url = "https://gitlab.freedesktop.org/spice/linux/vd_agent/-/commit/e3c74bd3e75a3804692da7d526016a823f6273e0.patch";
      hash = "sha256-Bf1fwvsQuAVzkN6SNXk7YZxRuhhVInAFxnlrRlavgy0=";
    })
  ];

  postPatch = ''
    substituteInPlace data/spice-vdagent.desktop --replace /usr $out
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    spice-protocol
    glib
    libdrm
    libpciaccess
    libxcb
    libxrandr
    libxinerama
    libxfixes
    dbus
    systemd
  ];

  meta = {
    description = "Enhanced SPICE integration for linux QEMU guest";
    longDescription = ''
      Spice agent for linux guests offering
      * Client mouse mode
      * Copy and paste
      * Automatic adjustment of the X-session resolution
        to the client resolution
      * Multiple displays
    '';
    homepage = "https://www.spice-space.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
