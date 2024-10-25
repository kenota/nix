{ system = "x86_64-darwin";
  username = "kenota";
  hostname = "marcus";

  configuration = { pkgs, hostConfig, ...}: {
    users.users.kenota = {
      name = "kenota";
      home = "/Users/kenota";
    };
  };
}
