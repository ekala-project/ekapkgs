{
  buildPerlModule,
  fetchurl,
  fetchpatch2,
  lib,
  TestNoWarnings,
}:
buildPerlModule {
  pname = "Net-IDN-Encode";
  version = "2.500";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CF/CFAERBER/Net-IDN-Encode-2.500.tar.gz";
    hash = "sha256-VUU2M+P/JM4yWzS8LIFXuYWZYqMatc8ov3zMHJs6Pqo=";
  };

  patches = [
    (fetchpatch2 {
      name = "Net-IDN-Encode-use-uvchr_to_utf8_flags.patch";
      url = "https://github.com/cfaerber/Net-IDN-Encode/commit/3ebe6f2e239b470efcb64a044edc8202798188af.diff";
      hash = "sha256-t/BulZoyRvpi+TKNxKFxUS1y3X7bGi1sG7mG75nW/Gc=";
    })
  ];

  buildInputs = [ TestNoWarnings ];

  meta = {
    description = "Internationalizing Domain Names in Applications (UTS #46)";
    homepage = "https://metacpan.org/release/Net-IDN-Encode";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
