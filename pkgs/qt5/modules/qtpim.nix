{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtpim";

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  qmakeFlags = [
    "CONFIG+=git_build"
  ];
}
