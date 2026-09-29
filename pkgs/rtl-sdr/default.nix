{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "rtl-sdr";
  version = "2.0.1";

  src = fetchFromGitea {
    domain = "gitea.osmocom.org";
    owner = "sdr";
    repo = "rtl-sdr";
    rev = "v${version}";
    hash = "sha256-+RYSCn+wAkb9e7NRI5kLY8a6OXtJu7QcSUht1R6wDX0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [ libusb1 ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DWITH_RPC=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d" \
      --replace "VERSION_INFO_PATCH_VERSION git" "VERSION_INFO_PATCH_VERSION ${lib.versions.patch version}"

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
  '';

  meta = {
    description = "Software to turn the RTL2832U into a SDR receiver";
    longDescription = "Rtl-sdr library by the Osmocom project";
    homepage = "https://gitea.osmocom.org/sdr/rtl-sdr";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "rtl_sdr";
  };
}
