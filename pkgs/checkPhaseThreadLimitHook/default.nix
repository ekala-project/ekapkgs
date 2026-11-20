{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "check-phase-thread-limit-hook";

  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
} ./hook.sh
