{
  lib,
  stdenv,
  fetchFromGitLab,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "wlr-protocols";
  version = "0-unstable-2022-09-05";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlr-protocols";
    rev = "4264185db3b7e961e7f157e1cc4fd0ab75137568";
    sha256 = "Ztc07RLg+BZPondP/r6Jo3Fw1QY/z1QsFvdEuOqQshA=";
  };

  strictDeps = true;
  nativeBuildInputs = [ wayland-scanner ];

  patchPhase = ''
    substituteInPlace wlr-protocols.pc.in \
      --replace-fail '=''${pc_sysrootdir}' "=" \
      --replace-fail '=@prefix@' "=$out"
  '';

  doCheck = true;
  checkTarget = "check";

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    description = "Wayland roots protocol extensions";
    homepage = "https://gitlab.freedesktop.org/wlroots/wlr-protocols";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
