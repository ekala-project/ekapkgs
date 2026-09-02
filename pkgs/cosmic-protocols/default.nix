{
  lib,
  stdenv,
  fetchFromGitHub,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "a2da48188362c4ea05d33de2f6c67d8148deba88";
    hash = "sha256-hqsOzu0mlkE2jtgL5HvbT9vtOKiMSniNwV+xk4UzTkc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ wayland-scanner ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Additional wayland-protocols used by the COSMIC desktop environment";
    license = with lib.licenses; [
      mit
      gpl3Only
    ];
    platforms = lib.platforms.linux;
  };
}
