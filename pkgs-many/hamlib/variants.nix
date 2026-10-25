{
  v3 = {
    version = "3.3";
    src-kind = "fetchurl";
    src-url = "mirror://sourceforge/hamlib/hamlib-3.3.tar.gz";
    src-hash = "10788mgrhbc57zpzakcxv5aqnr2819pcshml6fbh8zvnkja562y9";
    needsAutoreconf = false;
  };

  v4 = {
    version = "4.7.2";
    src-kind = "fetchFromGitHub";
    src-owner = "Hamlib";
    src-repo = "Hamlib";
    src-hash = "sha256-t1GgCYH+AJE5UZKQu+9uqx7fJDv4zuT0OzWxicZFfdQ=";
    needsAutoreconf = true;
  };
}
