{
  stdenv,
  lib,
  fetchurl,
  ncurses,
  perl,
  help2man,
  libxcrypt,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "inetutils";
  version = "2.6";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-aL7b/q9z99hr4qfZm8+9QJPYKfUncIk5Ga4XTAsjV8o=";
  };

  patches = [
    ./inetutils-1_9-PATH_PROCNET_DEV.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    help2man
    perl
  ];

  buildInputs = [
    ncurses
    libxcrypt
  ];

  preConfigure =
    let
      isCross = stdenv.hostPlatform != stdenv.buildPlatform;
    in
    lib.optionalString isCross ''
      export HELP2MAN=true
    '';

  configureFlags = [
    "--with-ncurses-include-dir=${ncurses.dev}/include"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--disable-rcp"
    "--disable-rsh"
    "--disable-rlogin"
    "--disable-rexec"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-servers";

  doCheck = true;

  installFlags = [ "SUIDMODE=" ];

  meta = {
    description = "Collection of common network programs";
    homepage = "https://www.gnu.org/software/inetutils/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    priority = (util-linux.meta.priority or lib.meta.defaultPriority) + 1;
  };
}
