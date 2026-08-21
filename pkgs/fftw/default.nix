{
  fetchurl,
  stdenv,
  lib,
  gfortran,
  precision ? "double",
}:

assert lib.elem precision [
  "single"
  "double"
  "long-double"
  "quad-precision"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "fftw-${precision}";
  version = "3.3.11";

  src = fetchurl {
    urls = [
      "https://fftw.org/fftw-${finalAttrs.version}.tar.gz"
      "ftp://ftp.fftw.org/pub/fftw/fftw-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-VjDCTN6zOxMWEvfrSxqZNCNHVPnziP+GF0WNC+byOaE=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];
  outputBin = "dev";

  nativeBuildInputs = [ gfortran ];

  configureFlags = [
    "--enable-shared"
    "--enable-threads"
    "--enable-openmp"
    "--disable-doc"
  ]
  ++ lib.optional (precision != "double") "--enable-${precision}"
  ++
    lib.optionals (stdenv.hostPlatform.isx86_64 && (precision == "single" || precision == "double"))
      [
        "--enable-sse2"
        "--enable-avx"
        "--enable-avx2"
        "--enable-avx512"
        "--enable-avx128-fma"
      ]
  ++
    lib.optionals (stdenv.hostPlatform.isAarch64 && (precision == "single" || precision == "double"))
      [
        "--enable-neon"
      ];

  postPatch = ''
    substituteInPlace configure --replace-fail "-mtune=native" "-mtune=generic"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Fastest Fourier Transform in the West library";
    homepage = "https://www.fftw.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
