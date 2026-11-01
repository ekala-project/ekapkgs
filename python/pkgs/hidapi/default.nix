{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pkgs,
  pkg-config,
  cython,
  setuptools,
  libusb1,
  udev,
}:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7LwmXL6Le4h1X0IeC6JfCECR7FUMK5D/no3dT81UAxE=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkgs.hidapi
    libusb1
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    HIDAPI_SYSTEM_HIDAPI = true;
  };

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  pythonImportsCheck = [ "hid" ];

  meta = {
    description = "Cython interface to the hidapi from https://github.com/libusb/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    license = with lib.licenses; [
      bsd3
      gpl3Only
    ];
  };
}
