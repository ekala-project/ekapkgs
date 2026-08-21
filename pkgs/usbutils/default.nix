{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  libusb1,
  hwdata,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usbutils";
  version = "019";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/usbutils-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZZ9AxEDjG6hlxSyBijPTumqXNJ4zU/ixmFF5yyqnHsU=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit hwdata;
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libusb1
    python3
  ];

  outputs = [
    "out"
    "man"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "python"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    moveToOutput "bin/lsusb.py" "$python"
    install -Dm555 usbreset -t $out/bin
  '';

  meta = {
    homepage = "http://www.linux-usb.org/";
    description = "Tools for working with USB devices, such as lsusb";
    license = with lib.licenses; [
      gpl2Only
      gpl2Plus
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "lsusb";
    maintainers = [ ];
  };
})
