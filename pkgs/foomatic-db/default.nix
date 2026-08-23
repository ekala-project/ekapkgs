{
  lib,
  stdenv,
  fetchFromGitHub,
  cups,
  cups-filters ? null,
  ghostscript,
  gnused,
  perl,
  autoconf,
  automake,
  patchPpdFilesHook ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foomatic-db";
  version = "0-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "foomatic-db";
    rev = "57e546cb7774c7b03e7090ced65fb1ffd552f33d";
    hash = "sha256-mQEOV+NJId5h/hYOL+2JrEHjqM77qRExDNeqZ0IyA08=";
  };

  buildInputs = [
    cups
    cups-filters
    ghostscript
    gnused
    perl
  ];

  nativeBuildInputs = [
    autoconf
    automake
    patchPpdFilesHook
    perl
  ];

  postPatch = ''
    sed -Ei -e 's|^(S?BINSEARCHPATH=).+$|\1"@PATH@"|g'  \
      -e 's|^(DATASEARCHPATH=).+$|\1"@DATA@"|g' configure.ac
    substituteInPlace configure.ac  \
      --subst-var PATH  \
      --subst-var-by DATA "${placeholder "out"}/share"
  '';

  preConfigure = ''
    mkdir -p "${placeholder "out"}/share/foomatic/db/source"
    ./make_configure
  '';

  configureFlags = [ "--disable-gzip-ppds" ];

  postInstall = ''
    if ! [[ -d "${placeholder "out"}/share/foomatic/db/source/PPD" ]]; then
        echo "failed to create share/foomatic/db/source/PPD"
        exit 1
    fi
    mkdir -p "${placeholder "out"}/share/cups/model"
    ln -s "${placeholder "out"}/share/foomatic/db/source/PPD"  \
      "${placeholder "out"}/share/cups/model/foomatic-db"
  '';

  ppdFileCommands = [
    "cat"
    "date"
    "printf"
    "rastertohp"
    "foomatic-rip"
    "gs"
    "sed"
    "perl"
  ];

  postFixup = ''
    echo 'compressing ppd files'
    find -H "${placeholder "out"}/share/cups/model/foomatic-db" -type f -iname '*.ppd' -print0  \
      | xargs -0r -n 64 -P "$NIX_BUILD_CORES" gzip -9n
  '';

  meta = {
    changelog = "https://github.com/OpenPrinting/foomatic-db/blob/${finalAttrs.src.rev}/ChangeLog";
    description = "OpenPrinting printer support database (free content)";
    downloadPage = "https://www.openprinting.org/download/foomatic/";
    homepage = "https://openprinting.github.io/projects/02-foomatic/";
    license = lib.licenses.free;
    maintainers = [ ];
    longDescription = ''
      The collected knowledge about printers,
      drivers, and driver options in XML files,
      used by `foomatic-db-engine` to generate PPD files.
      PPD files generated from the XML files in this package
      are contained in the package 'foomatic-db-ppds'.
      Besides the XML files, this package contains
      about 6,700 PPD files, for printers from
      Brother, Canon, Epson, Gestetner, HP, InfoPrint,
      Infotec, KONICA_MINOLTA, Kyocera, Lanier, Lexmark, NRG,
      Oce, Oki, Ricoh, Samsung, Savin, Sharp, Toshiba and Utax.
    '';
  };
})
