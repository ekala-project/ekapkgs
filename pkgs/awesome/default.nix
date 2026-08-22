{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lua,
  cairo,
  librsvg,
  cmake,
  imagemagick,
  pkg-config,
  gdk-pixbuf,
  libxcb-util,
  libxcb-wm,
  libxcb-render-util,
  libxcb-keysyms,
  libxcb-image,
  libxdmcp,
  libxau,
  libxshmfence,
  libxcb,
  libstartup_notification,
  libxdg_basedir,
  libpthread-stubs,
  libxcb-cursor,
  makeWrapper,
  pango,
  gobject-introspection,
  which,
  dbus,
  net-tools,
  doxygen,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  findXMLCatalogs,
  libxkbcommon,
  xcbutilxrm,
  hicolor-icon-theme,
  asciidoctor,
  gtk3Support ? false,
  gtk3 ? null,
}:

assert gtk3Support -> gtk3 != null;

stdenv.mkDerivation rec {
  pname = "awesome";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = "v${version}";
    sha256 = "1i7ajmgbsax4lzpgnmkyv35x8vxqi0j84a14k6zys4blx94m9yjf";
  };

  patches = [
    (fetchpatch {
      name = "fno-common-prerequisite.patch";
      url = "https://github.com/awesomeWM/awesome/commit/c5202a48708585cc33528065af8d1b1d28b1a6e0.patch";
      sha256 = "0sv36xf0ibjcm63gn9k3bl039sqavb2b5i6d65il4bdclkc0n08b";
    })
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/awesomeWM/awesome/commit/d256d9055095f27a33696e0aeda4ee20ed4fb1a0.patch";
      sha256 = "1n3y4wnjra8blss7642jgpxnm9n92zhhjj541bb9i60m4b7bgfzz";
    })
    (fetchpatch {
      name = "glib-2.86.0.patch";
      url = "https://github.com/void-linux/void-packages/raw/933b305b313a2c7d971d746835deb9f49b652204/srcpkgs/awesome/patches/glib-2.86.0.patch";
      hash = "sha256-qVzD8O34sULcV6S4daDUBPnxVDd8T6ZyLOE+gYxCmf0=";
    })
  ];

  # Fix build with CMake 4 and missing check-examples target when docs are disabled
  postPatch = ''
    substituteInPlace {,tests/examples/}CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.0.0)' 'cmake_minimum_required(VERSION 3.10)' \
      --replace-warn 'cmake_policy(VERSION 2.6)' 'cmake_policy(VERSION 3.10)'
    sed -i 's/add_dependencies(check check-qa check-examples)/add_dependencies(check check-qa)/' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    imagemagick
    makeWrapper
    pkg-config
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    findXMLCatalogs
    asciidoctor
    gobject-introspection
  ];

  outputs = [
    "out"
  ];

  propagatedUserEnvPkgs = [ hicolor-icon-theme ];
  buildInputs = [
    (cairo.override { xcbSupport = true; })
    librsvg
    dbus
    gdk-pixbuf
    lua
    libpthread-stubs
    libstartup_notification
    libxdg_basedir
    net-tools
    pango
    libxcb-cursor
    libxau
    libxdmcp
    libxcb
    libxshmfence
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxkbcommon
    xcbutilxrm
  ]
  ++ lib.optional gtk3Support gtk3;

  cmakeFlags = [
    "-DOVERRIDE_VERSION=${version}"
    "-DGENERATE_DOC=OFF"
    "-DDO_COVERAGE=OFF"
  ]
  ++ lib.optional lua.pkgs.isLuaJIT "-DLUA_LIBRARY=${lua}/lib/libluajit-5.1.so";

  env = {
    GI_TYPELIB_PATH = "${pango.out}/lib/girepository-1.0";
    LUA_CPATH = "${lua}/lib/lua/${lua.luaversion}/?.so";
    LUA_PATH = "${lua}/share/lua/${lua.luaversion}/?.lua;;";
  };

  postInstall = ''
    mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
    makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --add-flags '--search ${lua}/lib/lua/${lua.luaversion}' \
      --add-flags '--search ${lua}/share/lua/${lua.luaversion}' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
  '';

  passthru = {
    inherit lua;
  };

  meta = {
    description = "Highly configurable, dynamic window manager for X";
    homepage = "https://awesomewm.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
