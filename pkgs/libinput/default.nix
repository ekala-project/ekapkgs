{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  libevdev,
  mtdev,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "libinput";
  version = "1.28.1";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libinput";
    repo = "libinput";
    rev = version;
    hash = "sha256-kte5BzGEz7taW/ccnxmkJjXn3FeikzuD6Hm10l+X7c0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    libevdev
    mtdev
  ];

  propagatedBuildInputs = [
    udev
  ];

  mesonFlags = [
    "-Ddocumentation=false"
    "-Ddebug-gui=false"
    "-Dtests=false"
    "-Dlibwacom=false"
    "--sysconfdir=/etc"
    "--libexecdir=${placeholder "bin"}/libexec"
  ];

  postPatch = ''
    # Don't create an empty directory under /etc.
    sed -i "/install_emptydir(dir_etc \/ 'libinput')/d" meson.build
  '';

  meta = {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    mainProgram = "libinput";
    homepage = "https://www.freedesktop.org/wiki/Software/libinput/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
