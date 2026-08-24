{
  stdenv,
  lib,
  fetchFromGitHub,
  makeFontsConf,
  autoreconfHook,
  docSupport ? true,
  doxygen,
  graphviz,
  libexsid ? null,
  libftdi1,
  libresidfp ? null,
  libusb1,
  perl,
  pkg-config,
  xa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsidplayfp";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-DCRzkMQ9QiGj6eDEqIzl5HeXaHwRxGISjVdqMiCdYXg=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals docSupport [ "doc" ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    xa
  ]
  ++ lib.optionals docSupport [
    doxygen
    graphviz
  ];

  buildInputs = [
    libftdi1
    libusb1
  ]
  ++ lib.optionals (libexsid != null) [ libexsid ]
  ++ lib.optionals (libresidfp != null) [ libresidfp ];

  configureFlags = [
    (lib.strings.withFeature true "exsid")
    (lib.strings.withFeature true "usbsid")
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests")
  ];

  enableParallelBuilding = true;

  preBuild = ''
    export XDG_CACHE_HOME=$TMPDIR
  '';

  buildFlags = [ "all" ] ++ lib.optionals docSupport [ "doc" ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

  env.FONTCONFIG_FILE = lib.optionalString docSupport (makeFontsConf {
    fontDirectories = [ ];
  });

  meta = {
    description = "Library to play Commodore 64 music derived from libsidplay2";
    longDescription = ''
      libsidplayfp is a C64 music player library which integrates
      the reSID SID chip emulation into a cycle-based emulator
      environment, constantly aiming to improve emulation of the
      C64 system and the SID chips.
    '';
    homepage = "https://github.com/libsidplayfp/libsidplayfp";
    changelog = "https://github.com/libsidplayfp/libsidplayfp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
