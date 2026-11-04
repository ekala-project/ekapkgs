{
  buildRubyGem,
  lib,
  ruby,
  pkg-config,
  sqlite,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "sqlite3";
  version = "2.10.2";
  source.sha256 = "0r39asq48zjcvmh4lgac75zlxvyh9fgar25076gs9y476b6nispi";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];
  buildFlags = [ "--enable-system-libraries" ];

  meta = {
    description = "Ruby library to interface with the SQLite3 database engine";
    homepage = "https://github.com/sparklemotion/sqlite3-ruby";
    license = lib.licenses.bsd3;
    platforms = ruby.meta.platforms;
  };
}
