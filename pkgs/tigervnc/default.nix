{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
  util-macros,
  tab-window-manager ? null,
  libxtst,
  libxrandr,
  libxi,
  libxft,
  libxext,
  libxdamage,
  libx11,
  libsm,
  libice,
  font-util,
  xsetroot ? null,
  xorgproto,
  xkbcomp,
  xauth,
  libxkbfile,
  libpciaccess,
  zlib,
  libjpeg_turbo,
  pixman,
  fltk,
  cmake,
  gettext,
  libtool,
  libGLU,
  gnutls,
  gawk,
  pam,
  nettle,
  xterm ? null,
  openssh,
  perl,
  makeWrapper,
  ffmpeg,
  autoconf,
  automake,
  libuuid,
  libxkbcommon,
  pipewire,
  wayland,
  wayland-scanner,
  xkeyboard-config,
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

let
  xorg-server = xorg.xorgserver;
  xkeyboard_config = xkeyboard-config;
  libxfont_2 = xorg.libXfont2 or null;
in

stdenv.mkDerivation (finalAttrs: {
  version = "1.16.2";
  pname = "tigervnc";

  src = fetchFromGitHub {
    owner = "TigerVNC";
    repo = "tigervnc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yyJCtv48gKftyYND0v18qvh4gimxJt22vxiZBSNZ07U=";
  };

  postPatch = ''
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${xkeyboard_config}/etc/X11/xkb";' unix/vncserver/vncserver.in
    fontPath=
    substituteInPlace vncviewer/vncviewer.cxx \
       --replace-fail '"/usr/bin/ssh' '"${openssh}/bin/ssh'
    source_top="$(pwd)"

    # On Mac, do not build a .dmg, instead copy the .app to the source dir
    gawk -i inplace 'BEGIN { del=0 } /hdiutil/ { del=2 } del<=0 { print } /$VERSION.dmg/ { del -= 1 }' release/makemacapp.in
    echo "mv \"\$APPROOT\" \"\$SRCDIR/\"" >> release/makemacapp.in
  '';

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "out"))
    (lib.cmakeFeature "CMAKE_INSTALL_SBINDIR" "${placeholder "out"}/bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "${placeholder "out"}/bin")
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=array-bounds"
  ];

  postBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=int-to-pointer-cast -Wno-error=pointer-to-int-cast"
    export CXXFLAGS="$CXXFLAGS -fpermissive"
    # Build Xvnc
    tar xf ${xorg-server.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    version=$(echo ${xorg-server.name} | sed 's/.*-\([0-9]\+\).[0-9]\+.*/\1/g')
    patch -p1 < "$source_top/unix/xserver$version.patch"
    autoreconf -vfi
    ./configure $configureFlags  --disable-devel-docs --disable-docs \
        --disable-xorg --disable-xnest --disable-xvfb --disable-dmx \
        --disable-xwin --disable-xephyr --disable-kdrive --with-pic \
        --disable-xorgcfg --disable-xprint --disable-static \
        --enable-composite --disable-xtrap --enable-xcsecurity \
        --disable-{a,c,m}fb \
        --disable-xwayland \
        --disable-config-dbus --disable-config-udev --disable-config-hal \
        --disable-xevie \
        --disable-dri --disable-dri2 --disable-dri3 --enable-glx \
        --enable-install-libxf86config \
        --prefix="$out" --disable-unit-tests \
        --with-xkb-path=${xkeyboard_config}/share/X11/xkb \
        --with-xkb-bin-directory=${xkbcomp}/bin \
        --with-xkb-output=$out/share/X11/xkb/compiled
    make TIGERVNC_SRC=$src TIGERVNC_BUILDDIR=`pwd`/../.. -j$NIX_BUILD_CORES
    popd
  '';

  postInstall = ''
    pushd unix/xserver/hw/vnc
    make TIGERVNC_SRC=$src TIGERVNC_BUILDDIR=`pwd`/../../../.. install
    popd
    rm -f $out/lib/xorg/protocol.txt

    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${
        lib.makeBinPath (
          lib.filter (x: x != null) [
            xterm
            tab-window-manager
            xsetroot
            xauth
          ]
        )
      }
  '';

  buildInputs = [
    fltk
    gnutls
    libjpeg_turbo
    pixman
    gawk
    ffmpeg
    nettle
    pam
    perl
    xorgproto
    util-macros
    libxtst
    libxext
    libx11
    libxext
    libice
    libxi
    libsm
    libxft
    libxkbfile
    libpciaccess
    libGLU
    libxrandr
    libxdamage
  ]
  ++ lib.optionals (libxfont_2 != null) [ libxfont_2 ]
  ++ xorg-server.buildInputs
  ++ lib.optionals waylandSupport [
    libuuid
    libxkbcommon
    pipewire
    wayland
  ];

  nativeBuildInputs = [
    cmake
    gettext
    autoconf
    automake
    font-util
    libtool
    makeWrapper
    util-macros
    zlib
  ]
  ++ xorg-server.nativeBuildInputs
  ++ lib.optionals waylandSupport [
    wayland-scanner
  ];

  propagatedBuildInputs = xorg-server.propagatedBuildInputs;

  meta = {
    homepage = "https://tigervnc.org/";
    license = lib.licenses.gpl2Plus;
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    platforms = lib.platforms.unix;
    # Prevent a store collision.
    priority = 4;
    mainProgram = "vncviewer";
  };
})
