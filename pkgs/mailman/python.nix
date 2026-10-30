{
  python3,
  lib,
  overlay ? (_: _: { }),
}:

lib.fix (
  self:
  python3.override {
    inherit self;
    packageOverrides = overlay;
  }
)
