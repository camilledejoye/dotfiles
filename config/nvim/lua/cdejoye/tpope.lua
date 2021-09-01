local map = vim.api.nvim_set_keymap

require('packer').use {
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'tpope/vim-scriptease',
  'tpope/vim-unimpaired',
  -- 'tpope/vim-endwise',
  -- 'tpope/vim-speeddating',
  'tpope/vim-abolish',
  -- Lua alternative to check: https://github.com/TimUntersberger/neogit
  'tpope/vim-fugitive',
  'tpope/vim-repeat',
  'tpope/vim-dispatch',
  'radenling/vim-dispatch-neovim',
  'tpope/vim-projectionist',
  'tpope/vim-eunuch',
  'tpope/vim-sleuth',
}

map('n', '<Leader>gb', ':Git blame<CR>', { noremap = true, silent = true })
map('n', '<Leader>gs', ':Gtabedit :<CR>', { noremap = true, silent = true })

-- Unimpaired {{{
-- Disable some mappings because I don't use them and they conflict with others
vim.g.nremap = {
  ['=p'] = '<skip>',
  ['=P'] = '<skip>',
  ['[u'] = '<skip>',
  [']u'] = '<skip>',
  ['[uu'] = '<skip>',
  [']uu'] = '<skip>',
}

-- =o and =op mappings could not be removed this way so I had to deal with them
-- in ../after/plugin/conflicting-mappings.vim
-- }}}

-- Projectionist {{{

-- Heuristics {{{

vim.g.projectionist_heuristics = {
    ['composer.json&src/&tests/'] = {
        ['src/*.php'] = {
            ['type'] = 'src',
            ['skeleton'] = 'class',
            ['alternate'] = {
              'tests/Unit/{}Test.php',
              'tests/Integration/{}Test.php',
              'tests/Functional/{}Test.php',
              'tests/{}Test.php',
            }
        },
        ['tests/Unit/*Test.php'] = {
            ['type'] = 'unittest',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'src/{}.php',
        },
        ['tests/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'src/{}.php',
        },
        ['lib/**/src/*.php'] = {
            ['type'] = 'src',
            ['skeleton'] = 'class',
            ['alternate'] = 'lib/{dirname|basename}/tests/{basename}Test.php',
        },
        ['lib/**/tests/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'lib/{dirname|basename}/src/{basename}.php',
        },
        ['src/**/Command/*Command.php'] = {
            ['type'] = 'command',
            ['skeleton'] = 'sfcommand',
            ['alternate'] = {
                'src/{dirname}/Handler/{basename}Handler.php',
                'src/{dirname}/Command/{basename}CommandHandler.php',
            },
        },
        ['src/**/Handler/*Handler.php'] = {
            ['type'] = 'handler',
            ['skeleton'] = 'class',
            ['alternate'] = 'src/{dirname|basename}/Command/{basename}Command.php',
        },
    },
    ['src/Kernel.php&public/index.php'] = {
        ['config/*'] = {
            ['type'] = 'config',
        },
        ['src/Command/*Command.php'] = {
            ['type'] = 'command',
            ['skeleton'] = 'sfcommand',
        },
        ['src/Controller/*Controller.php'] = {
            ['type'] = 'controller',
            ['skeleton'] = 'sfcontroller',
        },
        ['src/DataFixtures/*Fixtures.php'] = {
            ['type'] = 'fixture',
            ['skeleton'] = 'sffixture',
            ['alternate'] = 'src/Entity/{}.php',
        },
        ['src/Entity/*.php'] = {
            ['type'] = 'entity',
            ['skeleton'] = 'sfentity',
            ['alternate'] = {
                'src/Repository/{}Repository.php',
                'src/Controller/{}Controller.php',
                'src/Form/{}Type.php',
            },
        },
        ['src/Repository/*Repository.php'] = {
            ['type'] = 'repository',
            ['alternate'] = 'src/Entity/{}.php',
            ['skeleton'] = 'sfrepository',
        },
        ['src/Event/*Event.php'] = {
            ['type'] = 'event',
            ['skeleton'] = 'sfevent',
        },
        ['src/EventSubscriber/*Subscriber.php'] = {
            ['type'] = 'subscriber',
            ['skeleton'] = 'sfsubscriber',
        },
        ['src/Exception/*Exception.php'] = {
            ['type'] = 'exception',
        },
        ['src/Form/*Type.php'] = {
            ['type'] = 'form',
            ['alternate'] = 'src/Entity/{}.php',
            ['skeleton'] = 'sfform',
        },
        ['src/Form/Type/*Type.php'] = {
            ['type'] = 'form',
            ['alternate'] = 'src/Entity/{}.php',
            ['skeleton'] = 'sfform',
        },
        ['templates/*.html.twig'] = {
            ['type'] = 'template',
            ['skeleton'] = 'sftemplate',
        },
        ['config/services.yaml|config/services.yml'] = {
            ['type'] = 'services',
        },
        ['templates/*.css|templates/*.scss'] = {
            ['type'] = 'css',
        },
        ['templates/*.js'] = {
            ['type'] = 'js',
        },
        ['var/log/*.log'] = {
            ['type'] = 'log',
        },
    },
    ['app/config/config.yml&src/'] = {
        ['app/config/*|src/**/Ressources/config/*'] = {
            ['type'] = 'config',
        },
        ['src/**/Command/*Command.php'] = {
            ['type'] = 'command',
            ['skeleton'] = 'sfcommand',
        },
        ['src/**/Controller/*Controller.php'] = {
            ['type'] = 'controller',
            ['skeleton'] = 'sfcontroller',
        },
        ['src/**/DataFixtures/*Fixtures.php'] = {
            ['type'] = 'fixture',
            ['skeleton'] = 'sffixture',
            ['alternate'] = 'src/{dirname|basename}/Entity/{basename}.php',
        },
        ['src/**/Entity/*.php'] = {
            ['type'] = 'entity',
            ['skeleton'] = 'sfentity',
            ['alternate'] = {
                'src/{dirname|basename}/Repository/{basename}Repository.php',
                'src/{dirname|basename}/Controller/{basename}Controller.php',
                'src/{dirname|basename}/Form/{basename}Type.php',
            },
        },
        ['src/**/Repository/*Repository.php'] = {
            ['type'] = 'repository',
            ['alternate'] = 'src/{dirname|basename}/Entity/{basename}.php',
            ['skeleton'] = 'sfrepository',
        },
        ['src/**/Event/*Event.php'] = {
            ['type'] = 'event',
            ['skeleton'] = 'sfevent',
        },
        ['src/**/EventSubscriber/*Subscriber.php'] = {
            ['type'] = 'subscriber',
            ['skeleton'] = 'sfsubscriber',
        },
        ['src/**/Exception/*Exception.php'] = {
            ['type'] = 'exception',
        },
        ['src/**/Form/*Type.php'] = {
            ['type'] = 'form',
            ['alternate'] = 'src/{dirname|basename}/Entity/{basename}.php',
            ['skeleton'] = 'sfform',
        },
        ['src/*.html.twig'] = {
            ['type'] = 'template',
            ['skeleton'] = 'sftemplate',
        },
        ['config/services.yml'] = {
            ['type'] = 'services',
        },
        ['src/*.css|src/*.scss'] = {
            ['type'] = 'css',
        },
        ['src/*.js'] = {
            ['type'] = 'js',
        },
        ['var/log/*.log'] = {
            ['type'] = 'log',
        },
    },
}

-- }}}

map('n', '<Leader>a', ':A<CR>', { noremap = true, silent = true })
map('n', '<Leader>va', ':AV<CR>', { noremap = true, silent = true })

-- }}}

-- vim: ts=2 sw=2 et fdm=marker
