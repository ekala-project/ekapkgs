{
  lib,
  lua,
  fetchurl,
  libmpack,
}:

lua.pkgs.buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.13-0";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/mpack-1.0.13-0.rockspec";
      sha256 = "1lyjbmyj6yfv0bhyj50rpz2qm993zsbyw494j9kz4bcvxx0gqac5";
    }).outPath;

  src = fetchurl {
    url = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.13/libmpack-lua-1.0.13.tar.gz";
    sha256 = "1mwk54jnayw5wjclijyha24xq4sj0lyidb04zyndd9i0yr4anlnx";
  };

  buildInputs = [ libmpack ];

  env = {
    USE_SYSTEM_LUA = "yes";
    USE_SYSTEM_MPACK = "yes";
  };

  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua";
    license = lib.licenses.mit;
    description = "Lua binding to libmpack";
  };
}
