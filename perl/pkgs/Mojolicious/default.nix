{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Mojolicious";
  version = "9.46";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SR/SRI/Mojolicious-9.46.tar.gz";
    hash = "sha256-/kc9LK5tLe/pUBgCggc2VoJa0F20TwvIxIQhXi1xaqw=";
  };
  meta = {
    description = "Real-time web framework";
    homepage = "https://mojolicious.org";
    license = lib.licenses.artistic2;
    mainProgram = "mojo";
  };
}
