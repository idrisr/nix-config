-- init.lua (or any Lua script name of your choice)

-- Set the fzf.vim configuration options
-- vim.g.fzf_preview_window = { 'top,70%', 'ctrl-/' }

vim.api.nvim_set_keymap('n', '<leader>z', ':GFiles<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>x', ':Files<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>d', ':Windows<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', ':Rg<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':Tg<CR>', { silent = true })

vim.g.fzf_buffers_jump = 0
vim.g.fzf_tags_command = 'ctags -R'

vim.g.fzf_colors = {
  fg = { 'fg', 'Normal' },
  bg = { 'bg', 'Normal' },
  hl = { 'fg', 'Comment' },
  ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
  ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
  ['hl+'] = { 'fg', 'Statement' },
  info = { 'fg', 'PreProc' },
  border = { 'fg', 'Ignore' },
  prompt = { 'fg', 'Conditional' },
  pointer = { 'fg', 'Exception' },
  marker = { 'fg', 'Keyword' },
  spinner = { 'fg', 'Label' },
  header = { 'fg', 'Comment' },
}

local function build_quickfix_list(lines)
  vim.fn.setqflist(vim.fn.map(vim.deepcopy(lines), function(line)
    return { filename = line }
  end))
  vim.cmd('copen')
  vim.cmd('cc')
end

vim.g.fzf_action = {
  ['ctrl-q'] = build_quickfix_list,
  ['ctrl-t'] = 'tab split',
  ['ctrl-s'] = 'split',
  ['ctrl-v'] = 'vsplit',
  ['ctrl-b'] = ':bd',
}

vim.g.fzf_commands = {'--bind ctrl-a:select-all';
'--bind ctrl-u:page-up';
'--bind ctrl-d:page-down';
'--bind ctrl-alt-u:preview-page-up';
'--bind ctrl-alt-d:preview-page-down';
'--exact'}

vim.env.FZF_DEFAULT_OPTS = table.concat(commands, " ")
