{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  cython,
  setuptools,
  hidapi,
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
    hidapi
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
