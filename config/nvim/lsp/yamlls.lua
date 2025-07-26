return {
  settings = {
    yaml = {
      format = {
        singleQuote = true,
        proseWrap = 'Always',
        printWidth = 120, -- TODO detect it for YAML config ?
      },
      customTags = {
        '!reference sequence',
        '!Ref scalar',
        '!GetAtt sequence',
        '!Sub scalar',
      },
      schemas = vim.tbl_deep_extend(
        'force',
        require('schemastore').yaml.schemas(),
        {
          -- Custom GitLab CI patterns (including your etc/gitlab structure)
          ['https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json'] = {
            'etc/gitlab/*.yml',
            'etc/gitlab/*.yaml',
            'etc/gitlab/.*.yml',
            'etc/gitlab/.*.yaml',
          },
          -- Custom Helm patterns (your etc/helm structure)
          ['https://json.schemastore.org/helmfile'] = {
            '**/helm/**/*.yml',
            '**/helm/**/*.yaml',
          },
        }
      ),
    },
  },
}
