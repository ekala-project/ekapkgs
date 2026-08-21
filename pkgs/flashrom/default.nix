{
  lib,
  stdenv,
  fetchurl,
  bash-completion,
  cmocka,
  libftdi1,
  libjaylink,
  libusb1,
  openssl,
  meson,
  ninja,
  pciutils,
  pkg-config,
  sphinx,
  jlinkSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashrom";
  version = "1.5.1";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${finalAttrs.version}.tar.xz";
    hash = "sha256-H5NLB27UnqziA2Vewkn8eGGmuOh/5K73MuR7bkhbYpM=";
  };

  patches = [
    ./0001-sb600spi.c-Drop-Promontory-support.patch
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    sphinx
    bash-completion
  ];

  buildInputs = [
    openssl
    cmocka
    libftdi1
    libusb1
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pciutils ]
  ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/flashrom_udev.rules \
      --replace 'GROUP="plugdev"' 'TAG+="uaccess", TAG+="udev-acl"'
  '';

  mesonFlags = [
    (lib.mesonOption "programmer" "auto")
    (lib.mesonEnable "man-pages" true)
    (lib.mesonEnable "tests" (!stdenv.buildPlatform.isDarwin))
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    install -Dm644 $NIX_BUILD_TOP/$sourceRoot/util/flashrom_udev.rules $out/lib/udev/rules.d/flashrom.rules
  '';

  NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && !stdenv.hostPlatform.isDarwin
  ) "-Wno-gnu-folding-constant";

  meta = {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = lib.licenses.gpl2Plus;
    mainProgram = "flashrom";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
