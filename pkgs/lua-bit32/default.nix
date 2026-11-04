{
  lib,
  lua,
  fetchurl,
  fetchzip,
}:

lua.pkgs.buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.5.1-1";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/bit32-5.3.5.1-1.rockspec";
      sha256 = "11mg0hmmil92hkwamm91ghih6ys9pqsakx0z9jgnqxymnl887j51";
    }).outPath;

  src = fetchzip {
    url = "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.zip";
    sha256 = "1caxn228gx48g6kymp9w7kczgxcg0v0cd5ixsx8viybzkd60dcn4";
  };

  meta = {
    description = "Lua 5.2 bit manipulation library";
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
