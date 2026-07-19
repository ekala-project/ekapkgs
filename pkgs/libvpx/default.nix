{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  yasm,
}:

let
  inherit (lib) enableFeature;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "libvpx";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = "libvpx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z1Ov3BHnAGuayeY4D86oTRiDfuZ2Wpc4ZD7pXGaakVI=";
  };

  postPatch = ''
    patchShebangs --build \
      build/make/*.sh \
      build/make/*.pl \
      build/make/*.pm \
      configure

    substituteInPlace configure \
      --replace "check_add_cflags -Wparentheses-equality" "" \
      --replace "check_add_cflags -Wunreachable-code-loop-increment" "" \
      --replace "check_cflags -Wshorten-64-to-32 && add_cflags_only -Wshorten-64-to-32" ""
  '';

  outputs = [
    "bin"
    "dev"
    "out"
  ];
  setOutputFlags = false;

  configurePlatforms = [ ];
  configureFlags = [
    "--enable-vp8"
    "--enable-vp8-encoder"
    "--enable-vp8-decoder"
    "--enable-vp9"
    "--enable-vp9-encoder"
    "--enable-vp9-decoder"
    "--disable-install-docs"
    "--enable-install-bins"
    "--enable-install-libs"
    "--disable-install-srcs"
    "--enable-pic"
    "--enable-optimizations"
    "--enable-runtime-cpu-detect"
    "--enable-libs"
    "--enable-examples"
    "--disable-docs"
    "--as=yasm"
    "--size-limit=5120x3200"
    "--disable-codec-srcs"
    "--enable-postproc"
    "--enable-vp9-postproc"
    "--enable-multithread"
    "--enable-spatial-resampling"
    "--enable-shared"
    "--enable-webm-io"
    "--enable-libyuv"
    "--enable-temporal-denoising"
    "--enable-vp9-temporal-denoising"
    "--enable-vp9-highbitdepth"
  ];

  nativeBuildInputs = [
    perl
    yasm
  ];

  env.NIX_LDFLAGS = toString [
    "-lpthread"
  ];

  enableParallelBuilding = true;

  postInstall = ''moveToOutput bin "$bin" '';

  meta = {
    description = "WebM VP8/VP9 codec SDK";
    homepage = "https://www.webmproject.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
