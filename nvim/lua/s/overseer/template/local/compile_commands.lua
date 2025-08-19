local files = require("overseer.files")
local overseer = require("overseer")
local util = require("overseer.util")

---@type overseer.TemplateFileDefinition
local tmpl = {
  name = "clang compile_commands",
  priority = 30,
  desc = "run task from compile_commands.json file",
  params = {
    args = { optional = true, type = "list", delimiter = " " },
    cwd = { optional = true },
    bin = { optional = true, type = "string" },
  },
  builder = function(params)
    return {
      cmd = { params.bin },
      args = params.args,
      cwd = params.cwd,
    }
  end,
}

---@param opts overseer.SearchParams
local function get_compile_commands_file(opts)
  -- Some projects have package.json files in subfolders, which are not the main project package.json file,
  -- but rather some submodule marker. This seems prevalent in react-native projects. See this for instance:
  -- https://stackoverflow.com/questions/51701191/react-native-has-something-to-use-local-folders-as-package-name-what-is-it-ca
  -- To cover that case, we search for package.json files starting from the current file folder, up to the
  -- working directory
  local matches = vim.fs.find("compile_commands.json", {
    upward = true,
    type = "file",
    path = opts.dir,
    stop = vim.fn.getcwd() .. "/..",
    limit = math.huge,
  })
  if #matches > 0 then
    return matches
  end
  -- we couldn't find any match up to the working directory.
  -- let's now search for any possible single match without
  -- limiting ourselves to the working directory.
  return vim.fs.find("compile_commands.json", {
    upward = true,
    type = "file",
    path = vim.fn.getcwd(),
  })
end

---@param opts overseer.SearchParams
---@return string|nil
local function get_file(opts)
  local candidate_packages = get_compile_commands_file(opts)
  -- go through candidate package files from closest to the file to least close
  for _, package in ipairs(candidate_packages) do
    local data = files.load_json_file(package)
    -- for idx, task in pairs(data) do
    if data then
      return package
    end
    -- end
  end
  return nil
end

local function get_cmd(file)
  for command, idx in ipairs(file) do
    return command.arguments[1]
  end
  return "clang"
end

return {
  cache_key = function(opts)
    return get_file(opts)
  end,
  condition = {
    callback = function(opts)
      local package_file = get_file(opts)
      if not package_file then
        return false, "No compile_commands.json file found"
      end
      return true
    end,
  },
  generator = function(opts, cb)
    local file = get_file(opts)
    if not file then
      cb({})
      return
    end
    -- local bin = get_cmd(file)
    local data = files.load_json_file(file)
    local ret = {}
    for _, val in ipairs(data) do
      if not val.command and not val.arguments then
        cb({})
      end
      local bin = val.command
      local args = {}
      if val.arguments then
        bin = table.remove(val.arguments, 1)
        args = val.arguments
      end
      table.insert(
        ret,
        overseer.wrap_template(
          tmpl,
          { name = string.format("%s %s ", val.file, val.output) },
          { args = args, bin = bin, cwd = val.directory or "." }
        )
      )
    end
    -- table.insert(ret, overseer.wrap_template(tmpl, { name = bin }, { bin = bin }))
    cb(ret)
  end,
}
