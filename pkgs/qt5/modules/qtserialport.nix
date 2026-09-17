{
  qtModule,
  lib,
  qtbase,
  systemd,
}:

qtModule {
  pname = "qtserialport";
  propagatedBuildInputs = [ qtbase ];
  env.NIX_CFLAGS_COMPILE = "-DNIXPKGS_LIBUDEV=\"${lib.getLib systemd}/lib/libudev\"";
}
