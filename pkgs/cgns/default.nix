{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  gfortran,
  tk ? null,
  hdf5,
  libxmu ? null,
  libGLU ? null,
  withTools ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cgns";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "cgns";
    repo = "cgns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0cZtq8nVAHAubHD6IDofnh8N7xiNHQkbhXR5OpdhPQU=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/CGNS/CGNS/commit/0ea14abf6da44f13ca8a01117ad7af8eb405394c.patch?full_index=1";
      hash = "sha256-dtwTD8YqRm0NCXTDPRHmaPLTU17ZLzOyVii1aoGYge0=";
    })
  ];

  postPatch = ''
    substituteInPlace src/cgnstools/tkogl/tkogl.c \
      --replace-fail "<tk-private/generic/tkInt.h>" "<tkInt.h>"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gfortran
  ];

  buildInputs = [
    hdf5
  ]
  ++ lib.optionals withTools (
    lib.optionals (tk != null) [ tk ]
    ++ lib.optionals (libxmu != null) [ libxmu ]
    ++ lib.optionals (libGLU != null) [ libGLU ]
  );

  cmakeFlags = [
    (lib.cmakeBool "CGNS_ENABLE_FORTRAN" true)
    (lib.cmakeBool "CGNS_ENABLE_LEGACY" true)
    (lib.cmakeBool "CGNS_ENABLE_HDF5" true)
    (lib.cmakeBool "HDF5_NEED_MPI" (hdf5.mpiSupport or false))
    (lib.cmakeBool "CGNS_BUILD_CGNSTOOLS" withTools)
    (lib.cmakeBool "CGNS_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CGNS_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = true;

  enableParallelChecking = false;

  postFixup = ''
    rm -f $out/bin/*.desktop
  '';

  meta = {
    description = "CFD General Notation System standard library";
    homepage = "https://cgns.github.io";
    downloadPage = "https://github.com/cgns/cgns";
    changelog = "https://github.com/cgns/cgns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
