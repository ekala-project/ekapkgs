{
  lib,
  perlPackages,
}:
perlPackages.ack.overrideAttrs (old: {
  meta = old.meta // {
    mainProgram = "ack";
  };
})
