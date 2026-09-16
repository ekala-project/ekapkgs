{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
}:
buildPerlPackage {
  pname = "Module-Build";
  version = "0.4234";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz";
    hash = "sha256-Zq6sYSdBi+XkcerTdEZIx2a9AUgoJcW2ZlJnXyvIao8=";
  };
  postConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    ./Build || true
  '';
  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i '/File::Temp/d' Build.PL
    sed -i "s,\$self->_discover_perl_interpreter,'$(type -p perl)',g" \
      lib/Module/Build/Base.pm
  '';
  meta = {
    description = "Build and install Perl modules";
  };
}
