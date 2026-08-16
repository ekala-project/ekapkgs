{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsodium,
  enableDrafts ? false,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zeromq";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q2h5y0Asad+fGB9haO4Vg7a1ffO2JSb7czzlhmT3VmI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/zeromq/libzmq/pull/4711/commits/55bd6b3df06734730d3012c17bc26681e25b549d.patch";
      hash = "sha256-/FVah+s7f1hWXv3MXkYfIiV1XAiMVDa0tmt4BQmSgmY=";
      name = "cacheline_undefined.patch";
    })
    (fetchpatch {
      name = "zeromq-fix-cmake-4-1.patch";
      url = "https://github.com/zeromq/libzmq/commit/34f7fa22022bed9e0e390ed3580a1c83ac4a2834.patch";
      hash = "sha256-oauAZV6pThplcn2v9mQxhxlUhYgpbly0JBLYik+zoJE=";
    })
    (fetchpatch {
      name = "zeromq-fix-cmake-4-2.patch";
      url = "https://github.com/zeromq/libzmq/commit/b91a6201307b72beb522300366aad763d19b1456.patch";
      hash = "sha256-FKvZi7pTUx+wLUR8Suf+pRFg8I5OHpJ93gEmTxUrmO4=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [ libsodium ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_CURVE" true)
    (lib.cmakeBool "ENABLE_DRAFTS" enableDrafts)
    (lib.cmakeBool "WITH_LIBSODIUM" true)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  # Man pages skipped: requires asciidoc + xmlto which have circular dep issues

  meta = {
    homepage = "http://www.zeromq.org";
    description = "Intelligent Transport Layer";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
