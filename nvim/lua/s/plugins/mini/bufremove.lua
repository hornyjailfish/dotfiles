local function get_all_workspace_folders()
	local workspace_folders = {}

	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if not client.initialized then
			print("LSP not ready yet")
			table.insert(workspace_folders, "")
		else
			table.insert(workspace_folders, client.config.root_dir)
		end
	end

	return workspace_folders
end

local function remove_non_workspace_buffers()
	local workspace_folders = get_all_workspace_folders()
	local all_buffers = vim.api.nvim_list_bufs()

	for _, buf_id in ipairs(all_buffers) do
		local buf_path = vim.fn.expand(vim.api.nvim_buf_get_name(buf_id))
		local buf_dir = vim.fn.fnamemodify(buf_path, ":p:h")
		local is_in_workspace = false

		for _, workspace in ipairs(workspace_folders) do
			local normal_workspace = vim.fn.expand(workspace)
			-- print("serching in " .. buf_dir .. " in " .. normal_workspace)
			if buf_dir:find("^" .. normal_workspace) then
				-- print("found " .. buf_dir)
				-- if buf_dir:find("^" .. workspace) then
				is_in_workspace = true
				break
			end
		end

		if not is_in_workspace or buf_path == "" then
			require("mini.bufremove").delete(buf_id, false)
		end
	end
end

return {
	"nvim-mini/mini.bufremove",
	lazy = true,
	keys = {
		{
			"<leader>bw",
			function()
				remove_non_workspace_buffers()
			end,
			desc = "Remove Non Workspace Buffers (work bad)",
		},
		{ "<leader>bX", "<cmd>.+,$bwipeout<cr>", desc = "Wipe ALL(!) other bufers !" },
		{ "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", desc = "Delete current buffer" },
	},
	config = function()
		require("mini.bufremove").setup()
	end,
}
