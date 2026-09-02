{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  python3,
  libxml2,
  libxinerama,
  libxcursor,
  libxau,
  libxrandr,
  libice,
  libsm,
  pango,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openbox";
  version = "3.6.1";

  src = fetchurl {
    url = "https://openbox.org/dist/openbox/openbox-${finalAttrs.version}.tar.gz";
    sha256 = "1xvyvqxlhy08n61rjkckmrzah2si1i7nmc7s8h07riqq01vc0jlb";
  };

  setlayoutSrc = fetchurl {
    url = "https://openbox.org/dist/tools/setlayout.c";
    sha256 = "1ci9lq4qqhl31yz1jwwjiawah0f7x0vx44ap8baw7r6rdi00pyiv";
  };

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/90cb57ef53d952bb6ab4c33a184f815bbe1791c0/openbox/trunk/py3.patch";
      sha256 = "1ks99awlkhd5ph9kz94s1r6m1bfvh42g4rmxd14dyg5b421p1ljc";
    })
    (fetchpatch {
      url = "https://github.com/Mikachu/openbox/commit/d41128e5a1002af41c976c8860f8299cfcd3cd72.patch";
      sha256 = "sha256-4/aoI4y98JPybZ1MNI7egOhkroQgh/oeGnYrhNGX4t4=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
    python3
  ];

  buildInputs = [
    libxml2
    libxinerama
    libxcursor
    libxau
    libxrandr
    libice
    libsm
    python3
  ];

  propagatedBuildInputs = [
    pango
  ];

  strictDeps = true;

  configureFlags = [
    "--disable-imlib2"
    "--disable-startup-notification"
  ];

  postBuild = "gcc -O2 -o setlayout $(pkg-config --cflags --libs x11) $setlayoutSrc";

  postInstall = ''
    cp -a setlayout "$out"/bin
    wrapProgram "$out/bin/openbox" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-gnome-session" --prefix XDG_DATA_DIRS : "$out/share"
    wrapProgram "$out/bin/openbox-kde-session" --prefix XDG_DATA_DIRS : "$out/share"
    substituteInPlace "$out/libexec/openbox-autostart" \
      --replace-fail "$out/etc/xdg/openbox/autostart" "/etc/xdg/openbox/autostart"
  '';

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = "http://openbox.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
