{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfortivpn";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "openfortivpn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJSEBfhb2dFEOW/sJyB7xFLGGUQLjkz20V80L0ew7J8=";
  };

  # we cannot write the config file to /etc and as we don't need the file, so drop it
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace '$(DESTDIR)$(confdir)' /tmp
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    systemd
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "openfortivpn";
  };
})
