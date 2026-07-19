{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  help2man,
  glib,
  python3,
  bash-completion,
  libmbim,
}:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.36.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libqmi";
    rev = version;
    hash = "sha256-cGNnw0vO/Hr9o/eIf6lLTsoGiEkTvZiArgO7tAc208U=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    help2man
  ];

  buildInputs = [
    bash-completion
    libmbim
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    "-Dgtk_doc=false"
    "-Dintrospection=false"
    "-Dman=true"
    "-Dqrtr=false"
    "-Dudev=false"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      build-aux/qmi-codegen/qmi-codegen
  '';

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
    ];
    changelog = "https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/blob/${version}/NEWS";
    maintainers = [ ];
  };
}
