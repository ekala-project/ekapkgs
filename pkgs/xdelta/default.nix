{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdelta";
  version = "3.1.0";

  src = fetchFromGitHub {
    sha256 = "09mmsalc7dwlvgrda56s2k927rpl3a5dzfa88aslkqcjnr790wjy";
    rev = "v${finalAttrs.version}";
    repo = "xdelta-devel";
    owner = "jmacd";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ xz ];

  postPatch = ''
    cd xdelta3
  '';

  configureFlags = [
    "--with-liblzma"
  ];

  enableParallelBuilding = true;

  doCheck = false;

  installPhase = ''
    install -D -m755 xdelta3 $out/bin/xdelta3
    install -D -m644 xdelta3.1 $out/share/man/man1/xdelta3.1
  '';

  meta = {
    description = "Binary differential compression in VCDIFF (RFC 3284) format";
    homepage = "https://github.com/jmacd/xdelta";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xdelta3";
    platforms = lib.platforms.unix;
  };
})
