{
  lib,
  lua,
  fetchFromGitHub,
  fetchurl,
}:

lua.pkgs.buildLuarocksPackage {
  pname = "luasocket";
  version = "3.1.0-1";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/luasocket-3.1.0-1.rockspec";
      sha256 = "0wg9735cyz2gj7r9za8yi83w765g0f4pahnny7h0pdpx58pgfx4r";
    }).outPath;

  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luasocket";
    tag = "v3.1.0";
    hash = "sha256-sKSzCrQpS+9reN9IZ4wkh4dB50wiIfA87xN4u1lyHo4=";
  };

  meta = {
    homepage = "https://github.com/lunarmodules/luasocket";
    license = lib.licenses.mit;
    description = "Network support for the Lua language";
  };
}
