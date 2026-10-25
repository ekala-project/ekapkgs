{
  v1 = {
    version = "1.5.11";
    src-kind = "fetchurl";
    src-url = "https://www.efficios.com/files/babeltrace/babeltrace-1.5.11.tar.bz2";
    src-hash = "sha256-Z7Q6qu9clR+nrxpVfPcgGhH+iYdrfCK6CgPLwxbbWpw=";
    hasDocs = false;
  };

  v2 = {
    version = "2.1.2";
    src-kind = "fetchFromGitHub";
    src-owner = "efficios";
    src-repo = "babeltrace";
    src-hash = "sha256-4vqeIwCWEAzsHTdM2S2grF7F4vPqiWTeTEZpxsqf2g8=";
    hasDocs = true;
  };
}
