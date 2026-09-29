{
  qtModule,
  qtbase,
  qtdeclarative,
  bluez,
}:

qtModule {
  pname = "qtconnectivity";
  buildInputs = [ bluez ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
