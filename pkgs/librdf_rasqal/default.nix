{
  lib,
  stdenv,
  fetchurl,
  librdf_raptor2,
  gmp,
  pkg-config,
  libxml2,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rasqal";
  version = "0.9.33";

  src = fetchurl {
    url = "http://download.librdf.org/source/rasqal-${finalAttrs.version}.tar.gz";
    sha256 = "0z6rrwn4jsagvarg8d5zf0j352kjgi33py39jqd29gbhcnncj939";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gmp
    libxml2
  ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  configureFlags = [
    "--disable-pcre"
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  nativeCheckInputs = [ perl ];
  doCheck = false;
  doInstallCheck = false;

  meta = {
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = "https://librdf.org/rasqal";
    license = with lib.licenses; [
      lgpl21
      asl20
    ];
    platforms = lib.platforms.unix;
  };
})
