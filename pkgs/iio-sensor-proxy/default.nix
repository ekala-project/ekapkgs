{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  libxml2,
  meson,
  ninja,
  pkg-config,
  libgudev,
  systemd,
  polkit,
}:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "3.7";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "iio-sensor-proxy";
    rev = version;
    hash = "sha256-MAfh6bgh39J5J3rlyPjyCkk5KcfWHMZLytZcBRPHaJE=";
  };

  postPatch = ''
    # upstream meson.build currently doesn't have an option to change the default polkit dir
    substituteInPlace data/meson.build \
      --replace 'polkit_policy_directory' "'$out/share/polkit-1/actions'"
  '';

  buildInputs = [
    libgudev
    systemd
    polkit
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    glib
    libxml2
    pkg-config
  ];

  mesonFlags = [
    (lib.mesonOption "udevrulesdir" "${placeholder "out"}/lib/udev/rules.d")
    (lib.mesonOption "systemdsystemunitdir" "${placeholder "out"}/lib/systemd/system")
  ];

  meta = {
    description = "Proxy for sending IIO sensor data to D-Bus";
    mainProgram = "monitor-sensor";
    homepage = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
