{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  cups,
  zlib,
  libjpeg,
  libusb1,
  python3Packages,
  sane-backends,
  withSane ? false, # disabled by default; sane-backends has broken patch hashes upstream
  dbus,
  file,
  ghostscript,
  net-snmp,
  openssl,
  perl,
  net-tools,
  bash,
  util-linux,
  removeReferencesTo,
}:

let
  pname = "hplip";
  version = "3.26.4";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/hplip-${version}.tar.gz";
    hash = "sha256-ucYSUnVPNbSiNzlsqJYeez4MVtt21mpnEre/PjDmlGM=";
  };
in

python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = false;

  inherit src;

  buildInputs = [
    libjpeg
    cups
    libusb1
    dbus
    file
    ghostscript
    net-snmp
    openssl
    perl
    zlib
  ]
  ++ lib.optionals withSane [
    sane-backends
  ];

  nativeBuildInputs = [
    pkg-config
    removeReferencesTo
    autoreconfHook
  ];

  pythonPath = with python3Packages; [
    dbus-python
    pillow
    pygobject3
    reportlab
    distro
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${net-tools}/bin"
  ];

  patches = [
    # Add NixOS CUPS PPD search path
    ./hplip-3.20.11-nixos-cups-ppd-search-path.patch
    # https://bugs.launchpad.net/hplip/+bug/2096650
    ./gcc-compatability.patch

    # Remove all ImageProcessor functionality since that is closed source
    (fetchurl {
      url = "https://web.archive.org/web/20230226174550/https://sources.debian.org/data/main/h/hplip/3.22.10+dfsg0-1/debian/patches/0028-Remove-ImageProcessor-binary-installs.patch";
      hash = "sha256-tNYccuwrcx5WCe7ULk8r8J6MVcUytGspiW64zAvO0qI=";
    })
  ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/44230
    substituteInPlace createPPD.sh \
      --replace-fail ppdc "${cups}/bin/ppdc" \
      --replace-fail "gzip -c" "gzip -cn"

    # HPLIP hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/etc/hp,$out/etc/hp,g \
      -e s,/etc/sane.d,$out/etc/sane.d,g \
      -e s,/usr/include/libusb-1.0,${libusb1.dev}/include/libusb-1.0,g \
      -e s,/usr/share/hal/fdi/preprobe/10osvendor,$out/share/hal/fdi/preprobe/10osvendor,g \
      -e s,/usr/lib/systemd/system,$out/lib/systemd/system,g \
      -e s,/var/lib/hp,$out/var/lib/hp,g \
      -e s,/usr/bin/perl,${perl}/bin/perl,g \
      -e s,/usr/bin/file,${file}/bin/file,g \
      -e s,/usr/bin/gs,${ghostscript}/bin/gs,g \
      -e s,/usr/share/cups/fonts,${ghostscript.fonts}/share/fonts,g \
      -e "s,ExecStart=/usr/bin/python /usr/bin/hp-config_usb_printer,ExecStart=$out/bin/hp-config_usb_printer,g" \
      -e s,Exec=/usr/bin/hp-uiscan,Exec=hp-uiscan,g \
      -e s,Icon=/usr/share/icons/Humanity/devices/48/printer.svg,Icon=printer,g \
      -e s,Icon=@abs_datadir@/hplip/data/images/128x128/hp_logo.png,Icon=hp_logo,g \
      {} +

    echo 'AUTOMAKE_OPTIONS = foreign' >> Makefile.am
  '';

  configureFlags =
    let
      out = placeholder "out";
    in
    [
      "--with-hpppddir=${out}/share/cups/model/HP"
      "--with-cupsfilterdir=${out}/lib/cups/filter"
      "--with-cupsbackenddir=${out}/lib/cups/backend"
      "--with-icondir=${out}/share/applications"
      "--with-systraydir=${out}/xdg/autostart"
      "--with-mimedir=${out}/etc/cups"
      "--enable-policykit"
      "--disable-network-build"
      "--disable-gui-build"
      "--disable-qt4"
      "--disable-qt5"

      # remove ImageProcessor usage
      "--disable-imageProcessor-build"
    ]
    ++ lib.optional (!withSane) "--disable-scan-build";

  makeFlags =
    let
      out = placeholder "out";
    in
    [
      "halpredir=${out}/share/hal/fdi/preprobe/10osvendor"
      "rulesdir=${out}/etc/udev/rules.d"
      "policykit_dir=${out}/share/polkit-1/actions"
      "policykit_dbus_etcdir=${out}/etc/dbus-1/system.d"
      "policykit_dbus_sharedir=${out}/share/dbus-1/system-services"
      "PYTHONEXECDIR=${out}/lib/python${lib.versions.majorMinor python3Packages.python.version}/site-packages"
      "hplip_confdir=${out}/etc/hp"
      "hplip_statedir=${out}/var/lib/hp"
    ];

  postConfigure = ''
    # don't save timestamp, in order to improve reproducibility
    substituteInPlace Makefile \
      --replace "GZIP_ENV = --best" "GZIP_ENV = --best -n"
  '';

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  env = {
    # Prevent 'ppdc: Unable to find include file "<font.defs>"'
    CUPS_DATADIR = "${cups}/share/cups";

    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-int"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=return-mismatch"
      "-Wno-error=int-conversion"
      "-Wno-error=incompatible-pointer-types"
    ];
  };

  postInstall = ''
    # Only create icon symlinks if the image data was installed (requires GUI)
    for resolution in 16x16 32x32 64x64 128x128 256x256; do
      if [ -f "$out/share/hplip/data/images/$resolution/hp_logo.png" ]; then
        mkdir -p $out/share/icons/hicolor/$resolution/apps
        ln -s $out/share/hplip/data/images/$resolution/hp_logo.png \
          $out/share/icons/hicolor/$resolution/apps/hp_logo.png
      fi
    done
  '';

  # The installed executables are just symlinks into $out/share/hplip,
  # but wrapPythonPrograms ignores symlinks. We cannot replace the Python
  # modules in $out/share/hplip with wrapper scripts because they import
  # each other as libraries. Instead, we emulate wrapPythonPrograms by
  # 1. Calling patchPythonProgram on the original script in $out/share/hplip
  # 2. Making our own wrapper pointing directly to the original script.
  dontWrapPythonPrograms = true;
  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"

    for bin in $out/bin/*; do
      py=$(readlink -m $bin)
      rm $bin
      echo "patching \`$py'..."
      patchPythonScript "$py"
      echo "wrapping \`$bin'..."
      makeWrapper "$py" "$bin" \
          --prefix PATH ':' "$program_PATH" \
          --set PYTHONNOUSERSITE "true" \
          $makeWrapperArgs
    done
  '';

  postFixup = ''
    substituteInPlace $out/etc/hp/hplip.conf --replace /usr $out
    # Patch udev rules:
    substituteInPlace $out/etc/udev/rules.d/56-hpmud.rules \
      --replace {,${bash}}/bin/sh \
      --replace /usr/bin/nohup "" \
      --replace {,${util-linux}/bin/}logger \
      --replace {/usr,$out}/bin
    remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/lib/*.so)
  '';

  # There are some binaries there, which reference gcc-unwrapped otherwise.
  stripDebugList = [
    "share/hplip"
    "lib/cups/backend"
    "lib/cups/filter"
    python3Packages.python.sitePackages
  ]
  ++ lib.optional withSane "lib/sane";

  meta = {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = "https://developers.hp.com/hp-linux-imaging-and-printing";
    downloadPage = "https://sourceforge.net/projects/hplip/files/hplip/";
    license = with lib.licenses; [
      mit
      bsd2
      gpl2Plus
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "armv6l-linux"
      "armv7l-linux"
      "aarch64-linux"
    ];
  };
}
