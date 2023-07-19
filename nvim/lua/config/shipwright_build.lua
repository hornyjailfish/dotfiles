local colorscheme = require("my_colorscheme")

run(colorscheme,
  -- we must process our colorscheme to conform to the alacritty transforms format.
  -- we can do this with an inline transform.
  function (groups)
    return {
      primary = {
        bg = groups.Normal.bg,
        fg = groups.Normal.fg
      }
    }
  end,

  -- now we can pass to alacritty, note that the transform accepts a name,
  -- so we use a table with the transform and it's argument.
  {alacritty, "my_colorscheme"},

  -- and now we can write, either to share or to our local config
  {overwrite, "~/.config/alacritty/colorscheme.yaml"}

  -- note, as overwrite is a transform, it *must* return a table, and infact
  -- overwrite returns the same lines it was given. we can pass these lines
  -- another transform.
  {overwrite, "extra/terms/alacritty.yaml"})
