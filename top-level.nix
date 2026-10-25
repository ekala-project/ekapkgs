# These will be added to the pkgs scope
final: prev: {
  # Work around corrupted nix store entry for JDK bootstrap tarball:
  # the fixed-output derivation's DB entry exists but the file is missing on disk.
  # Using builtins.fetchurl creates a different store path that bypasses the issue.
  java = prev.java.overrideAttrs (old: {
    src = builtins.fetchurl {
      url = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12%2B8/OpenJDK21U-jdk_x64_linux_hotspot_21.0.12_8.tar.gz";
      sha256 = "0w3k2xkybkhy4wslm5plhgq4y06s2ldhzk4pfmlmaq97dbq6yi74";
    };
  });

  # Update gpgme to 2.2.0 (corepkgs has 2.0.1, gpgmepp/kde needs >= 2.2.0)
  gpgme = prev.gpgme.overrideAttrs (old: rec {
    version = "2.2.0";
    src = final.fetchurl {
      url = "mirror://gnupg/gpgme/gpgme-${version}.tar.bz2";
      hash = "sha256-cWDoDoTa/QDZVshIkcUzu3qxampU++FXSy86zwSWl3s=";
    };
  });

  # Fix libfreehand build with newer GCC (disable -Werror)
  libfreehand = prev.libfreehand.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [ "--disable-werror" ];
  });

  jre = final.java;
  qt5Packages = final.qt5;
  libsForQt5 = final.qt5;

  # Extend qt5 scope with qscintilla
  qt5 = prev.qt5 // {
    qscintilla = prev.qt5.callPackage ./pkgs/qscintilla/default.nix { };
  };
  docbook_xsl = final.docbook-xsl;
  libxcb-renderutil = final.xcbutilrenderutil;
  libfm-extra = final.libfm.override { extraOnly = true; };
  # openal is an alias for openal-soft
  openal = final.openal-soft;

  # Rust infrastructure aliases
  rustPlatform = final.rust.packages.stable.rustPlatform;

  # dnsutils is just the utils output of bind
  dnsutils = final.bind.utils;

  # vte-gtk4 is the GTK4 variant of vte
  vte-gtk4 = final.vte.override {
    gtkVersion = "4";
    gtk4 = final.gtk4;
  };

  # colord-gtk4 is colord-gtk built with GTK4
  colord-gtk4 = final.colord-gtk.override { withGtk4 = true; };

  # nixos-icons is a simple data package
  nixos-icons = final.callPackage ./pkgs/nixos-icons { };

  # libcanberra-gtk3 alias for the gtk3 variant from pkgs-many
  libcanberra-gtk3 = final.libcanberra.gtk3;

  # libportal-gtk4 alias for the gtk4 variant from pkgs-many
  libportal-gtk4 = final.libportal.gtk4;

  # WebKit GTK: base variant is GTK4 (ABI 6.0)
  webkitgtk_6_0 = final.webkitgtk;

  # WebKit GTK: GTK3 variant (ABI 4.1) needed by vscode for libmsalruntime
  webkitgtk_4_1 = final.webkitgtk.gtk3;

  # libnma-gtk4 variant
  libnma-gtk4 = final.libnma.override {
    withGtk4 = true;
    gtk4 = final.gtk4;
  };

  # libsoup_2_4 has been removed upstream; stub it out
  libsoup_2_4 = null;

  # Backward-compatible aliases for packages moved to pkgs-many
  cgal_5 = final.cgal.v5;
  eigen_5 = final.eigen.v5;
  cairomm_1_16 = final.cairomm.v1_16;
  glibmm_2_68 = final.glibmm.v2_68;
  pangomm_2_48 = final.pangomm.v2_48;
  geocode-glib_2 = final.geocode-glib.v2;
  gssdp_1_6 = final.gssdp.v1_6;
  gupnp_1_6 = final.gupnp.v1_6;
  spidermonkey_140 = final.spidermonkey.v140;
  transmission_4 = final.transmission.v4;

  # Discord variant aliases
  discord-ptb = final.discord.ptb;
  discord-canary = final.discord.canary;
  discord-development = final.discord.development;

  # stub for packages that reference nixosTests
  nixosTests = { };

  # Expose mkKdeDerivation at top level for KDE packages in pkgs/
  inherit (final.kdePackages) mkKdeDerivation;

  # Python packaging helpers for ported Python packages
  inherit (final.python3Packages) buildPythonPackage buildPythonApplication;

  # Darwin stub (not applicable on Linux)
  desktopToDarwinBundle = null;

  # Qt6 module aliases (ported packages reference these as top-level args)
  inherit (final.qt6)
    qt5compat
    qtsvg
    qtdeclarative
    qtmultimedia
    qttools
    qtwebengine
    qtwebchannel
    qtlocation
    qtwayland
    qtspeech
    qtscxml
    qtpositioning
    qtnetworkauth
    qtwebsockets
    qtcharts
    qtbase
    ;

  # KDE misc aliases
  inherit (final.kdePackages)
    kirigami-addons
    kquickcharts
    kcontacts
    kholidays
    ;

  # Python package aliases for ported packages
  inherit (final.python3Packages)
    click
    configobj
    cloudpickle
    cython
    freezegun
    meson-python
    pyparsing
    pytestCheckHook
    python-dateutil
    flit-core
    binaryornot
    setuptools
    pybind11
    ;

  # Other commonly needed aliases
  gtk3-x11 = final.gtk3;
  gtk2-x11 = final.gtk2;
  emacs-nox = final.emacs;
  # fetchbzr not available in ekapkgs (Bazaar VCS deprecated)
  aspellDicts = final.aspell.dictionaries or { };
  ImageMagick = final.imagemagick;

  # Break qt6 <-> doxygen cycle: doxygen optionally depends on qt6,
  # but qt6.qtbase transitively depends on doxygen through libxml2.
  doxygen = prev.doxygen.override { qt6 = null; };

  # Qt convenience aliases
  qt6Packages = final.qt6;

  # libxcrypt-legacy (all hash algorithms enabled)
  libxcrypt-legacy = final.libxcrypt.legacy;

  # libjpeg8: libjpeg_turbo with JPEG 8 API/ABI compatibility
  libjpeg8 = final.libjpeg_turbo.jpeg8;

  # evolution-data-server GTK4 variant
  evolution-data-server-gtk4 = final.evolution-data-server.override {
    withGtk3 = false;
    withGtk4 = true;
  };
  # sdbus-cpp v2 variant
  sdbus-cpp_2 = final.sdbus-cpp.override { version = "2.2.1"; };

  # Fix opencascade-occt: add missing libX11 headers
  # The corepkgs build has Xlib detection (HAVE_XLIB) but cmake doesn't find X11
  # include directories. Add libx11 and pass 3RDPARTY_INCLUDE_DIRS so cmake can
  # locate X11/Xlib.h.
  opencascade-occt = prev.opencascade-occt.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libx11
      final.fontconfig
    ];
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_CXX_FLAGS=-isystem ${final.libx11.dev}/include -isystem ${final.xorgproto.include}/include -isystem ${final.fontconfig.dev}/include -isystem ${final.libGL.dev}/include"
      "-DCMAKE_C_FLAGS=-isystem ${final.libx11.dev}/include -isystem ${final.xorgproto.include}/include -isystem ${final.fontconfig.dev}/include -isystem ${final.libGL.dev}/include"
    ];
  });

  # opencascade-occt 7.6.2 (needed by ifcopenshell)
  opencascade-occt_7_6 = final.opencascade-occt.overrideAttrs rec {
    pname = "opencascade-occt";
    version = "7.6.2";
    src = final.fetchurl {
      name = "occt-V${builtins.replaceStrings [ "." ] [ "_" ] version}.tar.gz";
      url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=V${
        builtins.replaceStrings [ "." ] [ "_" ] version
      };sf=tgz";
      hash = "sha256-n3KFrN/mN1SVXfuhEUAQ1fJzrCvhiclxfEIouyj9Z18=";
    };
  };

  # pcre-cpp is pcre built with C++ support
  pcre-cpp = final.pcre.cpp;

  # jre_headless alias
  jre_headless = final.jre;

  # Full KDE Frameworks/Gear/Plasma scope
  kdePackages = final.callPackage ./kde { qt6Packages = final.qt6; };

  # Mozilla build infrastructure
  buildMozillaMach = opts: final.callPackage (import ./build-support/buildMozillaMach opts) { };
  wrapFirefox = final.callPackage ./build-support/buildMozillaMach/wrapFirefox.nix { };

  # speechd-minimal: alias to speechd (ekapkgs speechd lacks libsOnly option)
  speechd-minimal = final.speechd;

  # NSS variants for Mozilla products
  nss_esr = final.nss;
  nss_latest = final.callPackage ./pkgs/nss_latest { };

  # neovim alias (unwrapped for now)
  neovim = final.neovim-unwrapped;

  # comet-gog heroic variant
  comet-gog_heroic = final.comet-gog.override { comet-gog_kind = "heroic"; };

  # pnpm version alias - heroic wants pnpm_10 but pnpm 11 should work
  pnpm_10 = final.pnpm;

  # Electron binary packages
  inherit (final.callPackage ./build-support/electron-bin { })
    electron_43
    electron_44
    ;
  electron = final.electron_44;

  # Deluge variants
  deluged = final.deluge.override { withGUI = false; };

  # Compatibility aliases for ported packages
  audacious-bare = final.audacious;
  iperf = final.iperf3;
  hamlib_3 = final.hamlib.v3;
  hamlib_4 = final.hamlib.v4;
  babeltrace2 = final.babeltrace.v2;
  hdf5-cpp = final.hdf5; # corepkgs hdf5 already builds with C++ support
  docbook_xsl_ns = final.docbook-xsl-ns;
  xkeyboard_config = final.xkeyboard-config;
  libvlc = final.vlc;
  libportal-gtk3 = final.libportal.gtk3;

  # Common aliases for expected package names
  yq = final.yq-go;
  gnome-disks = final.gnome-disk-utility;
  swaync = final.swaynotificationcenter;

  # LibreOffice wrapped (libreoffice-unwrapped is auto-called from pkgs/)
  libreoffice = final.callPackage ./pkgs/libreoffice-unwrapped/wrapper.nix {
    unwrapped = final.libreoffice-unwrapped;
  };

  # Noto Fonts LGC+ variant (Latin, Greek, Cyrillic + extras)
  noto-fonts-lgc-plus = final.noto-fonts.overrideAttrs (old: {
    pname = "noto-fonts-lgc-plus";
    installPhase = ''
      local out_font=$out/share/fonts/noto

      install -m444 -Dt $megamerge/share/fonts/truetype/ megamerge/*.ttf

      for variant in NotoSans NotoSerif NotoSansMono NotoMusic NotoSansSymbols NotoSansSymbols2 NotoSansMath; do
        if [[ -d fonts/"$variant"/unhinted/variable-ttf ]]; then
          install -m444 -Dt $out_font fonts/"$variant"/unhinted/variable-ttf/*.ttf
        elif [[ -d fonts/"$variant"/unhinted/otf ]]; then
          install -m444 -Dt $out_font fonts/"$variant"/unhinted/otf/*.otf
        elif [[ -d fonts/"$variant"/unhinted/ttf ]]; then
          install -m444 -Dt $out_font fonts/"$variant"/unhinted/ttf/*.ttf
        fi
      done
    '';
  });

  # GNOME Shell extensions convenience set
  gnomeExtensions = {
    appindicator = final.gnome-shell-extension-appindicator;
    dash-to-panel = final.gnome-shell-extension-dash-to-panel;
    caffeine = final.gnome-shell-extension-caffeine;
    gsconnect = final.gnome-shell-extension-gsconnect;
    blur-my-shell = final.gnome-shell-extension-blur-my-shell;
    dash-to-dock = final.gnome-shell-extension-dash-to-dock;
    no-overview = final.gnome-shell-extension-no-overview;
    just-perfection = final.gnome-shell-extension-just-perfection;
    pop-shell = final.gnome-shell-extension-pop-shell;
    vertical-workspaces = final.gnome-shell-extension-vertical-workspaces;
    paperwm = final.gnome-shell-extension-paperwm;
    clipboard-indicator = final.gnome-shell-extension-clipboard-indicator;
    kimpanel = final.gnome-shell-extension-kimpanel;
    freon = final.gnome-shell-extension-freon;
  };
}
