{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  gettext,
  fcitx5,
  libhangul,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-hangul";
  version = "5.1.11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-r1B4U51fYlHOgteDQyuYEUfZaEbRbENKmcYY5osj8UY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libhangul
  ];

  passthru.tests = {
    # inherit (nixosTests) fcitx5;
  };

  meta = {
    description = "Hangul wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-hangul";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
