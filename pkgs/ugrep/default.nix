{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  brotli,
  bzip2,
  bzip3,
  lz4,
  makeWrapper,
  pcre2,
  xz,
  zlib,
  zstd,
  poppler-utils ? null,
  antiword ? null,
  pandoc ? null,
  exiftool ? null,
  wrapWithFilterUtils ? false,
  createGrepReplacementLinks ? false,
  gnugrep,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugrep";
  version = "7.8.2";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "ugrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EJU5PvwvDdN52/0vIqUJAIsHcfVJWuZHZ7tTR87eN7Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    boost
    brotli
    bzip2
    bzip3
    lz4
    pcre2
    xz
    zlib
    zstd
  ];

  postFixup = ''
    for i in ug+ ugrep+; do
      wrapProgram "$out/bin/$i" --prefix PATH : "${
        lib.makeBinPath (
          [ "$out" ]
          ++ (lib.optionals (wrapWithFilterUtils) (
            lib.filter (x: x != null) [
              poppler-utils
              antiword
              pandoc
              exiftool
            ]
          ))
        )
      }"
    done
  ''
  + lib.optionalString createGrepReplacementLinks ''
    for i in ${
      lib.concatStringsSep " " [
        "grep"
        "egrep"
        "fgrep"
        "zgrep"
        "zegrep"
        "zfgrep"
      ]
    }; do
      ln -s "$out/bin/ugrep" "$out/bin/$i"
    done
  '';

  meta = {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
    changelog = "https://github.com/Genivia/ugrep/releases/tag/v${finalAttrs.version}";
    maintainers = [ ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "ug";
  }
  // lib.optionalAttrs createGrepReplacementLinks {
    priority = (gnugrep.meta.priority or lib.meta.defaultPriority) - 1;
  };
})
