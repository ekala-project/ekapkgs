{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  protobuf,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onnx";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gc65t/VN3kdvV9tiFoOk6Sw+OZe4Udgm3VcZPP9gzpE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    ninja.setupHook
    python3Packages.python
    python3Packages.pybind11
  ];

  buildInputs = [
    protobuf
  ];

  cmakeEntries = {
    ONNX_USE_PROTOBUF_SHARED_LIBS = true;
    BUILD_SHARED_LIBS = true;
    ONNX_BUILD_PYTHON = false;
    ONNX_BUILD_TESTS = false;
    ONNX_ML = true;
    ONNX_NAMESPACE = "onnx";
    CMAKE_CXX_FLAGS = "-DONNX_NO_EXCEPTIONS";
  };

  postInstall = ''
    find "$out/include/onnx" -type d -empty -delete || true
  '';

  meta = {
    description = "Open Neural Network Exchange";
    homepage = "https://onnx.ai";
    license = lib.licenses.asl20;
    changelog = "https://github.com/onnx/onnx/releases/tag/v${finalAttrs.version}";
  };
})
