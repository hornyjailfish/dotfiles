vim.opt.backup = false                                             -- creates a backup file
vim.opt.cmdheight = 2                                              -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" } -- mostly just for cmp
vim.opt.conceallevel = 0                                           -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                                     -- the encoding written to a file
vim.opt.hlsearch = true                                            -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                                          -- ignore case in search patterns
vim.opt.mouse = "a"                                                -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                                             -- pop up menu height
vim.opt.showmode = true                                            -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 1                                            -- always show tabs
vim.opt.smartcase = true                                           -- smart case
vim.opt.smartindent = true                                         -- make indenting smarter again
vim.opt.splitbelow = true                                          -- force all horizontal splits to go below current window
vim.opt.splitright = true                                          -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                                           -- creates a swapfile
vim.opt.termguicolors = true                                       -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 20                                            -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                                            -- enable persistent undo
vim.opt.updatetime = 70                                            -- faster completion (4000ms default)
vim.opt.writebackup = false                                        -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                                           -- convert tabs to spaces
vim.opt.shiftwidth = 0                                             -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                                                -- insert 2 spaces for a tab
vim.opt.cursorline = true                                          -- highlight the current line
vim.opt.number = true                                              -- set numbered lines
vim.opt.relativenumber = true                                      -- set numbered lines
vim.opt.laststatus = 1                                             -- only the last window will always have a status line
vim.opt.showcmd = true                                             -- hide (partial) command in the last line of the screen (for performance)
vim.opt.ruler = false                                              -- hide the line and column number of the cursor position
vim.opt.numberwidth = 5                                            -- minimal number of columns to use for the line number {default 4}
vim.opt.signcolumn = "yes"                                         -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                                               -- display lines as one long line
vim.opt.scrolloff = 10                                             -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                                          -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.fillchars.eob = " "                                        -- show empty lines at the end of a buffer as ` ` {default `~`}
vim.opt.fillchars = "eob: "
vim.opt.shortmess:append("cW")                                     -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
vim.opt.whichwrap:append("<,>,[,],h,l")                            -- keys allowed to move to the previous/next line when the beginning/end of line is reached
vim.opt.iskeyword:append("-")                                      -- treats words with `-` as single words

-- for ts_context_commentstring
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring"
      and require("ts_context_commentstring.internal").calculate_commentstring()
      or get_option(filetype, option)
end

-- i disabled netrw LUL
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

if vim.g.enable_nushell_integration == true then
  -- INFO: settings to set nushell as the shell for the :! command
  -- --
  -- path to the Nushell executable
  vim.opt.sh = "nu"

  -- WARN: disable the usage of temp files for shell commands
  -- because Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
  --      `{shell_command} < {temp_file_with_selected_buffer_content}`
  -- When set to `false` the stdin pipe will be used instead.
  -- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
  vim.opt.shelltemp = false

  -- string to be used to put the output of shell commands in a temp file
  -- 1. when 'shelltemp' is `true`
  -- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
  --    to use an external diff command: `set diffopt-=internal`
  vim.opt.shellredir = "out+err> %s"

  -- flags for nu:
  -- * `--stdin`       redirect all input to -c
  -- * `--no-newline`  do not append `\n` to stdout
  -- * `--commands -c` execute a command
  vim.opt.shellcmdflag = "--stdin --no-newline -c"

  -- disable all escaping and quoting
  vim.opt.shellxescape = ""
  vim.opt.shellxquote = ""
  vim.opt.shellquote = ""

  -- string to be used with `:make` command to:
  -- 1. save the stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
  -- 2. show the stdout, stderr and the return_code on the screen
  -- NOTE: `ansi strip` removes all ansi coloring from nushell errors
  vim.opt.shellpipe =
  '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'

  -- NOTE: you can uncomment the following to for instance provide custom config paths
  -- depending on the OS
  -- In this particular example using vim.env.HOME is also cross-platform

  -- utility method to detect the OS, if you use a custom config the following can be handy
  -- local function getOS()
  --   if jit then
  --     return jit.os
  --   end
  --   local fh, err = assert(io.popen('uname -o 2>/dev/null', 'r'))
  --   if fh then
  --     Osname = fh:read()
  --   end
  --
  --   return Osname or 'Windows'
  -- end
  --
  -- if getOS() == 'Windows' then
  --   vim.opt.sh = 'nu --env-config C:/Users/User/.dot/env/env.nu --config C:/Users/User/.dot/env/config.nu'
  -- else
  --   vim.opt.sh = 'nu --env-config /Users/mel/.dot/env/env.nu --config /Users/mel/.dot/env/config.nu'
  -- end
end
