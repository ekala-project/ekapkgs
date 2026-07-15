{
  lib,
  stdenv,
  fetchurl,
  libmnl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ethtool";
  version = "7.0";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/ethtool-${finalAttrs.version}.tar.xz";
    hash = "sha256-Zgv5clp4cTQ6DSMgaKdjT7z7abbC+O/0VYJ/rvsM0WI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libmnl
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Utility for controlling network drivers and hardware";
    homepage = "https://www.kernel.org/pub/software/network/ethtool/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ethtool";
    maintainers = [ ];
  };
})
