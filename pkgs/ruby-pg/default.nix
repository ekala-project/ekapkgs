{
  buildRubyGem,
  lib,
  ruby,
  pkg-config,
  libpq,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "pg";
  version = "1.6.2";
  source.sha256 = "0xf8i58shwvwlka4ld12nxcgqv0d5r1yizsvw74w5jaw83yllqaq";

  buildFlags = [ "--with-pg-config=ignore" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpq ];

  meta = {
    description = "Ruby interface to the PostgreSQL RDBMS";
    homepage = "https://github.com/ged/ruby-pg";
    license = lib.licenses.bsd2;
    platforms = ruby.meta.platforms;
  };
}
