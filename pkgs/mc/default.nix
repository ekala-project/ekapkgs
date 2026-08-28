{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pkg-config,
  glib,
  gpm,
  file,
  e2fsprogs,
  perl,
  zip,
  unzip,
  gettext,
  slang,
  libssh2,
  openssl,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "mc";
  version = "4.8.33";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/midnightcommander/${pname}-${version}.tar.xz";
    hash = "sha256-yuFJ1C+ETlGF2MgdfbOROo+iFMZfhSIAqdiWtGivFkw=";
  };

  nativeBuildInputs = [
    pkg-config
    unzip
  ];

  buildInputs = [
    file
    gettext
    glib
    libssh2
    openssl
    slang
    zip
    e2fsprogs
    gpm
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "PERL=${perl}/bin/perl"
    "PERL_FOR_BUILD=${buildPackages.perl}/bin/perl"
    "--disable-configure-args"
    "--without-x"
  ];

  postPatch = ''
    substituteInPlace src/filemanager/ext.c \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  meta = {
    description = "File Manager and User Shell for the GNU Project, known as Midnight Commander";
    downloadPage = "https://ftp.osuosl.org/pub/midnightcommander/";
    homepage = "https://midnight-commander.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "mc";
  };
}
