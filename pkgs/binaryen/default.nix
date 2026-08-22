{
  lib,
  stdenv,
  cmake,
  python3,
  fetchFromGitHub,
}:
let
  testsuite = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "testsuite";
    rev = "4b24564c844e3d34bf46dfcb3c774ee5163e31cc";
    hash = "sha256-8VirKLRro0iST58Rfg17u4tTO57KNC/7F/NB43dZ7w4=";
  };
in
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "130";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-vwnW/5sKcVR20ys8V8ag66CUBcCjcufnn/ChxDFxd4k=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  strictDeps = true;

  preConfigure = ''
    if [ -n "$doCheck" ]; then
      sed -i '/gtest/d' third_party/CMakeLists.txt
      rmdir test/spec/testsuite
      ln -s ${testsuite} test/spec/testsuite
      substituteInPlace scripts/test/finalize.py \
        --replace-fail "'64' in input_path" "'64' in os.path.basename(input_path)"
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  # bin/binaryen-unittests is absent on cross builds which don't have doCheck,
  # so delete it on non-cross builds too (thus removing gtest from the closure).
  postInstall = ''
    if [ -n "$doCheck" ]; then
      rm "$out/bin/binaryen-unittests"
    fi
  '';

  doCheck = false;

  meta = {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
