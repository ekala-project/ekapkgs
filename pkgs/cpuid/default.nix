{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpuid";
  version = "20260503";

  src = fetchurl {
    url = "https://etallen.com/cpuid/cpuid-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-juEPtI1KogxISnXWhSiDcQKG7Sl1wxS9ptCwODkIy/4=";
  };

  # For pod2man during the build process.
  nativeBuildInputs = [ perl ];

  # As runtime dependency for cpuinfo2cpuid.
  buildInputs = [ perl ];

  # The Makefile hardcodes $(BUILDROOT)/usr as installation
  # destination. Just nuke all mentions of /usr to get the right
  # installation location.
  patchPhase = ''
    sed -i -e 's,/usr/,/,' Makefile
  '';

  installPhase = ''
    make install BUILDROOT=$out

    if [ ! -x $out/bin/cpuid ]; then
      echo Failed to properly patch Makefile.
      exit 1
    fi
  '';

  meta = {
    description = "Linux tool to dump x86 CPUID information about the CPU";
    homepage = "http://etallen.com/cpuid.html";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
