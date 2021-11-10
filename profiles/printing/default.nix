{ pkgs
, ...
}:

{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
