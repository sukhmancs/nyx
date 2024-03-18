{
  # the name here is arbitrary, and is used as an identifier
  # what matters is the presence of owner, module and rev
  "nix-gc" = {
    # https://github.com/NixOS/nixpkgs/pull/260620
    owner = "nobbz";
    module = "/services/misc/nix-gc.nix";
    rev = "10ec045f1dc82c72630c85906e1ae1d54340a7e0";
  };
}
