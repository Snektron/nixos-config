{
  networking = {
    nameservers = [ "1.1.1.1" ];

    extraHosts = ''
      0.0.0.0 redshell.io
      0.0.0.0 api.redshell.io
      0.0.0.0 treasuredata.com
      0.0.0.0 api.treasuredata.com
      0.0.0.0 in.treasuredata.com
      0.0.0.0 cdn.rdshll.com
      0.0.0.0 t.redshell.io
      0.0.0.0 innervate.us
    '';
  };

  services.resolved = {
    enable = true;
    domains = [ "~." ];
  };
}
