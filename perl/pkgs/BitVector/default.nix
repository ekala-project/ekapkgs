{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  CarpClan,
}:
buildPerlPackage {
  pname = "Bit-Vector";
  version = "7.4";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-7.4.tar.gz";
    hash = "sha256-PG2qZx/s+8Nfkqk4W1Y9ZfUN/Gvci0gF+e9GwNA1qSY=";
  };
  patches = [
    # Fix build with gcc15
    # https://rt.cpan.org/Public/Bug/Display.html?id=165142
    (fetchpatch {
      name = "perl-bitvector-fix-bool-detection.patch";
      url = "https://src.fedoraproject.org/rpms/perl-Bit-Vector/raw/fe339c95e0da8a130c5bba5a975d37230178b59d/f/0001-Fix-bool-detection.patch";
      hash = "sha256-zC4/RMKhdFNEwNIorzuU76p8P/Lwgv1pF6Oi4MX4M1o=";
    })
  ];
  propagatedBuildInputs = [ CarpClan ];
  meta = {
    description = "Efficient bit vector, set of integers and 'big int' math library";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
      lgpl2Only
    ];
  };
}
