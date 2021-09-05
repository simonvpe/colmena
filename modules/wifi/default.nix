{ device }:
{
    networking.interfaces.${device}.useDHCP = true;
    networking.wireless.interfaces = [ device ];
    networking.wireless.enable = true;
    networking.wireless.networks = {
      #Cyberlink50.psk = "allyourbasearebelongstous";
      Cyberlink24.psk = "allyourbasearebelongstous";
      Strandhyddan.psk = "8972524000";
      RCO.psk = "logonrcowlan";
      Finkontoret.psk = "strosaitrosa";
      OWNIT-5GHz_BE20.psk = "Q72CRXMKP7BXYL"; # Elins
      SW.psk = "#saltyaf";
      OnePlus3.psk = "pappapappa";
      #"513F8F".psk = "c9mior2jcy";
      Bolema.psk = "Split053";
    };
}
