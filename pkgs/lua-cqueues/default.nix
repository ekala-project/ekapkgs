{
  lib,
  lua,
  fetchurl,
  m4,
  openssl,
}:

lua.pkgs.buildLuarocksPackage rec {
  pname = "cqueues";
  version = "20261006-0";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/cqueues-20261006.52-0.rockspec";
      sha256 = "1c8hffqawivwrb95pl6mc3j471cavkr9yrqidyigw3a2s01zdrsq";
    }).outPath;

  src = fetchurl {
    url = "https://github.com/wahern/cqueues/archive/rel-20261006.tar.gz";
    sha256 = "1i77z3939wk9qq7sqa781wgpzmpwrpdakc8zqykidfgh5yc4avaa";
  };

  nativeBuildInputs = [ m4 ];

  externalDeps = [
    {
      name = "CRYPTO";
      dep = openssl;
    }
    {
      name = "OPENSSL";
      dep = openssl;
    }
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  # Upstream rockspec is split per Lua version; patch to support all versions
  postConfigure = ''
    sed -Ei ''${rockspecFilename} \
      -e 's|lua == 5.[[:digit:]]|lua >= 5.1, <= 5.5|' \
      -e 's|build_target = "[^"]+"|build_target = "all"|' \
      -e 's|version = "[^"]+"|version = "${version}"|'
    specDir=$(dirname ''${rockspecFilename})
    cp ''${rockspecFilename} "$specDir/${pname}-${version}.rockspec"
    rockspecFilename="$specDir/${pname}-${version}.rockspec"
  '';

  meta = {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua";
    license = lib.licenses.mit;
  };
}
