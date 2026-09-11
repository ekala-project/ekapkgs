{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
}:

stdenv.mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.21.0";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-wayland-protocols/plasma-wayland-protocols-${version}.tar.xz";
    hash = "sha256-aYp7KLcRJwMU45biSK6GCHz+rtATcgCQY5lb5uHchbo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    extra-cmake-modules
  ];

  meta = {
    description = "Plasma-specific Wayland protocols";
    homepage = "https://invent.kde.org/libraries/plasma-wayland-protocols";
    license = with lib.licenses; [
      bsd3
      cc0
      lgpl21Plus
      mit
    ];
    platforms = lib.platforms.linux;
  };
}
