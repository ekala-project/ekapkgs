{
  buildPerlPackage,
  fetchurl,
  fetchDebianPatch,
  lib,
  stdenv,
  curl,
}:
buildPerlPackage rec {
  pname = "WWW-Curl";
  version = "4.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SZ/SZBALINT/WWW-Curl-4.17.tar.gz";
    hash = "sha256-Uv+rEQ4yNI13XyQclz61b5awju28EQ130lfNsKJKt7o=";
  };
  patches =
    let
      pname = "libwww-curl-perl";
      debianRevision = "12";
    in
    [
      (fetchDebianPatch {
        inherit debianRevision pname version;
        patch = "Skip-preprocessor-symbol-only-CURL_STRICTER.patch";
        hash = "sha256-9NcGBjVTbXWr4axl9cKsaAKt+spxDf97M76KDX7vl0I=";
      })
      (fetchDebianPatch {
        inherit debianRevision pname version;
        patch = "WWW-Curl-4.17-RT130591.patch";
        hash = "sha256-RoAjUSt8WwcxEgjDgitr8u+0BKcHUzIJts3ohKKmzg4=";
      })
      (fetchDebianPatch {
        inherit debianRevision pname version;
        patch = "workaround_DEPRECAT.patch";
        hash = "sha256-oZBk2RUr2wVtrFhFN20TI2eWSCtcJbG+fPKhc1Br7JY=";
      })
      (fetchDebianPatch {
        inherit debianRevision pname version;
        patch = "typo_therefore.patch";
        hash = "sha256-UQTyv9YgIZC3S5Ih3qazPmQR4RLY7IEAmuMJUAyjewA=";
      })
      (fetchDebianPatch {
        inherit debianRevision pname version;
        patch = "curl_8.13.0.patch";
        hash = "sha256-VTp0CtVakGti23DvRJwnuP3//eS4BzV5/n+A2zg/a+k=";
      })
    ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-return-type";
  nativeBuildInputs = [ curl ];

  buildInputs = [ curl ];
  doCheck = false;
  meta = {
    description = "Perl extension interface for libcurl";
    license = lib.licenses.mit;
  };
}
