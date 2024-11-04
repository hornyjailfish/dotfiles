local wezterm = require("wezterm")
local M = {}

-- function for merging tables together
M.tbl_merge = function (...)
	local result <const> = {}
	-- For each source table
	for _, t in ipairs({ ... }) do
		-- For each pair in t
		for k, v in pairs(t) do
			result[k] = v
		end
	end
	return result
end

--[[
   {
        "backend": "Vulkan",
        "device": 39528,
        "device_type": "IntegratedGpu",
        "driver": "Intel Corporation",
        "driver_info": "Intel driver",
        "name": "Intel(R) UHD Graphics",
        "vendor": 32902,
    },
    {
        "backend": "Vulkan",
        "device": 9637,
        "device_type": "DiscreteGpu",
        "driver": "NVIDIA",
        "driver_info": "565.90",
        "name": "NVIDIA GeForce RTX 3050 Laptop GPU",
        "vendor": 4318,
    },
    {
        "backend": "Dx12",
        "device": 9637,
        "device_type": "DiscreteGpu",
        "name": "NVIDIA GeForce RTX 3050 Laptop GPU",
        "vendor": 4318,
    },
    {
        "backend": "Dx12",
        "device": 39528,
        "device_type": "IntegratedGpu",
        "name": "Intel(R) UHD Graphics",
        "vendor": 32902,
    },
    {
        "backend": "Dx12",
        "device": 140,
        "device_type": "Cpu",
        "name": "Microsoft Basic Render Driver",
        "vendor": 5140,
    },
    {
        "backend": "Gl",
        "device": 0,
        "device_type": "IntegratedGpu",
        "name": "Intel(R) UHD Graphics",
        "vendor": 32902,
    },
--]]

M.set_gpu = function(config)
	local intel
	local nvidia
	for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
		if gpu.backend == 'Vulkan' and gpu.device_type == 'IntegratedGpu' then
			intel = gpu
		end
		if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
			nvidia = gpu
		end
	end

	for _, b in ipairs(require("wezterm").battery_info()) do
		if b.state == 'Discharging' then
			config.webgpu_preferred_adapter = intel
			if config.webgpu_power_preference ~= "LowPower" then
				config.webgpu_power_preference = "LowPower"
			end
		else
			config.webgpu_power_preference = "HighPerformance"
			config.webgpu_preferred_adapter = nvidia
		end
	end
	-- webgpu work bad for me
	-- config.front_end = 'WebGpu'
	-- config.front_end = 'OpenGL'
end

return M
