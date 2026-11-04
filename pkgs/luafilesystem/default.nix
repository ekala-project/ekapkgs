{
  lib,
  lua,
  fetchFromGitHub,
  fetchurl,
}:

lua.pkgs.buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.9.0-1";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/luafilesystem-1.9.0-1.rockspec";
      sha256 = "1jg1w8c22hpv1jfcv6qyl3j354h1ar2qfarkiwx0c41sl90gpfrj";
    }).outPath;

  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luafilesystem";
    tag = "v1_9_0";
    hash = "sha256-xoNJra/yqxRG11TePcUKrAUU6cwypGnXIoLKZXNaoW0=";
  };

  meta = {
    homepage = "https://github.com/lunarmodules/luafilesystem";
    license = lib.licenses.mit;
    description = "File System Library for the Lua Programming Language";
  };
}
