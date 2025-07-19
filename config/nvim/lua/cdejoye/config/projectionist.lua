local map = require('cdejoye.utils').map

map('<Leader>aa', ':A<CR>')
map('<Leader>va', function()
  require('cdejoye.telescope.projectionist').open_alternates()
end)
map('<Leader>vA', function()
  require('cdejoye.telescope.projectionist').open_alternates({ only_existing = false })
end)

-- Specific for Worldia
local worldia = {
    ['src/Common/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Common/{}.php' },
    },
    ['src/Core/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Core/{}.php' },
    },
    ['src/Resource/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Resource/{}.php' },
    },
    ['src/Services/Cars/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Cars/{}.php' },
    },
    ['src/Services/Common/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Common/{}.php' },
    },
    ['src/Services/Flights/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Flights/{}.php' },
    },
    ['src/Services/Points/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Points/{}.php' },
    },
    ['src/Services/Rooms/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Rooms/{}.php' },
    },
    ['src/Services/Routes/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Routes/{}.php' },
    },
    ['src/Services/Tours/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Tours/{}.php' },
    },
    ['src/Services/Transfers/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Transfers/{}.php' },
    },
    ['src/Services/Boats/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Boats/{}.php' },
    },
    ['src/Services/Trains/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Services/Trains/{}.php' },
    },
    ['src/Tasks/spec/*Spec.php'] = {
        ['alternate'] = { 'src/Tasks/{}.php' },
    },
    ['src/WebApp/spec/*Spec.php'] = {
        ['alternate'] = { 'src/WebApp/{}.php' },
    },

    ['src/Common/*.php'] = {
        ['alternate'] = { 'src/Common/spec/{}Spec.php' },
    },
    ['src/Core/*.php'] = {
        ['alternate'] = { 'src/Core/spec/{}Spec.php' },
    },
    ['src/Resource/*.php'] = {
        ['alternate'] = { 'src/Resource/spec/{}Spec.php' },
    },
    ['src/Services/Cars/*.php'] = {
        ['alternate'] = { 'src/Services/Cars/spec/{}Spec.php' },
    },
    ['src/Services/Common/*.php'] = {
        ['alternate'] = { 'src/Services/Common/spec/{}Spec.php' },
    },
    ['src/Services/Flights/*.php'] = {
        ['alternate'] = { 'src/Services/Flights/spec/{}Spec.php' },
    },
    ['src/Services/Points/*.php'] = {
        ['alternate'] = { 'src/Services/Points/spec/{}Spec.php' },
    },
    ['src/Services/Rooms/*.php'] = {
        ['alternate'] = { 'src/Services/Rooms/spec/{}Spec.php' },
    },
    ['src/Services/Routes/*.php'] = {
        ['alternate'] = { 'src/Services/Routes/spec/{}Spec.php' },
    },
    ['src/Services/Tours/*.php'] = {
        ['alternate'] = { 'src/Services/Tours/spec/{}Spec.php' },
    },
    ['src/Services/Transfers/*.php'] = {
        ['alternate'] = { 'src/Services/Transfers/spec/{}Spec.php' },
    },
    ['src/Services/Boats/*.php'] = {
        ['alternate'] = { 'src/Services/Boats/spec/{}Spec.php' },
    },
    ['src/Services/Trains/*.php'] = {
        ['alternate'] = { 'src/Services/Trains/spec/{}Spec.php' },
    },
    ['src/Common/spec/*.php'] = {
        ['alternate'] = { 'src/Common/{}Spec.php' },
    },
    ['src/Core/spec/*.php'] = {
        ['alternate'] = { 'src/Core/{}Spec.php' },
    },
    ['src/Tasks/*.php'] = {
        ['alternate'] = { 'src/Tasks/spec/{}Spec.php' },
    },
    ['src/WebApp/*.php'] = {
        ['alternate'] = { 'src/WebApp/spec/{}Spec.php' },
    },
}

vim.g.projectionist_heuristics = {
    ['docker-compose*.yaml'] = {
        ['*'] = { start = 'docker-compose up -d' }
    },
    ['composer.json&src/'] = vim.tbl_deep_extend('keep', worldia, {
        ['*.php'] = {
            ['console'] = 'php -a',
        },
        ['src/*.php'] = {
            ['type'] = 'src',
            ['skeleton'] = 'classf',
            ['alternate'] = {
              'tests/Unit/{}Test.php',
              'tests/Integration/{}Test.php',
              'tests/Functional/{}Test.php',
              'tests/{}Test.php',
              'spec/{}Spec.php',
            }
        },
        ['tests/Unit/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'src/{}.php',
        },
        ['tests/Integration/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'src/{}.php',
        },
        ['tests/Functional/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'src/{}.php',
        },
        ['tests/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'src/{}.php',
        },
        ['spec/*Spec.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'classe',
            ['alternate'] = 'src/{}.php',
        },
    }),
    ['composer.json&lib/'] = vim.tbl_deep_extend('keep', worldia, {
        ['*.php'] = {
            ['console'] = 'php -a',
        },
        ['lib/*.php'] = {
            ['type'] = 'src',
            ['skeleton'] = 'classf',
            ['alternate'] = {
              'tests/Unit/{}Test.php',
              'tests/Integration/{}Test.php',
              'tests/Functional/{}Test.php',
              'tests/{}Test.php',
              'spec/{}Spec.php',
            }
        },
        ['tests/*Test.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'pucase',
            ['alternate'] = 'lib/{}.php',
        },
        ['spec/*Spec.php'] = {
            ['type'] = 'test',
            ['skeleton'] = 'classe',
            ['alternate'] = 'lib/{}.php',
        },
    }),
    ['src/Kernel.php&public/index.php&src/Controller'] = {
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
    ['pom.xml'] = {
        ['src/main/java/*.java'] = {
            ['type'] = 'source',
            ['alternate'] = 'src/test/java/{}Test.java',
        },
        ['src/test/java/*Test.java'] = {
            ['type'] = 'test',
            ['alternate'] = 'src/main/java/{}.java',
        },
    },
}
