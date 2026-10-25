{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "check-phase-thread-limit-hook";

  meta = {
    license = lib.licenses.mit;
  };
} ./hook.sh
