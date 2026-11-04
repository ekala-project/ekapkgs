{
  lib,
  lua,
  fetchFromGitHub,
}:

# luabitop requires Lua 5.1-5.2
lua.v5_2_compat.pkgs.buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  src = fetchFromGitHub {
    owner = "teto";
    repo = "luabitop";
    rev = "96f0a3d73ae5183d0a81bc2f29326eaa06becbfd";
    hash = "sha256-PrM8ncb3TaqgVhFdRa+rUsJ5WuIzS4/DRqVqj8tCaeg=";
  };

  meta = {
    homepage = "http://bitop.luajit.org/";
    license = lib.licenses.mit;
    description = "Lua Bit Operations Module";
  };
}
