# These will be added to the pkgs scope
final: prev: {
  makeDesktopItem = final.lib.makeOverridable (
    import ./build-support/make-desktopitem.nix {
      inherit (final) lib writeTextFile buildPackages;
    }
  );
  jre = final.java;
  qt5Packages = final.qt5;
  libsForQt5 = final.qt5;
  libdbusmenu-gtk3 = final.libdbusmenu.gtk3;
  docbook_xsl = final.docbook-xsl;
  libxcb-renderutil = final.xcbutilrenderutil;
  libfm-extra = final.libfm.override { extraOnly = true; };
  # PulseAudio: libpulseaudio is library-only variant
  libpulseaudio = final.pulseaudio.override { libOnly = true; };
  # JACK2: libjack2 is library-only variant
  libjack2 = final.jack2.override { prefix = "lib"; };
  # openal is an alias for openal-soft
  openal = final.openal-soft;

  # Rust infrastructure aliases
  rustPlatform = final.rust.packages.stable.rustPlatform;
  cargo = final.rust.packages.stable.cargo;
  clippy = final.rust.packages.stable.clippy;
  rustfmt = final.rust.packages.stable.rustfmt;
  rustc = final.rust.packages.stable.rustc;
  # Fix zeromq: disable doc generation (asciidoc binary not available)
  # TODO: remove once corepkgs zeromq fix is upstream
  zeromq = prev.zeromq.overrideAttrs (old: {
    cmakeEntries = {
      WITH_DOC = false;
    };

    cmakeFlags = (old.cmakeFlags or [ ]);
    postBuild = "";
    postInstall = "";
  });

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

  # WebKit GTK: base variant is GTK4 (ABI 6.0)
  webkitgtk_6_0 = final.webkitgtk;

  # libnma-gtk4 variant
  libnma-gtk4 = final.libnma.override {
    withGtk4 = true;
    gtk4 = final.gtk4;
  };

  # libsoup_2_4 has been removed upstream; stub it out
  libsoup_2_4 = null;

  # Discord variant aliases
  discord-ptb = final.discord.ptb;
  discord-canary = final.discord.canary;
  discord-development = final.discord.development;

  # stub for packages that reference nixosTests
  nixosTests = { };

  # Fix duktape: ensure libm is linked into the shared library.
  # LDFLAGS=-lm is placed before the source file by Makefile.sharedlibrary,
  # so the linker drops it. Append -lm via NIX_LDFLAGS to fix IFUNC resolution
  # failures with glibc 2.42 (e.g. qmlcachegen crash during qtdeclarative build).
  duktape = prev.duktape.overrideAttrs (old: {
    NIX_LDFLAGS = (old.NIX_LDFLAGS or "") + " -lm";
  });

  # Break qt6 <-> doxygen cycle: doxygen optionally depends on qt6,
  # but qt6.qtbase transitively depends on doxygen through libxml2.
  doxygen = prev.doxygen.override { qt6 = null; };

  # Fix lttng-ust: GitHub changed archive hash for v2.15.1,
  # and disable man pages (requires asciidoc/xmlto not available)
  lttng-ust = prev.lttng-ust.overrideAttrs (old: {
    src = old.src.overrideAttrs {
      outputHash = "sha256-3hjg4zIIO20zS6ojDjZttPFeJmSDywI493ZCWqNcWcA=";
    };
    configureFlags = (old.configureFlags or [ ]) ++ [ "--disable-man-pages" ];
    outputs = final.lib.filter (o: o != "devdoc") (old.outputs or [ "out" ]);
  });

  # Qt convenience aliases
  qt6Packages = final.qt6;

  # libxcrypt-legacy (all hash algorithms enabled)
  libxcrypt-legacy = final.libxcrypt.override { enableHashes = "all"; };

  # evolution-data-server GTK4 variant
  evolution-data-server-gtk4 = final.evolution-data-server.override {
    withGtk3 = false;
    withGtk4 = true;
  };
  # Enable GObject introspection in gtk3 (needed by GIMP, etc.)
  gtk3 = prev.gtk3.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.gobject-introspection ];
    mesonEntries = {
      introspection = true;
    };

    mesonFlags = (old.mesonFlags or [ ]);
  });
  gtk4 =
    (prev.gtk4.override {
      trackerSupport = false;
      vulkanSupport = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
        meta = old.meta // {
          broken = false;
        };
      });
  # sdbus-cpp v2 variant
  sdbus-cpp_2 = final.sdbus-cpp.override { version = "2.2.1"; };
  # Fix stale fetchpatch hashes in corepkgs sane-backends;
  # patch 90815a9f is already in 1.4.0 source, only c9bf9574 (C2X fix) still needed
  sane-backends = prev.sane-backends.overrideAttrs (old: {
    patches = [
      (final.fetchpatch {
        url = "https://gitlab.com/sane-project/backends/-/commit/8acc267d5f4049d8438456821137ae56e91baea9.patch";
        hash = "sha256-IyupDeH1MPvEBnGaUzBbCu106Gp7zXxlPGFAaiiINQI=";
      })
      (final.fetchpatch {
        url = "https://gitlab.com/sane-project/backends/-/commit/fbf80b0fc1d262ed40d4b49dd53c14707083ef60.patch";
        hash = "sha256-9KKTr7p1vCgvGr6hFY83K5gbL7Ilm4Uzc86JIxv+ahI=";
        revert = true;
      })
      # C2X fix: GCC 14 with -std=gnu23 defines __STDC_VERSION__ < 202311L
      (final.fetchurl {
        url = "https://gitlab.com/sane-project/backends/-/commit/c9bf95744ae3c32c31202dea3327064c0d121444.patch";
        hash = "sha256-1Lvqdd8Y4VcPABJgR6UJu8W4RHCmr5VqL3wNtVBLrMk=";
      })
    ];
  });

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
