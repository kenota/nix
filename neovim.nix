
{inputs, pkgs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    plugins = {
      bufferline.enable = true;
      lualine = {
	enable = true;
	theme = "solarized_light";
      };

      lsp = {
        enable = true;

        servers = {
          pyright.enable = true;
	  nixd.enable = true;
	  clojure_lsp.enable = true;
        };
      };
      
#      cmp = {
#	autoEnableSources = true;
#	settings.sources = [
#	  { name = "nvim_lsp"; }
#	  { name = "path"; }
#	  { name = "buffer"; }
#	];
#     };
      coq-nvim = {
	enable = true;
	installArtifacts = true;

	autoStart = "shut-up";
      };

      comment.enable = true;
    };
    
    extraPlugins = with pkgs.vimPlugins; [
      solarized-nvim
    ];

    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    luaLoader.enable = true;

    extraConfigLua = ''
    -- configure theme
    require('solarized').set()
    
    vim.o.mapleader = ' '
    vim.o.maplocalleader = ' '
    '';

  };


}
