{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  perl,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "triggerhappy";
  version = "0.5.0-1";

  src = fetchFromGitHub {
    owner = "wertarbyte";
    repo = "triggerhappy";
    tag = "debian/${finalAttrs.version}";
    sha256 = "sha256-kIRVbRvUopgSn4RENjHWpHAYxNCIN/72cFnAPMk09pI=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ systemd ];

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(out)/bin"
  ];

  postInstall = ''
    install -D -m 644 -t "$out/etc/triggerhappy/triggers.d" "triggerhappy.conf.examples"
  '';

  meta = {
    description = "Lightweight hotkey daemon";
    longDescription = ''
      Triggerhappy is a hotkey daemon developed with small and embedded systems in
      mind, e.g. linux based routers. It attaches to the input device files and
      interprets the event data received and executes scripts configured in its
      configuration.
    '';
    homepage = "https://github.com/wertarbyte/triggerhappy/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
