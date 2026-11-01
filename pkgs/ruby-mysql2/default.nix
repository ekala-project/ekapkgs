{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mysql2";
  version = "0.5.7";
  source.sha256 = "0ywxbvx2blswi6zfjxsqz8jz1c0giivin2h4j9qqmbm02pjys2ds";

  meta = {
    description = "Simple, fast MySQL library for Ruby, binding to libmysql";
    homepage = "https://github.com/brianmario/mysql2";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
    broken = true; # native extension needs mysql/mariadb client libraries
  };
}
