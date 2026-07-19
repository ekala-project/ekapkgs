{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libva,
  libx11,
  libxext,
  libxfixes,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libva-utils";
    rev = version;
    sha256 = "sha256-CmhdhNNRO2j8lH7awp9YiKWMvV17GTBsXdrNY06jT2w=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libdrm
    libva
    libx11
    libxext
    libxfixes
    wayland
  ];

  meta = with lib; {
    description = "Collection of utilities and examples for VA-API";
    longDescription = ''
      libva-utils is a collection of utilities and examples to exercise VA-API
      in accordance with the libva project.
    '';
    homepage = "https://github.com/intel/libva-utils";
    changelog = "https://raw.githubusercontent.com/intel/libva-utils/${version}/NEWS";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
