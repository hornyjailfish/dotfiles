local M = {}
local palette = {}

M.base = vim.g.base_color

local gen = require("s.util.colorgen")
local hsluv = require("s.util.colorgen.hsluv")

local base = hsluv.hex_to_hsluv(M.base)
local complement = gen.compl(base)
local split_complement_l, split_complement_r = gen.splitcomp(base)
local analog_l, analog_r = gen.analog(base)
local triadic_l, triadic_r = gen.triadic(base)


M.colors = {
    base = base,
    complement = complement,
    split_complement_l = split_complement_l,
    split_complement_r = split_complement_r,
    analog_l = analog_l,
    analog_r = analog_r,
    triadic_l = triadic_l,
    triadic_r = triadic_r,
}

M.dim = {}
M.bg = { light = { base = {}, dim = {} }, dark = { base = {}, dim = {} } }
M.hex = {
    base = {},
    dim = {},
    bg = { light = { base = {}, dim = {} }, dark = { base = {}, dim = {} } }
}

M.hues = { mean = 0, base = {}, dim = {} }
M.sat = { mean = 0, base = {}, dim = {} }
M.light = { mean = 0, base = {}, dim = {} }

local i = 1
for name, color in pairs(M.colors) do
    local col = vim.deepcopy(color)

    table.insert(M.hues.base, i, color[1])
    table.insert(M.sat.base, i, color[2])
    table.insert(M.light.base, i, color[3])

    col = hsluv.hsluv_to_lch(color)
    col[2] = hsluv.max_safe_chroma_for_l(col[1])
    M.dim[name] = hsluv.lch_to_hsluv(col)

    M.hex.base[name] = hsluv.hsluv_to_hex(color)
    M.hex.dim[name] = hsluv.hsluv_to_hex(M.dim[name])
    table.insert(M.hues.dim, i, M.dim[name][1])
    table.insert(M.sat.dim, i, M.dim[name][2])
    table.insert(M.light.dim, i, M.dim[name][3])
    i = i + 1
end

M.gray = gen.gray(M.dim.base)
M.hex.gray = hsluv.hsluv_to_hex(M.gray)
M.i_gray = gen.inv_l(M.gray)
M.hex.i_gray = hsluv.hsluv_to_hex(M.i_gray)

M.compl_gray = gen.gray(M.dim.complement)
M.hex.compl_gray = hsluv.hsluv_to_hex(M.compl_gray)


M.bg.light.base, M.bg.dark.base = gen.contrasts(M.dim.base, 10.5)
M.hex.bg.light.base = hsluv.hsluv_to_hex(M.bg.light.base)
M.hex.bg.dark.base = hsluv.hsluv_to_hex(M.bg.dark.base)

M.bg.light.dim = gen.desat(M.bg.light.base, 4)
M.bg.dark.dim = gen.desat(M.bg.dark.base, 4)
M.hex.bg.light.dim = hsluv.hsluv_to_hex(M.bg.light.dim)
M.hex.bg.dark.dim = hsluv.hsluv_to_hex(M.bg.dark.dim)

local power = 15
local avg = require("s.util.colorgen.average")
M.avg = {}
M.avg.energetic = {
    avg.energetic(M.hues.dim),
    avg.energetic(M.light.dim),
    avg.energetic(M.sat.dim)
}
M.avg.moderate = {
    avg.generalized(M.hues.dim, power),
    avg.generalized(M.light.dim, power),
    avg.generalized(M.sat.dim, power)
}
-- M.avg.dark = gen.desat(M.avg.moderate)
M.hex.energy = hsluv.hsluv_to_hex(M.avg.moderate)
M.hex.general = hsluv.hsluv_to_hex(M.avg.energetic)
-- local ratio = gen.ratio(M.dim.base, M.dim.bg.light)
-- print("full:",vim.inspect(M))
-- print("base:",vim.inspect(M.colors))
-- print("dim:", vim.inspect(M.dim))
-- print(vim.inspect(M))
return M
