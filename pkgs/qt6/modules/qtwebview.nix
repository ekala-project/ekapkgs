{
  qtModule,
  qtdeclarative,
  qtwebengine,
}:

qtModule {
  pname = "qtwebview";
  propagatedBuildInputs = [
    qtdeclarative
    qtwebengine
  ];
}
