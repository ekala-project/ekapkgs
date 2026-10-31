{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  zlib,
  copyPkgconfigItems,
  makePkgconfigItem,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kaitai-struct-cpp-stl-runtime";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "kaitai-io";
    repo = "kaitai_struct_cpp_stl_runtime";
    tag = finalAttrs.version;
    hash = "sha256-2glGPf08bkzvnkLpQIaG2qiy/yO+bZ14hjIaCKou2vU=";
  };

  doCheck = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    copyPkgconfigItems
    ctestCheckHook
  ];

  buildInputs = [
    zlib
    gtest
  ];

  strictDeps = true;

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "kaitai-struct-cpp-stl-runtime";
      inherit (finalAttrs) version;
      cflags = [ "-I${variables.includedir}" ];
      libs = [
        "-L${variables.libdir}"
        "-lkaitai_struct_cpp_stl_runtime"
      ];
      variables = {
        includedir = "${placeholder "dev"}/include";
        libdir = "${placeholder "out"}/lib";
      };
      inherit (finalAttrs.meta) description;
    })
  ];

  meta = {
    description = "Kaitai Struct C++ STL Runtime Library";
    homepage = "https://github.com/kaitai-io/kaitai_struct_cpp_stl_runtime";
    license = lib.licenses.mit;
  };
})
