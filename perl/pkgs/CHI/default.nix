{
  buildPerlPackage,
  fetchurl,
  TestClass,
  TestDeep,
  TestException,
  TestWarn,
  TimeDate,
  CarpAssert,
  ClassLoad,
  DataUUID,
  DigestJHash,
  HashMoreUtils,
  JSONMaybeXS,
  ListMoreUtils,
  LogAny,
  Moo,
  MooXTypesMooseLikeNumeric,
  StringRewritePrefix,
  TaskWeaken,
  TimeDuration,
  TimeDurationParse,
}:
buildPerlPackage {
  pname = "CHI";
  version = "0.61";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AS/ASB/CHI-0.61.tar.gz";
    hash = "sha256-WDVFyeUxK7QZOrFt6fVf+PS0p97RKM7o3SywIdRni1s=";
  };

  buildInputs = [
    TestClass
    TestDeep
    TestException
    TestWarn
    TimeDate
  ];

  propagatedBuildInputs = [
    CarpAssert
    ClassLoad
    DataUUID
    DigestJHash
    HashMoreUtils
    JSONMaybeXS
    ListMoreUtils
    LogAny
    Moo
    MooXTypesMooseLikeNumeric
    StringRewritePrefix
    TaskWeaken
    TimeDuration
    TimeDurationParse
  ];

  meta = {
    description = "Unified cache handling interface";
  };
}
