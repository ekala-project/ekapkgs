{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  CanaryStability,
  commonsense,
}:
buildPerlPackage {
  pname = "EV";
  version = "4.34";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/EV-4.34.tar.gz";
    hash = "sha256-EhFoPc57Z3H0q3EMwVNxK913umFXoTKU0LtzSR/QZWA=";
  };
  patches = [
    (fetchpatch {
      name = "EV-4.34-perl-5.42.patch";
      url = "https://free.nchc.org.tw/gentoo-portage/dev-perl/EV/files/EV-4.34-perl-5.42.patch";
      hash = "sha256-GiQ89pk3EZ3b6oxB7jDTY5C62qqKsZUjJ4Ag2JVwGFw=";
    })
  ];
  buildInputs = [ CanaryStability ];
  propagatedBuildInputs = [ commonsense ];
  meta = {
    description = "Perl interface to libev, a high performance full-featured event loop";
    license = lib.licenses.gpl1Plus;
  };
}
