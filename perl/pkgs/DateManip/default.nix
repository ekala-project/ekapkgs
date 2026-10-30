{
  buildPerlPackage,
  fetchurl,
  stdenv,
  fetchpatch,
  lib,
  TestInter,
  coreutils,
}:
buildPerlPackage {

  pname = "Date-Manip";
  version = "6.98";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-6.98.tar.gz";
    hash = "sha256-rP2KYFGbpM0YHIpnqD1/ApxtmrTosCEtxH5B1iEP2kk=";
  };
  # Remove when updating to the first release containing both CVE fixes.
  patches = [
    (fetchpatch {
      name = "CVE-2026-60074.patch";
      url = "https://security.metacpan.org/patches/D/Date-Manip/6.99/CVE-2026-60074-r1.patch";
      hash = "sha256-leXFfzLyy0yBpBXgT3u3ZyFaIbsbJSFzVkdam9hb3+0=";
    })
    (fetchpatch {
      name = "CVE-2026-60075.patch";
      url = "https://security.metacpan.org/patches/D/Date-Manip/6.99/CVE-2026-60075-r1.patch";
      hash = "sha256-vMsOrUhrfn8efKRzfJ+jaypOHER8MlUIob5u88n/TAw=";
    })
  ];
  # for some reason, parsing /etc/localtime does not work anymore - make sure that the fallback "/bin/date +%Z" will work
  postPatch = ''
    sed -i "s#/bin/date#${coreutils}/bin/date#" lib/Date/Manip/TZ.pm
  '';
  doCheck = !stdenv.hostPlatform.isi686; # build freezes during tests on i686
  buildInputs = [ TestInter ];
  meta = {
    description = "Date manipulation routines";
    homepage = "https://github.com/SBECK-github/Date-Manip";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
