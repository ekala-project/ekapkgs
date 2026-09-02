{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  yasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xvidcore";
  version = "1.3.7";

  src = fetchurl {
    url = "https://downloads.xvid.com/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ruqulS1Ns5UkmDmjvQOEHWhEhD9aT4TCcf+I96oaz/c=";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/xvidcore/raw/95382dbe529e5589a727fffceb620b0a89ff55f2/f/xvidcore-c23.patch";
      hash = "sha256-bGwWNmXIEIIw4Tc7lrMZ4jnhcQ+uKAsxL6fuAOosMVA=";
    })
  ];

  preConfigure = ''
    # Configure script is not in the root of the source directory
    cd build/generic
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure --replace "-no-cpp-precomp" ""
  '';

  configureFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "--enable-macosx_module"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) [
      "--disable-assembly"
    ];

  nativeBuildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) yasm;

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    rm $out/lib/*.a
  '';

  meta = {
    description = "MPEG-4 video codec for PC";
    homepage = "https://www.xvid.com/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
})
