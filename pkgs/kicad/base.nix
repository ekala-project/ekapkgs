{
  lib,
  stdenv,
  cmake,
  libGLU,
  libGL,
  zlib,
  wxGTK,
  gtk3,
  libx11,
  gettext,
  glew,
  glm,
  cairo,
  curl,
  openssl,
  boost,
  pkg-config,
  doxygen,
  graphviz,
  libpthread-stubs,
  libxdmcp,
  unixodbc,
  libgit2,
  libsecret,
  libgcrypt,
  libgpg-error,
  ninja,
  writableTmpDirAsHomeHook,
  util-linuxMinimal,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  dbus,
  at-spi2-core,
  libxtst,
  pcre2,
  libdeflate,
  swig,
  python,
  poppler,
  opencascade-occt,
  expat,
  protobuf,
  nng,
  libspnav,
  libngspice,
  kicadSrc,
  kicadVersion,
  withScripting ? false,
  withI18n ? true,
}:
let
  inherit (lib)
    cmakeBool
    cmakeFeature
    optionals
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kicad-base";
  version = kicadVersion;

  src = kicadSrc;

  patches = [
    ./writable.patch
    ./runtime_stock_data_path.patch
  ];

  cmakeFlags = [
    (cmakeBool "KICAD_USE_EGL" true)
    (cmakeFeature "OCC_INCLUDE_DIR" "${opencascade-occt}/include/opencascade")
    (cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;qa_spice")
    (cmakeBool "KICAD_USE_CMAKE_FINDPROTOBUF" false)
    (cmakeBool "KICAD_SCRIPTING_WXPYTHON" withScripting)
    (cmakeBool "KICAD_BUILD_I18N" withI18n)
    (cmakeBool "KICAD_BUILD_QA_TESTS" false)
    (cmakeBool "KICAD_STDLIB_DEBUG" false)
    (cmakeBool "KICAD_USE_VALGRIND" false)
    (cmakeBool "KICAD_SANITIZE_ADDRESS" false)
    (cmakeBool "KICAD_SANITIZE_THREADS" false)
    (cmakeBool "KICAD_SPICE" false)
    "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK}/bin/wx-config"
    "-DwxWidgets_ROOT_DIR=${wxGTK}"
    "-DwxWidgets_LIB_DIR=${wxGTK}/lib"
    "-DCMAKE_PREFIX_PATH=${wxGTK}"
    "-DCMAKE_LIBRARY_PATH=${wxGTK}/lib"
    "-DwxWidgets_INCLUDE_DIRS=${wxGTK}/lib/wx/include/gtk3-unicode-3.2;${wxGTK}/include/wx-3.2"
    "-DwxWidgets_LIBRARIES=-L${wxGTK}/lib;-pthread;-lwx_gtk3u_xrc-3.2;-lwx_gtk3u_html-3.2;-lwx_gtk3u_qa-3.2;-lwx_gtk3u_core-3.2;-lwx_baseu_xml-3.2;-lwx_baseu_net-3.2;-lwx_baseu-3.2"
    "-DwxWidgets_LIBRARY_DIRS=${wxGTK}/lib"
    "-DwxWidgets_CXX_FLAGS=-I${wxGTK}/lib/wx/include/gtk3-unicode-3.2 -I${wxGTK}/include/wx-3.2 -D_FILE_OFFSET_BITS=64 -DWXUSINGDLL -D__WXGTK__ -pthread"
    # Fix broken @build_protobuf@ placeholder from corepkgs protobuf setup hook
    "-DPROTOC_EXE=${protobuf}/bin/protoc"
    "-DProtobuf_PROTOC_EXE=${protobuf}/bin/protoc"
    "-DProtobuf_PROTOC_EXECUTABLE=${protobuf}/bin/protoc"
  ];

  cmakeBuildType = "Release";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    doxygen
    graphviz
    pkg-config
    util-linuxMinimal
    libselinux
    libsepol
    libthai
    libdatrie
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libxtst
    pcre2
    swig
    python
    wxGTK
  ];

  buildInputs = [
    libGLU
    libGL
    zlib
    libx11
    wxGTK
    gtk3
    libxdmcp
    gettext
    glew
    glm
    libpthread-stubs
    cairo
    curl
    openssl
    boost
    python
    poppler
    unixodbc
    libdeflate
    opencascade-occt
    expat
    protobuf
    (nng.override { mbedtlsSupport = false; })
    libspnav
    libgit2
    libsecret
    libgcrypt
    libgpg-error
    libngspice
  ];

  # Patch FindwxWidgets.cmake:
  # 1. Remove ONLY_CMAKE_FIND_ROOT_PATH that prevents finding wx-config in nix store
  # 2. Execute wx-config directly instead of via sh
  # Override the broken protobuf setup hook that adds @build_protobuf@ placeholders
  preConfigure = ''
    ProtobufCMakeFlags() {
      cmakeFlagsArray+=(
        -DPROTOC_EXE="${protobuf}/bin/protoc"
        -DProtobuf_PROTOC_EXE="${protobuf}/bin/protoc"
        -DProtobuf_PROTOC_EXECUTABLE="${protobuf}/bin/protoc"
      )
    }
  '';

  postPatch =
    let
      wxPrefix = wxGTK;
    in
    ''
          # Replace FindwxWidgets.cmake with a simple version that hardcodes the paths
          cat > cmake/FindwxWidgets.cmake << 'EOF'
      set(wxWidgets_FOUND TRUE)
      set(wxWidgets_VERSION_STRING "3.2.7")
      set(wxWidgets_VERSION_MAJOR "3")
      set(wxWidgets_VERSION_MINOR "2")
      set(wxWidgets_VERSION_PATCH "7")
      set(wxWidgets_INCLUDE_DIRS "@wxPrefix@/lib/wx/include/gtk3-unicode-3.2" "@wxPrefix@/include/wx-3.2")
      set(wxWidgets_LIBRARIES "-L@wxPrefix@/lib" "-pthread" "-lwx_gtk3u_xrc-3.2" "-lwx_gtk3u_html-3.2" "-lwx_gtk3u_qa-3.2" "-lwx_gtk3u_core-3.2" "-lwx_baseu_xml-3.2" "-lwx_baseu_net-3.2" "-lwx_baseu-3.2")
      set(wxWidgets_LIBRARY_DIRS "@wxPrefix@/lib")
      set(wxWidgets_CXX_FLAGS "-I@wxPrefix@/lib/wx/include/gtk3-unicode-3.2 -I@wxPrefix@/include/wx-3.2 -D_FILE_OFFSET_BITS=64 -DWXUSINGDLL -D__WXGTK__ -pthread")
      set(wxWidgets_USE_FILE UsewxWidgets)
      set(_wx_selected_config "gtk3-unicode-3.2")
      include(FindPackageHandleStandardArgs)
      find_package_handle_standard_args(wxWidgets
        REQUIRED_VARS wxWidgets_LIBRARIES wxWidgets_INCLUDE_DIRS
        VERSION_VAR wxWidgets_VERSION_STRING)
      EOF
          substituteInPlace cmake/FindwxWidgets.cmake \
            --replace-fail '@wxPrefix@' '${wxPrefix}'

          # Fix version check to use quotes around variable
          sed -i 's|''${wxWidgets_VERSION_STRING} VERSION_LESS|"''${wxWidgets_VERSION_STRING}" VERSION_LESS|g' CMakeLists.txt

          # Remove webview component requirement (ekapkgs wxwidgets doesn't have webview)
          sed -i 's| webview||g' CMakeLists.txt
    '';

  strictDeps = false;
  doInstallCheck = false;

  meta = {
    description = "Just the built source without the libraries";
    homepage = "https://www.kicad.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
