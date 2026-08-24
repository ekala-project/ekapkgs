{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rabbitmq-c";
  version = "0.17.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ywTNvVO1M8mwyjgJBlo7iEeCDLISTMWk7PM6AUuiIjc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "RabbitMQ C AMQP client library";
    homepage = "https://github.com/alanxz/rabbitmq-c";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
