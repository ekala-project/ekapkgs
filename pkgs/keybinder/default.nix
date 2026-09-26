{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  gnome-common,
  gtk-doc,
  gtk2,
  lua,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keybinder";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "engla";
    repo = "keybinder";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-elL6DZtzCwAtoyGZYP0jAma6tHPks2KAtrziWtBENGU=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    gobject-introspection
  ];

  buildInputs = [
    libtool
    gnome-common
    gtk-doc
    gtk2
    lua.v5_1
  ];

  configureFlags = [ "--disable-python" ];

  preConfigure = ''
    ./autogen.sh --prefix="$out" $configureFlags
  '';

  meta = {
    description = "Library for registering global key bindings";
    homepage = "https://github.com/engla/keybinder/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
