{
  inputs,
  pkgs,
  ...
}: {
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

      cmp = {
        autoEnableSources = true;
        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
      };

      coq-nvim = {
        enable = true;
        installArtifacts = true;
        settings = {
          auto_start = "shut-up";
        };
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

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      tabstop = 2;
      #      clipboard.register = "unnamedplus";
    };

    globals = {
      mapleader = " ";
      localmapleader = " ";
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

    extraConfigLua = ''
      -- configure theme
      require('solarized').set()

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

      require("lspconfig").nixd.setup({
        cmd = { "nixd" },
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> {} ",
            },
            formatting = {
              command = { "alejandra" },
            },

          },
        },
      })



    '';
  };
}
