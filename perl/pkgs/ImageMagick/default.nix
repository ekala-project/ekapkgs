{
  buildPerlPackage,
  lib,
  imagemagick,
}:
buildPerlPackage rec {
  pname = "Image-Magick";
  inherit (imagemagick) version src;
  sourceRoot = "${src.name}/PerlMagick";
  buildInputs = [ imagemagick ];
  preConfigure = ''
    pushd ..
    chmod -R +rwX .
    ./configure --with-perl
    make perl-quantum-sources
    popd
  '';
  meta = {
    description = "Object-oriented Perl interface to ImageMagick";
    license = lib.licenses.imagemagick;
  };
}
