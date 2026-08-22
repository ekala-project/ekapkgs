{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  nss,
  nspr,
  libkrb5,
  gmp,
  zlib,
  re2,
  gcc,
  python3Packages,
  perl,
  perlPackages,
  withOpenCL ? true,
  opencl-headers ? null,
  ocl-icd ? null,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "john";
  version = "1.9.0-Jumbo-1-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "john";
    rev = "b544069b36ac166fb0a2fb19d0dc144ca72da6bb";
    hash = "sha256-dSdezI0+WSufYVLNChNJQ04VzuKczbfBLrI/5smR1fA=";
  };

  postPatch = ''
    sed -ri -e '
      s!^(#define\s+CFG_[A-Z]+_NAME\s+).*/!\1"'"$out"'/etc/john/!
      /^#define\s+JOHN_SYSTEMWIDE/s!/usr!'"$out"'!
    ' src/params.h
    sed -ri -e '/^\.include/ {
      s!\$JOHN!'"$out"'/etc/john!
      s!^(\.include\s*)<([^./]+\.conf)>!\1"'"$out"'/etc/john/\2"!
    }' run/*.conf
  '';

  preConfigure = ''
    cd src
    export AS=$CC
    export LD=$CC
  ''
  + lib.optionalString withOpenCL ''
    python ./opencl_generate_dynamic_loader.py
  '';
  configureFlags = [
    "--disable-native-tests"
    "--with-systemwide"
  ];

  buildInputs = [
    openssl
    nss
    nspr
    libkrb5
    gmp
    zlib
    re2
  ]
  ++ lib.optionals withOpenCL (
    lib.filter (x: x != null) [
      opencl-headers
      ocl-icd
    ]
  );
  nativeBuildInputs = [
    gcc
    python3Packages.wrapPython
    perl
    makeWrapper
  ];
  propagatedBuildInputs =
    (with python3Packages; [
      dpkt
      lxml
      olefile
    ])
    ++ (with perlPackages; [
      DigestMD4
      DigestSHA1
      GetoptLong
      CompressRawLzma
      perlldap
    ]);

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john" "$out/share/john/rules" "$out/share/john/opencl" "$out/${perlPackages.perl.libPrefix}"
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
    cp -vt "$out/share/john/rules" ../run/rules/*.rule
    cp -vt "$out/share/john/opencl" ../run/opencl/*.cl ../run/opencl/*.h
    cp -vLrt "$out/share/doc/john" ../doc/*
    cp -vt "$out/${perlPackages.perl.libPrefix}" ../run/lib/*
  '';

  postFixup = ''
    wrapPythonPrograms

    for i in $out/bin/*.pl; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB:$out/${perlPackages.perl.libPrefix}"
    done
  '';

  meta = {
    description = "John the Ripper password cracker";
    license = [
      lib.licenses.gpl2Plus
    ];
    homepage = "https://github.com/openwall/john/";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
