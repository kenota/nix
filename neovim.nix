{inputs,  ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    plugins = {
      bufferline.enable = true;
      lualine.enable = true;

      lsp = {
        enable = true;

        servers = {
          pyright.enable = true;
	  nixd.enable = true;
        };
      };
      
      cmp = {
	autoEnableSources = true;
	settings.sources = [
	  { name = "nvim_lsp"; }
	  { name = "path"; }
	  { name = "buffer"; }
	];
      };
    };

    colorschemes.gruvbox = {
      enable = true;
    };
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

  };


}
