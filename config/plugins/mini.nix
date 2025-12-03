{
  plugins.mini = {
    enable = true;

    modules = {
      # Better Around/Inside textobjects
      #
      # Examples:
      #  - va)  - [V]isually select [A]round [)]paren
      #  - yinq - [Y]ank [I]nside [N]ext [']quote
      #  - ci'  - [C]hange [I]nside [']quote
      ai = {
        n_lines = 500;
      };

      # Add/delete/replace surroundings (brackets, quotes, etc.)
      #
      # Examples:
      #  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      #  - sd'   - [S]urround [D]elete [']quotes
      #  - sr)'  - [S]urround [R]eplace [)] [']
      surround = {
      };
      files = {
      };
      icons = {};

      # Simple and easy statusline.
      #  You could remove this setup call if you don't like it,
      #  and try some other statusline plugin
      statusline = {
        use_icons.__raw = "vim.g.have_nerd_font";
      };

      # ... and there is more!
      # Check out: https://github.com/echasnovski/mini.nvim
    };
  };

  keymaps = [
    {
      key = "<leader>e";
      action = ":lua OpenMiniFileCWD()<cr>";
      options = {
        desc = "[E]xpore (Mini.files)";
      };
    }
  ];

  # You can configure sections in the statusline by overriding their
  # default behavior. For example, here we set the section for
  # cursor location to LINE:COLUMN
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglu#extraconfiglua
  extraConfigLua = ''
       require('mini.statusline').section_location = function()
         return '%2l:%-2v'
       end

        function OpenMiniFileCWD()
           local MiniFiles = require("mini.files")

           -- Check if current buffer is a terminal
           local function is_terminal_buffer()
             local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
             return buftype == 'terminal'
           end

           -- Get appropriate path for mini.files
           local function get_minifiles_path()
             if is_terminal_buffer() then
               -- For terminal buffers, use current working directory
               return vim.fn.getcwd()
             else
               -- For regular files, use the buffer's file path
               local buf_name = vim.api.nvim_buf_get_name(0)

               -- If buffer has no name (empty buffer) or file doesn't exist, fall back
               if buf_name == "" or not vim.fn.filereadable(buf_name) == 1 then
                 -- Try to find git root, otherwise use cwd
                 local git_root = vim.fs.root(vim.fn.getcwd(), ".git")
                 return git_root or vim.fn.getcwd()
               end

               -- Check if the file actually exists
               if vim.fn.filereadable(buf_name) == 0 then
                 -- File doesn't exist, find git root from current working directory
                 local git_root = vim.fs.root(vim.fn.getcwd(), ".git")
                 return git_root or vim.fn.getcwd()
               end

               return buf_name
             end
           end

           local _ = MiniFiles.close() or MiniFiles.open(get_minifiles_path(), false)

           vim.defer_fn(function()
             MiniFiles.reveal_cwd()
           end, 30)
        end

       require("mini.statusline").setup({
         use_icons = vim.g.have_nerd_font,
         content = {
           active = function()
             local check_macro_recording = function()
               if vim.fn.reg_recording() ~= "" then
                 return "Recording @" .. vim.fn.reg_recording()
               else
                 return ""
               end
             end

             local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
             local git = MiniStatusline.section_git({ trunc_width = 40 })
             local diff = MiniStatusline.section_diff({ trunc_width = 75 })
             local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
             -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
             local filename = MiniStatusline.section_filename({ trunc_width = 140 })
             local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
             local location = MiniStatusline.section_location({ trunc_width = 200 })
             local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
             local macro = check_macro_recording()

             return MiniStatusline.combine_groups({
               { hl = mode_hl, strings = { mode } },
               { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
               "%<", -- Mark general truncate point
               { hl = "MiniStatuslineFilename", strings = { filename } },
               "%=", -- End left alignment
               { hl = "MiniStatuslineFilename", strings = { macro } },
               { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
               { hl = mode_hl, strings = { search, location } },
             })
           end,
         },
       })
    local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
       local autocmd = vim.api.nvim_create_autocmd
       local _, MiniFiles = pcall(require, "mini.files")

       -- Cache for git status
       local gitStatusCache = {}
       local cacheTimeout = 2000 -- Cache timeout in milliseconds

       local function isSymlink(path)
         local stat = vim.loop.fs_lstat(path)
         return stat and stat.type == "link"
       end

       ---@type table<string, {symbol: string, hlGroup: string}>
       ---@param status string
       ---@return string symbol, string hlGroup
       local function mapSymbols(status, is_symlink)
         local statusMap = {
       -- stylua: ignore start
           [" M"] = { symbol = "✹", hlGroup  = "MiniDiffSignChange"}, -- Modified in the working directory
           ["M "] = { symbol = "•", hlGroup  = "MiniDiffSignChange"}, -- modified in index
           ["MM"] = { symbol = "≠", hlGroup  = "MiniDiffSignChange"}, -- modified in both working tree and index
           ["A "] = { symbol = "+", hlGroup  = "MiniDiffSignAdd"   }, -- Added to the staging area, new file
           ["AA"] = { symbol = "≈", hlGroup  = "MiniDiffSignAdd"   }, -- file is added in both working tree and index
           ["D "] = { symbol = "-", hlGroup  = "MiniDiffSignDelete"}, -- Deleted from the staging area
           ["AM"] = { symbol = "⊕", hlGroup  = "MiniDiffSignChange"}, -- added in working tree, modified in index
           ["AD"] = { symbol = "-•", hlGroup = "MiniDiffSignChange"}, -- Added in the index and deleted in the working directory
           ["R "] = { symbol = "→", hlGroup  = "MiniDiffSignChange"}, -- Renamed in the index
           ["U "] = { symbol = "‖", hlGroup  = "MiniDiffSignChange"}, -- Unmerged path
           ["UU"] = { symbol = "⇄", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged
           ["UA"] = { symbol = "⊕", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged and added in working tree
           ["??"] = { symbol = "?", hlGroup  = "MiniDiffSignDelete"}, -- Untracked files
           ["!!"] = { symbol = "!", hlGroup  = "MiniDiffSignChange"}, -- Ignored files
           -- stylua: ignore end
         }

         local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
         local gitSymbol = result.symbol
         local gitHlGroup = result.hlGroup

         local symlinkSymbol = is_symlink and "↩" or ""

         -- Combine symlink symbol with Git status if both exist
         local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
         -- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
         local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup

         return combinedSymbol, combinedHlGroup
       end

       ---@param cwd string
       ---@param callback function
       ---@return nil
       local function fetchGitStatus(cwd, callback)
         local function on_exit(content)
           if content.code == 0 then
             callback(content.stdout)
             vim.g.content = content.stdout
           end
         end
         vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = cwd }, on_exit)
       end

       ---@param str string|nil
       ---@return string
       local function escapePattern(str)
         if not str then
           return ""
         end
         return (str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
       end

       ---@param buf_id integer
       ---@param gitStatusMap table
       ---@return nil
       local function updateMiniWithGit(buf_id, gitStatusMap)
         vim.schedule(function()
           local nlines = vim.api.nvim_buf_line_count(buf_id)
           local cwd = vim.fs.root(buf_id, ".git")
           local escapedcwd = escapePattern(cwd)
           if vim.fn.has("win32") == 1 then
             escapedcwd = escapedcwd:gsub("\\", "/")
           end

           for i = 1, nlines do
             local entry = MiniFiles.get_fs_entry(buf_id, i)
             if not entry then
               break
             end
             local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
             local status = gitStatusMap[relativePath]

             if status then
               local is_symlink = isSymlink(entry.path)
               local symbol, hlGroup = mapSymbols(status, is_symlink)
               vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
                 -- NOTE: if you want the signs on the right uncomment those and comment
                 -- the 3 lines after
                 -- virt_text = { { symbol, hlGroup } },
                 -- virt_text_pos = "right_align",
                 sign_text = symbol,
                 sign_hl_group = hlGroup,
                 priority = 2,
               })
             else
             end
           end
         end)
       end

       -- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
       ---@param content string
       ---@return table
       local function parseGitStatus(content)
         local gitStatusMap = {}
         -- lua match is faster than vim.split (in my experience )
         for line in content:gmatch("[^\r\n]+") do
           local status, filePath = string.match(line, "^(..)%s+(.*)")
           -- Split the file path into parts
           local parts = {}
           for part in filePath:gmatch("[^/]+") do
             table.insert(parts, part)
           end
           -- Start with the root directory
           local currentKey = ""
           for i, part in ipairs(parts) do
             if i > 1 then
               -- Concatenate parts with a separator to create a unique key
               currentKey = currentKey .. "/" .. part
             else
               currentKey = part
             end
             -- If it's the last part, it's a file, so add it with its status
             if i == #parts then
               gitStatusMap[currentKey] = status
             else
               -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
               if not gitStatusMap[currentKey] then
                 gitStatusMap[currentKey] = status
               end
             end
           end
         end
         return gitStatusMap
       end

       ---@param buf_id integer
       ---@return nil
       local function updateGitStatus(buf_id)
         local cwd = vim.uv.cwd()
         if not cwd or not vim.fs.root(cwd, ".git") then
           return
         end

         local currentTime = os.time()
         if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
           updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
         else
           fetchGitStatus(cwd, function(content)
             local gitStatusMap = parseGitStatus(content)
             gitStatusCache[cwd] = {
               time = currentTime,
               statusMap = gitStatusMap,
             }
             updateMiniWithGit(buf_id, gitStatusMap)
           end)
         end
       end

       ---@return nil
       local function clearCache()
         gitStatusCache = {}
       end

       local function augroup(name)
         return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
       end

       autocmd("User", {
         group = augroup("start"),
         pattern = "MiniFilesExplorerOpen",
         -- pattern = { "minifiles" },
         callback = function()
           local bufnr = vim.api.nvim_get_current_buf()
           updateGitStatus(bufnr)
         end,
       })

       autocmd("User", {
         group = augroup("close"),
         pattern = "MiniFilesExplorerClose",
         callback = function()
           clearCache()
         end,
       })

       autocmd("User", {
         group = augroup("update"),
         pattern = "MiniFilesBufferUpdate",
         callback = function(sii)
           local bufnr = sii.data.buf_id
           local cwd = vim.fn.expand("%:p:h")
           if gitStatusCache[cwd] then
             updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
           end
         end,
       })

       -- Hook to automatically add package template when creating new .go files
       autocmd("User", {
         group = augroup("go_new"),
         pattern = "MiniFilesActionCreate",
         callback = function(args)
           local path = args.data.to
           -- Check if the created file is a .go file
           if path and path:match('%.go$') then
             vim.schedule(function()
               -- Close mini.files first
               if MiniFiles then
                 MiniFiles.close()
               end

               -- Open the file
               vim.cmd('edit ' .. vim.fn.fnameescape(path))

               -- Determine package name from directory
               local dir_name = vim.fn.fnamemodify(path, ':h:t')
               local package_name = 'main'

               -- Use directory name as package name if it's a valid Go identifier
               if dir_name and dir_name ~= '.' and dir_name ~= "" and dir_name:match('^[a-z][a-z0-9_]*$') then
                 package_name = dir_name
               end

               -- Check if file is empty before adding template
               local line_count = vim.api.nvim_buf_line_count(0)
               local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""

               if line_count == 1 and first_line == "" then
                 local lines = { 'package ' .. package_name, "" }

                 -- Add a main function if it's package main and filename is main.go
                 local filename = vim.fn.fnamemodify(path, ':t')
                 if package_name == 'main' and filename == 'main.go' then
                   lines = {
                     'package main',
                     "",
                     'func main() {',
                     '	',
                     '}',
                   }
                 end

                 vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

                 -- Position cursor appropriately
                 if package_name == 'main' and filename == 'main.go' then
                   vim.api.nvim_win_set_cursor(0, {4, 1})  -- Inside main function
                 else
                   vim.api.nvim_win_set_cursor(0, {2, 0})  -- After package declaration
                 end

                 -- Start insert mode
                 vim.cmd('startinsert')
               end
             end)
           end
         end,
       })
  '';
}
