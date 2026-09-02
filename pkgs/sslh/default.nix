{
  lib,
  stdenv,
  fetchFromGitHub,
  libcap,
  libev,
  libconfig,
  perl,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sslh";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "yrutschle";
    repo = "sslh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wHolBYn9pmCYEA6FkYkE1PJtlH0MZJkSVz+tSj3cS60=";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [
    libev
    libconfig
    perl
    pcre2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ];

  makeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "USELIBCAP=1"
  ];

  postInstall = ''
    install -p sslh-fork "$out/sbin/sslh-fork"
    install -p sslh-select "$out/sbin/sslh-select"
    install -p sslh-ev "$out/sbin/sslh-ev"
    ln -sf sslh-fork "$out/sbin/sslh"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.rutschle.net/tech/sslh/README.html";
    platforms = lib.platforms.all;
  };
})
