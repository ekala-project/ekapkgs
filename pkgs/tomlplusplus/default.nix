{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomlplusplus";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };

  patches = [
    (fetchpatch2 {
      name = "tomlplusplus-install-example-programs.patch";
      url = "https://github.com/marzer/tomlplusplus/commit/8128eb632325d1820f4d17dd8250dcda6ab07743.patch";
      hash = "sha256-7m2P+e1/OASHrzm9LSy6RnayS/kGxFC82xOyGBGXeG0=";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    cmake
    pkg-config
  ];

  mesonFlags = [
    "-Dbuild_tests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    "-Dbuild_examples=true"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/marzer/tomlplusplus";
    description = "Header-only TOML config file parser and serializer for C++17";
    license = lib.licenses.mit;
    pkgConfigModules = [ "tomlplusplus" ];
    platforms = lib.platforms.unix;
  };
})
