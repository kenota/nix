
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

      parinfer-rust = {
	enable = true;
      };
      
      conjure = {
        enable = true;
      };
      treesitter.enable = true;
      telescope.enable = true;
      rainbow-delimiters.enable = true;

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
      expandtab = true;
      tabstop = 2;
      clipboard = "unnamedplus";

    };

    luaLoader.enable = true;

#    maps = {
#      normal = {
#	"<leader>ff" = {
#	  action = "vim.lsp.buf.format";
#	  desc = "Format buffer";
#};
#	"<leader>ca" = {
#	  action = "vim.lsp.buf.code_action";
#	  desc = "Code actions";
#	};
#      };
#    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraConfigLua = ''
    -- configure theme
    require('solarized').set()
    
    vim.o.mapleader = ' '
    vim.o.maplocalleader = ' '


    '';

  };


}
