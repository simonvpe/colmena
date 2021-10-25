{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "adobe-reader-9.5.5-1"
  ];
}
