{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  opencl-headers,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocl-icd";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7q5+33oWMA/PQOz6awC+LOBVTKeXNluHxDNAq8bJPYU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    ruby
  ];

  buildInputs = [ opencl-headers ];

  configureFlags = [
    "--enable-custom-vendordir=/run/opengl-driver/etc/OpenCL/vendors"
  ];

  meta = {
    description = "OpenCL ICD Loader";
    mainProgram = "cllayerinfo";
    homepage = "https://github.com/OCL-dev/ocl-icd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
