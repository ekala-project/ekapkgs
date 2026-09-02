{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ggml";
  version = "0.21.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "ggml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-emGgUT9FzbUI1vIknjHFfG88wpzc4JRzIqgap+O7MaM=";
  };

  # The cmake package does not handle absolute CMAKE_INSTALL_LIBDIR and CMAKE_INSTALL_INCLUDEDIR
  # correctly.
  # Tracking: https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace ggml.pc.in \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" \
        "@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" \
        "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Tensor library for machine learning";
    homepage = "https://github.com/ggml-org/ggml";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
