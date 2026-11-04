{
  lib,
  lua,
  fetchFromGitHub,
  fetchurl,
  expat,
}:

lua.pkgs.buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.5.2-1";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/luaexpat-1.5.2-1.rockspec";
      sha256 = "0wdbph2c92zmvvyp3q669rbjy1xjm7jy1i13lin8b636vswykw6p";
    }).outPath;

  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luaexpat";
    tag = "1.5.2";
    hash = "sha256-PudxKlN4WKUUK/h6ekVNSa/C453CnLh3TxCncXIOiw8=";
  };

  externalDeps = [
    {
      name = "EXPAT";
      dep = expat;
    }
  ];

  meta = {
    homepage = "https://lunarmodules.github.io/luaexpat";
    license = lib.licenses.mit;
    description = "XML Expat parsing for Lua";
  };
}
