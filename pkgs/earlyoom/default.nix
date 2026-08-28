{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "earlyoom";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eNWg96+uQn/s+iBCm8TH26pXVVzBdqbeQxVP2t4W7YA=";
  };

  patches = [ ./0000-fix-dbus-path.patch ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
    "SYSTEMDUNITDIR=${placeholder "out"}/etc/systemd/system"
  ];

  meta = {
    homepage = "https://github.com/rfjakob/earlyoom";
    description = "Early OOM Daemon for Linux";
    license = lib.licenses.mit;
    mainProgram = "earlyoom";
    platforms = lib.platforms.linux;
  };
})
