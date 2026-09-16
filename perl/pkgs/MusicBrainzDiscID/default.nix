{
  buildPerlPackage,
  fetchurl,
  lib,
  pkg-config,
  libdiscid,
}:
buildPerlPackage {
  pname = "MusicBrainz-DiscID";
  version = "0.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NJ/NJH/MusicBrainz-DiscID-0.06.tar.gz";
    hash = "sha256-ugtu0JiX/1Y7pZhy7pNxW+83FXUVsZt8bW8obmVI7Ks=";
  };
  postPatch = ''
    substituteInPlace Makefile.PL \
      --replace-fail '`which pkg-config`' "'$PKG_CONFIG'"
  '';
  patches = [ ../../MusicBrainz-DiscID---ExtUtils-ParseXS-compat.patch ];
  doCheck = false;
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libdiscid ];
  meta = {
    description = "Perl interface for the MusicBrainz libdiscid library";
    license = lib.licenses.mit;
  };
}
