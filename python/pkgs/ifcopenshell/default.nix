{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  fetchpatch,
  # build tools
  cmake,
  swig,
  setuptools,
  build,
  # native dependencies
  eigen,
  boost,
  cgal_5,
  gmp,
  hdf5,
  icu,
  libaec,
  libxml2,
  mpfr,
  nlohmann_json,
  opencascade-occt_7_6,
  zlib,
  # python deps
  isodate,
  lark,
  numpy,
  python-dateutil,
  shapely,
  typing-extensions,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
buildPythonPackage (finalAttrs: {
  pname = "ifcopenshell";
  version = "0.8.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "IfcOpenShell";
    repo = "IfcOpenShell";
    tag = "ifcopenshell-python-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-tnj14lBEkUZNDM9J1sRhNA7OkWTWa5JPTSF8hui3q7k=";
  };

  patches = [
    (fetchpatch {
      name = "ifcopenshell-boost-1.86-mt19937.patch";
      url = "https://github.com/IfcOpenShell/IfcOpenShell/commit/1fe168d331123920eeb9a96e542fcc1453de57fe.patch";
      hash = "sha256-oZDEL8cPcEu83lW+qSvCbmDGYpaNNRrptW9MLu2pN70=";
    })

    (fetchpatch {
      name = "ifcopenshell-boost-1.86-json.patch";
      url = "https://github.com/IfcOpenShell/IfcOpenShell/commit/88b861737c7c206d0e7307f90d37467e9585515c.patch";
      hash = "sha256-zMoQcBWRdtavL0xdsr53SqyG6CZoeon8/mmJhrw85lc=";
    })

    # boost 1.91 made boost::optional's converting constructor explicit
    ./boost-1.91-optional.patch
  ];

  nativeBuildInputs = [
    cmake
    swig
    build
    setuptools
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    boost
    cgal_5
    eigen
    gmp
    hdf5
    icu
    libaec
    libxml2
    mpfr
    nlohmann_json
    opencascade-occt
  ];

  propagatedBuildInputs = [
    isodate
    lark
    numpy
    python-dateutil
    shapely
    typing-extensions
  ];

  pythonImportsCheck = [ "ifcopenshell" ];

  env.PYTHONUSERBASE = ".";

  cmakeFlags = [
    "-DUSERSPACE_PYTHON_PREFIX=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_IFCPYTHON=ON"
    "-DCITYJSON_SUPPORT=OFF"
    "-DCOLLADA_SUPPORT=OFF"
    "-DEIGEN_DIR=${eigen}/include/eigen3"
    "-DJSON_INCLUDE_DIR=${nlohmann_json}/include/"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
    "-DOCC_LIBRARY_DIR=${lib.getLib opencascade-occt}/lib"
    "-DSWIG_EXECUTABLE=${swig}/bin/swig"
    "-DLIBXML2_INCLUDE_DIR=${libxml2.dev}/include/libxml2"
    "-DLIBXML2_LIBRARIES=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DGMP_LIBRARY_DIR=${lib.getLib gmp}/lib/"
    "-DMPFR_LIBRARY_DIR=${lib.getLib mpfr}/lib/"
    "-DHDF5_SUPPORT=ON"
    "-DHDF5_INCLUDE_DIR=${hdf5.dev}/include/"
    "-DHDF5_LIBRARIES=${lib.getLib hdf5}/lib/libhdf5_cpp.so;${lib.getLib hdf5}/lib/libhdf5.so;${lib.getLib zlib}/lib/libz.so;${lib.getLib libaec}/lib/libaec.so;"
  ];

  postPatch = ''
    pushd src/ifcopenshell-python
    substituteInPlace pyproject.toml --replace-fail "0.0.0" "${finalAttrs.version}"
    cp ../../README.md README.md
    popd

    # boost189 compatibility
    substituteInPlace cmake/CMakeLists.txt \
      --replace-fail 'set(BOOST_COMPONENTS system' 'set(BOOST_COMPONENTS'
  '';

  preConfigure = ''
    cd cmake
  '';

  # Skip tests - they require mathutils and other deps not available
  doCheck = false;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Open source IFC library and geometry engine";
    homepage = "https://ifcopenshell.org/";
    license = lib.licenses.lgpl3;
  };
})
