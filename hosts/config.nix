# common-config.nix
{
  system,
  hostName,
  roles,
  inputs,
  self,
  inputs',
  self',
  homes,
  agenix,
}: {
  inherit system;
  modules =
    [
      {networking.hostName = hostName;}
      ../modules/core # core modules
    ]
    ++ roles
    ++ # This will be a list of role modules
    [
      ../modules/options
      agenix # age encryption for secrets
    ]
    ++ homes;
  specialArgs = {
    inherit (self) keys;
    inherit lib modulesPath;
    inherit inputs self inputs' self';
  };
}
