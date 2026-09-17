{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qt3d";
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
