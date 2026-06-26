-- local discipline = require("peterchiang.discipline")
-- disable discipline.cowboy()
-- discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Scroll cursor
keymap.set("n", "<C-b>", "15kzz")
keymap.set("n", "<C-f>", "15jzz")

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
  require("peterchiang.utils").replaceHexWithHSL()
end)

-- Generate conventional commit message using Gemini API
vim.api.nvim_create_user_command("GeminiCommit", function()
  local api_key = os.getenv("NVIM4GEMINICOMMIT_GEMINI_API_KEY") or os.getenv("GEMINI_API_KEY")
  if not api_key or api_key == "" then
    -- Fallback: try reading directly from fish .env file
    local home = os.getenv("HOME")
    if home then
      local env_file = home .. "/.config/fish/.env"
      local f = io.open(env_file, "r")
      if f then
        for line in f:lines() do
          local key, val = line:match("^%s*([^=]+)%s*=%s*(.*)%s*$")
          if key then
            key = vim.trim(key)
            if key == "NVIM4GEMINICOMMIT_GEMINI_API_KEY" or key == "GEMINI_API_KEY" then
              -- Strip quotes and trim whitespace
              api_key = vim.trim(val):gsub("^['\"]", ""):gsub("['\"]$", "")
              break
            end
          end
        end
        f:close()
      end
    end
  end

  if not api_key or api_key == "" then
    vim.notify(
      "Gemini API key not found. Please set NVIM4GEMINICOMMIT_GEMINI_API_KEY or GEMINI_API_KEY env variable.",
      vim.log.levels.ERROR
    )
    return
  end

  local diff = vim.fn.system("git diff --cached")
  if diff == "" then
    vim.notify("No staged changes found. Use 'git add' to stage changes first.", vim.log.levels.WARN)
    return
  end

  vim.notify("Generating commit message via Gemini...", vim.log.levels.INFO)

  local payload = {
    contents = {
      {
        parts = {
          {
            text = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block. Here is the git diff:\n\n"
              .. diff,
          },
        },
      },
    },
  }

  local payload_str = vim.json.encode(payload)
  local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" .. api_key

  local response_body = ""
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle

  handle = vim.loop.spawn("curl", {
    args = {
      "-s",
      "-X",
      "POST",
      "-H",
      "Content-Type: application/json",
      "-d",
      payload_str,
      url,
    },
    stdio = { nil, stdout, stderr },
  }, function(code, signal)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()

    if code ~= 0 then
      vim.schedule(function()
        vim.notify("Failed to call Gemini API. curl error code " .. code, vim.log.levels.ERROR)
      end)
      return
    end

    local ok, parsed = pcall(vim.json.decode, response_body)
    if not ok then
      vim.schedule(function()
        vim.notify("Failed to parse Gemini response.", vim.log.levels.ERROR)
      end)
      return
    end

    local text
    pcall(function()
      text = parsed.candidates[1].content.parts[1].text
    end)

    if not text then
      vim.schedule(function()
        vim.notify("Empty response. Check your API key and network connection.", vim.log.levels.ERROR)
      end)
      return
    end

    text = vim.trim(text)
    -- Strip markdown code block wrappers if present (e.g. ```gitcommit ... ``` or ``` ...)
    text = text:gsub("^```%w*\n", ""):gsub("\n```$", ""):gsub("^```", ""):gsub("```$", "")
    text = vim.trim(text)

    vim.schedule(function()
      local lines = vim.split(text, "\n")
      -- Copy to system clipboard registers (+ and *)
      vim.fn.setreg("+", text)
      vim.fn.setreg("*", text)

      if vim.bo.modifiable then
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
        vim.notify("Commit message generated and inserted! (Also copied to clipboard)", vim.log.levels.INFO)
      else
        vim.notify("Buffer is not modifiable. Commit message copied to clipboard:\n\n" .. text, vim.log.levels.INFO)
      end
    end)
  end)

  stdout:read_start(function(err, data)
    if data then
      response_body = response_body .. data
    end
  end)
end, {})
