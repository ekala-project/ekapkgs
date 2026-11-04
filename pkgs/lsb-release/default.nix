{
  replaceVarsWith,
  lib,
  runtimeShell,
  coreutils,
  getopt,
}:

replaceVarsWith {
  pname = "lsb_release";
  version = lib.trivial.release or "25.05";

  name = "lsb_release";

  src = ./lsb_release.sh;

  dir = "bin";

  isExecutable = true;

  replacements = {
    inherit coreutils getopt runtimeShell;
  };

  meta = {
    description = "Prints certain LSB (Linux Standard Base) and Distribution information";
    mainProgram = "lsb_release";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
