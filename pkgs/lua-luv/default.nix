{
  lib,
  lua,
  fetchFromGitHub,
  cmake,
  libuv,
}:

lua.pkgs.buildLuarocksPackage rec {
  pname = "luv";
  version = "1.52.1-0";

  src = fetchFromGitHub {
    owner = "luvit";
    repo = "luv";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-mU+Gvlpvp6iZE5IpXfTr+21QQ34vZk+tYhnr0b891qg=";
  };

  # Use system deps instead of bundled
  prePatch = ''
    rm -rf deps/lua deps/luajit deps/libuv
  '';

  buildInputs = [ libuv ];
  nativeBuildInputs = [ cmake ];

  rockspecFilename = "luv-scm-0.rockspec";

  postConfigure = ''
    mv "$rockspecFilename" "$generatedRockspecFilename"
    rockspecFilename="$generatedRockspecFilename"
    substituteInPlace "$rockspecFilename" \
      --replace-fail 'version = "scm-0"' "version = \"$version\""
  '';

  luarocksConfig.variables = {
    WITH_SHARED_LIBUV = "ON";
  };

  meta = {
    homepage = "https://github.com/luvit/luv";
    description = "Bare libuv bindings for Lua";
    license = lib.licenses.asl20;
    platforms = lua.meta.platforms;
  };
}
