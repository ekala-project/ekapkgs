{
  qtModule,
  speechd,
  pkg-config,
}:

qtModule {
  pname = "qtspeech";
  buildInputs = [ speechd ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [
    "out"
    "dev"
  ];
}
