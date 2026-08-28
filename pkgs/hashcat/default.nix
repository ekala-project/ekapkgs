{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  minizip,
  opencl-headers,
  ocl-icd,
  perl,
  python3,
  xxhash,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hashcat";
  version = "7.1.2";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-lUamMm10dTC0T8wHm6utQDBKh/MtPJCAAW1Ys5z8i5Y=";
  };

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail "export MACOSX_DEPLOYMENT_TARGET" "#export MACOSX_DEPLOYMENT_TARGET" \
      --replace-fail "/usr/bin/ar" "ar" \
      --replace-fail "/usr/bin/sed" "sed" \
      --replace-fail '-i ""' '-i'
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    minizip
    opencl-headers
    perl
    (python3.withPackages (
      ps: with ps; [
        protobuf
        pyasn1
        pycryptodome
        python-snappy
        simplejson
      ]
    ))
    xxhash
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${finalAttrs.version}"
    "USE_SYSTEM_OPENCL=1"
    "USE_SYSTEM_XXHASH=1"
    "USE_SYSTEM_ZLIB=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "IS_AARCH64=1"
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/share/hashcat/OpenCL/*.cl; do
      # Rewrite files to be included for compilation at runtime for opencl offload
      sed "s|#include \"\(.*\)\"|#include \"$out/share/hashcat/OpenCL/\1\"|g" -i "$f"
      sed "s|#define COMPARE_\([SM]\) \"\(.*\.cl\)\"|#define COMPARE_\1 \"$out/share/hashcat/OpenCL/\2\"|g" -i "$f"
    done
  '';

  postFixup =
    let
      LD_LIBRARY_PATH = "${ocl-icd}/lib";
    in
    ''
      wrapProgram $out/bin/hashcat \
        --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg LD_LIBRARY_PATH}
    '';

  meta = {
    description = "Fast password cracker";
    mainProgram = "hashcat";
    homepage = "https://hashcat.net/hashcat/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
