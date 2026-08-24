{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  which,
  perl,
  jq,
  libxrandr,
  coreutils,
  cairo,
  dbus,
  systemd,
  gdk-pixbuf,
  glib,
  libx11,
  libxscrnsaver,
  wayland,
  wayland-protocols,
  libxinerama,
  libnotify,
  pango,
  xorgproto,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dunst";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Idh/moq+OjD3VpZKJ3blO1JAK7PPX42z15rQz/JZb84=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    which
    systemd
    makeWrapper
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    libnotify
    pango
    librsvg
    libx11
    libxscrnsaver
    libxinerama
    xorgproto
    libxrandr
    wayland
    wayland-protocols
  ];

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
    "SYSCONFDIR=$(out)/etc"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
  ];

  postInstall = ''
    wrapProgram $out/bin/dunst \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"

    wrapProgram $out/bin/dunstctl \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          dbus
        ]
      }"

    substituteInPlace \
      $out/share/zsh/site-functions/_dunstctl \
      $out/share/bash-completion/completions/dunstctl \
      $out/share/fish/vendor_completions.d/{dunstctl,dunstify}.fish \
      --replace-fail "jq" "${lib.getExe jq}"
  '';

  meta = {
    description = "Lightweight and customizable notification daemon";
    homepage = "https://dunst-project.org/";
    license = lib.licenses.bsd3;
    mainProgram = "dunst";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
