{ pkgs
, ...
}:
{
  config = {
    #services.tcsd.enable = true;
    environment.systemPackages = with pkgs; [ tpm2-tss tpm2-abrmd ];
    security.tpm2 = {
      enable = true;
      tssUser = "tss";
      tssGroup = "tss";
      applyUdevRules = true;
      abrmd = {
        enable = true;
      };
      pkcs11 = {
        enable = true;
      };
    };
    users.users.tss = {
      group = "tss";
    };
    users.groups.tss = { };
  };
}
