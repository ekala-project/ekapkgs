{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  unzip,
  zlib,
  pcre2,
  hdf5,
  boost,
  glib,
  glog,
  gflags,
  protobuf,
  ocl-icd,

  enableJPEG ? true,
  libjpeg,
  enablePNG ? true,
  libpng,
  enableTIFF ? true,
  libtiff,
  enableWebP ? true,
  libwebp,
  enableJpegXL ? true,
  libjxl,
  enableEXR ? !stdenv.hostPlatform.isDarwin,
  openexr,
  enableJPEG2000 ? true,
  openjpeg,
  enableEigen ? true,
  eigen,
  enableBlas ? true,
  blas,
  enableVA ? !stdenv.hostPlatform.isDarwin,
  libva,
  enableContrib ? true,

  enableLto ? true,
  enableUnfree ? false,
  enablePython ? false,
  pythonPackages ? { },
  enableGtk3 ? false,
  gtk3,
  enableFfmpeg ? true,
  ffmpeg_8-headless ? null,
  enableGStreamer ? true,
  elfutils,
  gstreamer,
  orc,
  libunwind,
  zstd,
  enableTesseract ? false,
  tesseract,
  leptonica,
  enableTbb ? false,
  onetbb,
  enableGPhoto2 ? false,
  libgphoto2,
  enableDC1394 ? false,
  libdc1394,

  bzip2,
}:

let
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    cmakeOptionType
    optionalString
    ;

  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv";
    tag = version;
    hash = "sha256-h9gpSf+xf/OafQSCYq3JYBt/ShnxafSG7WbxesTjM/A=";
  };

  contribSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv_contrib";
    tag = version;
    hash = "sha256-8YRCq1H9afb1a0pVevH0x61SMW4dTpLAno/P9A6bOIg=";
  };

  buildContrib = enableContrib || enableTesseract;

  # See opencv/modules/gapi/cmake/DownloadADE.cmake
  ade = rec {
    src = fetchurl {
      url = "https://github.com/opencv/ade/archive/${name}";
      hash = "sha256-O+Yshk3N2Lkl6S9qWxWnoDmBngSms88IiCfwjPLMB78=";
    };
    name = "v0.1.2e.zip";
    md5 = "962ce79e0b95591f226431f7b5f152cd";
    dst = ".cache/ade";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_vgg.cmake
  vgg = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d";
      hash = "sha256-fjdGM+CxV1QX7zmF2AiR9NDknrP2PjyaxtjT21BVLmU=";
    };
    files = {
      "vgg_generated_48.i" = "e8d0dcd54d1bcfdc29203d011a797179";
      "vgg_generated_64.i" = "7126a5d9a8884ebca5aea5d63d677225";
      "vgg_generated_80.i" = "7cd47228edec52b6d82f46511af325c5";
      "vgg_generated_120.i" = "151805e03568c9f490a5e3a872777b75";
    };
    dst = ".cache/xfeatures2d/vgg";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_boostdesc.cmake
  boostdesc = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "34e4206aef44d50e6bbcd0ab06354b52e7466d26";
      sha256 = "13yig1xhvgghvxspxmdidss5lqiikpjr0ddm83jsi0k85j92sn62";
    };
    files = {
      "boostdesc_bgm.i" = "0ea90e7a8f3f7876d450e4149c97c74f";
      "boostdesc_bgm_bi.i" = "232c966b13651bd0e46a1497b0852191";
      "boostdesc_bgm_hd.i" = "324426a24fa56ad9c5b8e3e0b3e5303e";
      "boostdesc_binboost_064.i" = "202e1b3e9fec871b04da31f7f016679f";
      "boostdesc_binboost_128.i" = "98ea99d399965c03d555cef3ea502a0b";
      "boostdesc_binboost_256.i" = "e6dcfa9f647779eb1ce446a8d759b6ea";
      "boostdesc_lbgm.i" = "0ae0675534aa318d9668f2a179c2a052";
    };
    dst = ".cache/xfeatures2d/boostdesc";
  };

  # See opencv_contrib/modules/face/CMakeLists.txt
  face = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "8afa57abc8229d611c4937165d20e2a2d9fc5a12";
      hash = "sha256-m9yF4kfmpRJybohdRwUTmboeU+SbZQ6F6gm32PDWNBg=";
    };
    files = {
      "face_landmark_model.dat" = "7505c44ca4eb54b4ab1e4777cb96ac05";
    };
    dst = ".cache/data";
  };

  # See opencv_contrib/modules/wechat_qrcode/CMakeLists.txt
  wechat_qrcode = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "a8b69ccc738421293254aec5ddb38bd523503252";
      hash = "sha256-/n6zHwf0Rdc4v9o4rmETzow/HTv+81DnHP+nL56XiTY=";
    };
    files = {
      "detect.caffemodel" = "238e2b2d6f3c18d6c3a30de0c31e23cf";
      "detect.prototxt" = "6fb4976b32695f9f5c6305c19f12537d";
      "sr.caffemodel" = "cbfcd60361a73beb8c583eea7e8e6664";
      "sr.prototxt" = "69db99927a70df953b471daaba03fbef";
    };
    dst = ".cache/wechat_qrcode";
  };

  installExtraFiles =
    {
      dst,
      files,
      src,
      ...
    }:
    ''
      mkdir -p "${dst}"
    ''
    + lib.concatStrings (
      lib.flip lib.mapAttrsToList files (
        name: md5: ''
          ln -s "${src}/${name}" "${dst}/${md5}-${name}"
        ''
      )
    );

  installExtraFile =
    {
      dst,
      md5,
      name,
      src,
      ...
    }:
    ''
      mkdir -p "${dst}"
      ln -s "${src}" "${dst}/${md5}-${name}"
    '';

  withOpenblas = (enableBlas && blas.provider.pname == "openblas");
  openblas_ = blas.provider.override { singleThreaded = true; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "opencv";
  inherit version src;

  outputs = [
    "out"
    "cxxdev"
  ];

  postUnpack = optionalString buildContrib ''
    cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/${src.name}/opencv_contrib"
  '';

  patches = [
    ./cmake-don-t-use-OpenCVFindOpenEXR.patch
    ./0001-cmake-OpenCVUtils.cmake-invalidate-Nix-store-paths-b.patch
  ];

  postPatch = ''
    sed -i '/Add these standard paths to the search paths for FIND_LIBRARY/,/^\s*$/{d}' CMakeLists.txt

    substituteInPlace modules/ts/include/opencv2/ts/ts_gtest.h \
      --replace-fail \
        "#if defined(__GNUC__) && (__GNUC__ == 14)" \
        "#if defined(__GNUC__)"
  '';

  preConfigure =
    installExtraFile ade
    + (optionalString buildContrib ''
      cmakeFlagsArray+=("-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/${src.name}/opencv_contrib")

      ${installExtraFiles vgg}
      ${installExtraFiles boostdesc}
      ${installExtraFiles face}
      ${installExtraFiles wechat_qrcode}
    '');

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    unzip
  ]
  ++ lib.optionals enablePython [
    pythonPackages.pip
    pythonPackages.wheel
    pythonPackages.setuptools
  ];

  buildInputs = [
    boost
    gflags
    glib
    glog
    pcre2
    protobuf
    zlib
  ]
  ++ lib.optionals enablePython [
    pythonPackages.python
  ]
  ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
    hdf5
  ]
  ++ lib.optionals enableGtk3 [
    gtk3
  ]
  ++ lib.optionals enableJPEG [
    libjpeg
  ]
  ++ lib.optionals enablePNG [
    libpng
  ]
  ++ lib.optionals enableTIFF [
    libtiff
  ]
  ++ lib.optionals enableWebP [
    libwebp
  ]
  ++ lib.optionals enableJpegXL [
    libjxl
  ]
  ++ lib.optionals enableEXR [
    openexr
  ]
  ++ lib.optionals enableJPEG2000 [
    openjpeg
  ]
  ++ lib.optionals enableFfmpeg [
    ffmpeg_8-headless
  ]
  ++ lib.optionals (enableGStreamer && stdenv.hostPlatform.isLinux) [
    elfutils
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer
    libunwind
    orc
    zstd
  ]
  ++ lib.optionals enableGPhoto2 [
    libgphoto2
  ]
  ++ lib.optionals enableDC1394 [
    libdc1394
  ]
  ++ lib.optionals enableEigen [
    eigen
  ]
  ++ lib.optionals enableVA [
    libva
  ]
  ++ lib.optionals enableBlas [
    blas.provider
  ]
  ++ lib.optionals enableTesseract [
    tesseract
    leptonica
  ]
  ++ lib.optionals enableTbb [
    onetbb
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    bzip2
  ];

  propagatedBuildInputs = lib.optionals enablePython [ pythonPackages.numpy ];

  env = {
    OpenBLAS_HOME = optionalString withOpenblas openblas_.dev;
    OpenBLAS = optionalString withOpenblas openblas_;
  };

  cmakeFlags = [
    (cmakeBool "BUILD_INFO_SKIP_SYSTEM_VERSION" true)
    (cmakeBool "OPENCV_GENERATE_PKGCONFIG" true)
    (cmakeBool "WITH_OPENMP" true)
    (cmakeBool "BUILD_PROTOBUF" false)
    (cmakeFeature "CMAKE_CXX_STANDARD" "17")
    (cmakeBool "WITH_PROTOBUF" true)
    (cmakeBool "PROTOBUF_UPDATE_FILES" true)
    (cmakeBool "OPENCV_ENABLE_NONFREE" enableUnfree)
    (cmakeBool "BUILD_TESTS" false)
    (cmakeBool "BUILD_PERF_TESTS" false)
    (cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (cmakeBool "BUILD_DOCS" false)
    (cmakeBool "OPENCV_ENABLE_PKG_CONFIG" true)
    (cmakeBool "WITH_IPP" false)
    (cmakeBool "WITH_TIFF" enableTIFF)
    (cmakeBool "WITH_WEBP" enableWebP)
    (cmakeBool "WITH_JPEGXL" enableJpegXL)
    (cmakeBool "WITH_JPEG" enableJPEG)
    (cmakeBool "WITH_PNG" enablePNG)
    (cmakeBool "WITH_OPENEXR" enableEXR)
    (cmakeBool "WITH_OPENJPEG" enableJPEG2000)
    (cmakeBool "WITH_JASPER" false)
    (cmakeBool "WITH_TBB" enableTbb)
    (cmakeBool "WITH_CUDA" false)
    (cmakeBool "WITH_CUBLAS" false)
    (cmakeBool "WITH_CUDNN" false)
    (cmakeBool "WITH_CUFFT" false)
    (cmakeBool "ENABLE_LTO" enableLto)
    (cmakeBool "ENABLE_THIN_LTO" (enableLto && stdenv.cc.isClang))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (cmakeBool "WITH_OPENCL" false)
    (cmakeBool "WITH_LAPACK" false)
    (cmakeBool "BUILD_ZLIB" false)
    (cmakeBool "BUILD_TIFF" false)
    (cmakeBool "BUILD_OPENJPEG" false)
    (cmakeBool "BUILD_JASPER" false)
    (cmakeBool "BUILD_JPEG" false)
    (cmakeBool "BUILD_PNG" false)
    (cmakeBool "BUILD_WEBP" false)
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (cmakeOptionType "path" "OPENCL_LIBRARY" "${ocl-icd}/lib/libOpenCL.so")
  ]
  ++ lib.optionals enablePython [
    (cmakeOptionType "path" "OPENCV_PYTHON_INSTALL_PATH" pythonPackages.python.sitePackages)
  ];

  postInstall = ''
    sed -i "s|{exec_prefix}/$out|{exec_prefix}|;s|{prefix}/$out|{prefix}|" \
      "$out/lib/pkgconfig/opencv4.pc"
    mkdir "$cxxdev"
  ''
  + ''
    mkdir -p "$cxxdev/nix-support"
    echo "''${!outputDev}" >> "$cxxdev/nix-support/propagated-build-inputs"
  ''
  + optionalString enablePython ''
    pushd $NIX_BUILD_TOP/$sourceRoot/modules/python/package
    python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .

    pushd dist
    python -m pip install ./*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache

    popd
    popd
  '';

  passthru = {
    cudaSupport = false;
  }
  // lib.optionalAttrs enablePython { pythonPath = [ ]; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = "https://opencv.org/";
    license = if enableUnfree then lib.licenses.unfree else lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
