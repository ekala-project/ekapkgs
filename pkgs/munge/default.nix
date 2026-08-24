{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libgcrypt,
  zlib,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "munge";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "munge-${finalAttrs.version}";
    sha256 = "sha256-Hoaldm55E0HC3qqqBS5uZvlgcWepnVLyJNQMB2P/t9Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt # provides libgcrypt.m4
  ];

  buildInputs = [
    libgcrypt
    zlib
    bzip2
  ];

  strictDeps = true;

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--runstatedir=/run"
    "--with-sysconfigdir=/etc/default"
    "--with-pkgconfigdir=${placeholder "out"}/lib/pkgconfig"
    "--with-systemdunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-libgcrypt-prefix=${lib.getDev libgcrypt}"
    "ac_cv_file__dev_spx=no"
    "x_ac_cv_check_fifo_recvfd=no"
  ];

  installFlags = [
    "localstatedir=${placeholder "out"}/var"
    "runstatedir=${placeholder "out"}/run"
    "sysconfdir=${placeholder "out"}/etc"
    "sysconfigdir=${placeholder "out"}/etc/default"
  ];

  postInstall = ''
    rmdir "$out"/{var{/{lib,log}{/munge,},},etc/munge}
  '';

  meta = with lib; {
    description = "An authentication service for creating and validating credentials";
    homepage = "https://github.com/dun/munge";
    license = [
      licenses.gpl3Plus
      licenses.lgpl3Plus
    ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
