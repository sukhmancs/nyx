# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  plymouth-themes = {
    pname = "plymouth-themes";
    version = "5d8817458d764bff4ff9daae94cf1bbaabf16ede";
    src = fetchFromGitHub {
      owner = "adi1090x";
      repo = "plymouth-themes";
      rev = "5d8817458d764bff4ff9daae94cf1bbaabf16ede";
      fetchSubmodules = false;
      sha256 = "sha256-3Au6EH62MQMuvyDDarz2ahaJe3pnfNzUwyYo80WWKw0=";
    };
    date = "2023-08-22";
  };
}
