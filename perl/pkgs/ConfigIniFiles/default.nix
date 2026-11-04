{
  buildPerlPackage,
  fetchurl,
  lib,
  IOStringy,
}:
buildPerlPackage {
  pname = "Config-IniFiles";
  version = "3.002000";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Config-IniFiles-3.002000.tar.gz";
    hash = "sha256-Bmke17QZl+hQxOfGs05cOWFF4M0FCvGUSiDQaMOlpAs=";
  };

  propagatedBuildInputs = [ IOStringy ];

  meta = {
    description = "Module for reading .ini-style configuration files";
    homepage = "https://metacpan.org/release/Config-IniFiles";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
