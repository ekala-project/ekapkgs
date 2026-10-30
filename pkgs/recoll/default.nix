{
  stdenv,
  fetchurl,
  lib,
  antiword,
  aspell,
  bison,
  catdoc,
  catdvi ? null,
  chmlib,
  djvulibre,
  file,
  gawk,
  ghostscript,
  grep,
  sed,
  tar,
  groff,
  gzip,
  libiconv,
  libwpd,
  libxslt,
  lyx,
  makeWrapper,
  meson,
  ninja,
  perl,
  perlPackages,
  pkg-config,
  poppler-utils,
  python3Packages,
  libsForQt5,
  unrtf,
  untex,
  unzip,
  which,
  xapian,
  zlib,
  withGui ? true,
  withPython ? with stdenv; buildPlatform.canExecute hostPlatform,
}:

let
  filters = {
    awk = gawk;
    antiword = antiword;
    catppt = catdoc;
    djvused = djvulibre;
    djvutxt = djvulibre;
    egrep = grep;
    groff = groff;
    gunzip = gzip;
    iconv = libiconv;
    pdftotext = poppler-utils;
    ps2ascii = ghostscript;
    sed = sed;
    tar = tar;
    unzip = unzip;
    xls2csv = catdoc;
    xsltproc = libxslt;
    unrtf = unrtf;
    untex = untex;
    wpd2html = libwpd;
    perl = perl.passthru.withPackages (p: [ p.ImageExifTool ]);
  }
  // lib.optionalAttrs (catdvi != null) {
    catdvi = catdvi;
  };
  filterPath = lib.makeBinPath (map lib.getBin (builtins.attrValues filters));
  useInotify = if stdenv.hostPlatform.isLinux then "true" else "false";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "recoll";
  version = "1.43.9";

  src = fetchurl {
    url = "https://www.recoll.org/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-irloDtMO9CBvtI+oEicUOy2myrGskieWoqNk5eapzU8=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    which
    libsForQt5.wrapQtAppsHook
  ]
  ++ lib.optionals withGui [
    libsForQt5.qtbase
    libsForQt5.qttools
  ]
  ++ lib.optionals withPython [
    python3Packages.setuptools
  ];

  buildInputs = [
    aspell
    bison
    chmlib
  ]
  ++ lib.optionals withPython [
    python3Packages.python
    python3Packages.mutagen
  ]
  ++ [
    xapian
    zlib
    file
  ]
  ++ lib.optionals withGui [
    libsForQt5.qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  mesonFlags = [
    "-Drecollq=true"
    "-Dwebkit=false"
    "-Dsystemd=false"

    # this leaks into the final `librecoll-*.so` binary, so we need
    # to be sure it is taken from `pkgs.file` rather than `stdenv`,
    # especially when cross-compiling
    "-Dfile-command=${file}/bin/file"
  ]
  ++ lib.optionals (!withPython) [
    "-Dpython-module=false"
    "-Dpython-chm=false"
  ]
  ++ lib.optionals (!withGui) [
    "-Dqtgui=false"
    "-Dx11mon=false"
  ]
  ++ [
    "-Dinotify=${useInotify}"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-fpermissive"
  ];

  patches = [
    ./0001-no-qtgui-darwin-bundle.patch
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${filterPath}"
  ];

  postInstall = ''
    substituteInPlace $out/lib/*/site-packages/recoll/rclconfig.py --replace /usr/share/recoll $out/share/recoll
    substituteInPlace $out/share/recoll/filters/rclconfig.py       --replace /usr/share/recoll $out/share/recoll
    for f in $out/share/recoll/filters/* ; do
      if [[ ! "$f" =~ \.zip$ ]]; then
  ''
  + lib.concatStrings (
    lib.mapAttrsToList (k: v: ''
      substituteInPlace $f --replace '"${k}"'  '"${lib.getBin v}/bin/${k}"'
    '') filters
  )
  + ''
        substituteInPlace $f --replace '"pstotext"'  '"${lib.getBin ghostscript}/bin/ps2ascii"'
        substituteInPlace $f --replace /usr/bin/perl   ${
          lib.getBin (perl.passthru.withPackages (p: [ p.ImageExifTool ]))
        }/bin/perl
      fi
    done
    wrapProgram $out/share/recoll/filters/rclaudio.py \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/share/recoll/filters/rcljoplin.py \
      --prefix PYTHONPATH : $out/${python3Packages.python.sitePackages}
    wrapProgram $out/share/recoll/filters/rclimg \
      --prefix PERL5LIB : "${with perlPackages; makeFullPerlPath [ ImageExifTool ]}"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace  $f --replace '"lyx"' '"${lib.getBin lyx}/bin/lyx"'
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && withGui) ''
    mkdir $out/Applications
    mv $out/bin/recoll.app $out/Applications
  '';

  # create symlink after fixup to prevent double wrapping of recoll
  postFixup = lib.optionalString (stdenv.hostPlatform.isDarwin && withGui) ''
    ln -s ../Applications/recoll.app/Contents/MacOS/recoll $out/bin/recoll
  '';

  enableParallelBuilding = false;

  meta = {
    description = "Full-text search tool";
    longDescription = ''
      Recoll is an Xapian frontend that can search through files, archive
      members, email attachments.
    '';
    homepage = "https://www.recoll.org";
    changelog = "https://www.recoll.org/pages/release-history.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    broken =
      stdenv.hostPlatform.isDarwin
      || (withPython && !stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
