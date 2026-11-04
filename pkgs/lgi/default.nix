{
  lib,
  lua,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  pkg-config,
  glib,
  gobject-introspection,
}:

lua.pkgs.buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";
  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/lgi-0.9.2-1.rockspec";
      sha256 = "1gqi07m4bs7xibsy4vx8qgyp3yb1wnh0gdq1cpwqzv35y6hn5ds3";
    }).outPath;
  src = fetchFromGitHub {
    owner = "pavouk";
    repo = "lgi";
    tag = "0.9.2";
    hash = "sha256-UpamUbvqzF0JKV3J0wIiJlV6iedwe823vD0EIm3zKw8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    gobject-introspection
  ];

  patches = [
    (fetchpatch {
      name = "lgi-find-cairo-through-typelib.patch";
      url = "https://github.com/psychon/lgi/commit/46a163d9925e7877faf8a4f73996a20d7cf9202a.patch";
      sha256 = "0gfvvbri9kyzhvq3bvdbj2l6mwvlz040dk4mrd5m9gz79f7w109c";
    })
    ./glib-2.88.patch
    (fetchpatch {
      name = "lgi-lua-5.4-lua_resume.patch";
      url = "https://github.com/lgi-devs/lgi/commit/5cfd42c386d3adae6d211fbb4011179c3c141b04.patch";
      hash = "sha256-lpCkRzLy5V540COJkQatjCVR2Y/ThcgswgwxWpmLcyM=";
    })
    (fetchpatch {
      name = "lgi-lua-5.5-loop-variable.patch";
      url = "https://github.com/lgi-devs/lgi/commit/1953ef7f9178671c4ef878ecf2482da6eb493251.patch";
      hash = "sha256-gwcf4sb6mugohcWq2C3sc8L3BDS3QCGmNhLHUkz8+/k=";
    })
  ];

  postPatch = ''
    substituteInPlace lgi/Makefile tests/Makefile \
      --replace 'PKG_CONFIG =' 'PKG_CONFIG ?='
  '';

  preConfigure = ''
    make rock
  '';

  meta = {
    homepage = "https://github.com/pavouk/lgi";
    license = lib.licenses.mit;
    description = "Lua bindings to GObject libraries";
  };
}
