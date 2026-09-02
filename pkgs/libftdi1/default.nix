{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  cmake,
  pkg-config,
  libusb1,
  libconfuse,
  boost,
  python3,
  swig,
  doxygen,
  graphviz,
}:

stdenv.mkDerivation {
  pname = "libftdi";
  version = "1.5-unstable-2023-12-21";

  src = fetchgit {
    url = "git://developer.intra2net.com/libftdi";
    rev = "de9f01ece34d2fe6e842e0250a38f4b16eda2429";
    hash = "sha256-U37M5P7itTF1262oW+txbKxcw2lhYHAwy1ML51SDVMs=";
  };

  patches = [
    (fetchpatch {
      name = "swig-4.3.0-fix.patch";
      url = "https://src.fedoraproject.org/rpms/libftdi/raw/9051ea9ea767eced58b69d855a5d700a5d4602cc/f/libftdi-1.5-swig-4.3.patch";
      hash = "sha256-X5tqiPewnyAyvLzR6s0VbNpZKLd0idtPGU4ro36CZHI=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    doxygen
    graphviz
    swig
  ];

  buildInputs = [
    libconfuse
    boost
  ];

  propagatedBuildInputs = [ libusb1 ];

  cmakeFlags = [
    "-DFTDIPP=ON"
    "-DBUILD_TESTS=ON"
    "-DLINK_PYTHON_LIBRARY=ON"
    "-DPYTHON_BINDINGS=ON"
    "-DDOCUMENTATION=ON"
    "-DPYTHON_EXECUTABLE=${python3.pythonOnBuildForHost.interpreter}"
    "-DPYTHON_LIBRARY=${python3}/lib/libpython${python3.pythonVersion}${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  postPatch = ''
    substituteInPlace packages/99-libftdi.rules \
      --replace-fail 'GROUP="plugdev"' 'GROUP="ftdi"'

    substituteInPlace packages/99-libftdi.rules \
      --replace-fail 'GROUP="ftdi"' 'GROUP="ftdi", TAG+="uaccess"'
  '';

  postInstall = ''
    install -Dm644 ../packages/99-libftdi.rules "$out/etc/udev/rules.d/60-libftdi.rules"
    cp -r doc/man "$out/share/"
    cp -r doc/html "$out/share/doc/libftdi1/"
  '';

  preFixup = ''
    substituteInPlace $out/lib/pkgconfig/libftdi1.pc --replace-fail "libdir=$out/$out/lib" "libdir=$out/lib"
    substituteInPlace $out/lib/pkgconfig/libftdipp1.pc --replace-fail "libdir=$out/$out/lib" "libdir=$out/lib"
  '';

  meta = {
    description = "Library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = with lib.licenses; [
      lgpl2Only
      gpl2Only
    ];
    platforms = lib.platforms.all;
  };
}
