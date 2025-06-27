vim.filetype.add {
    extension = {
        template = 'yaml',
    }
}

-- Enable reading .nvim.lua or .nvimrc files
vim.o.exrc = true 
-- Disable autocmd, shell, and write commands in rc files for protection
vim.o.secure = true

-- This pretty much checks if we're in a git repo, and if so
-- tries to find an .nvim.lua in the repo root and apply it.
local function find_git_root_nvim_lua()
     -- Check if we're in a git repo
    local is_git = vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'):gsub('\n', '')
    if is_git ~= 'true' then
        return
    end
    
    -- Get git root directory
    local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
    local config_file = git_root .. '/.nvim.lua'
    
    -- Source the config file if it exists
    print(config_file)
    if vim.fn.filereadable(config_file) == 1 then
        vim.cmd('source ' .. vim.fn.fnameescape(config_file))
    end
end

-- Run when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
    callback = find_git_root_nvim_lua
})
