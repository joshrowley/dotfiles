-- Rex config: https://www.superlogical.com/rex/docs
-- After editing: `rex config check` to validate, `rex config reload` to apply.
-- Shortcuts set in the Rex app override anything bound here.

local TERMINAL = "com.superlogical.terminal.shell"

---------------------------------------------------------------------------
-- Panes
---------------------------------------------------------------------------

rex.bind("cmd+d", "pane.split", { direction = "right" })
rex.bind("shift+cmd+d", "pane.split", { direction = "down" })

for _, dir in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("alt+cmd+" .. dir, "pane.focus." .. dir)
  rex.bind("shift+alt+cmd+" .. dir, "pane.move." .. dir)
end

rex.bind("shift+cmd+enter", "pane.zoom")
rex.bind("ctrl+cmd+=", "pane.balance")

-- Resize mode: ctrl+cmd+r, then arrows (shift for big steps), enter or escape to leave.
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+cmd+r", "client.mode.enter", { name = "resize" })
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("resize/" .. dir, "pane.resize", { direction = dir })
  rex.bind("resize/shift+" .. dir, "pane.resize", { direction = dir, amount = 15 })
end
rex.bind("resize/enter", "client.mode.exit")

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local HOME = os.getenv("HOME") or ""

local function url_decode(s)
  return (s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

-- The working directory of the pane an action was run from. Needs the shell to
-- report it (OSC 7), which bash/rex does. Falls back to $HOME.
local function current_dir(ctx)
  if not ctx.block_id then return HOME end
  local r = rex.block.call(TERMINAL:gsub("%.shell$", ""), "pwd", { id = ctx.block_id })
  local pwd = type(r) == "table" and (r.pwd or r.path or r.url) or r
  if type(pwd) ~= "string" or pwd == "" then return HOME end
  pwd = pwd:gsub("^file://[^/]*", "")
  return url_decode(pwd)
end

local function basename(path)
  return path:match("([^/]+)/*$") or path
end

local function exists(path)
  local r = rex.exec({ "test", "-e", path })
  return r and r.ok
end

local function shell(dir, opts)
  opts = opts or {}
  local options = { cwd = dir }
  if opts.input then options.initial_input = opts.input end
  return rex.layout.block({ flavor = TERMINAL, label = opts.label, options = options })
end

-- Editor shell on the left; server (bin/dev when the project has one) and a
-- spare shell stacked on the right.
local function dev_window(dir)
  local server = exists(dir .. "/bin/dev") and shell(dir, { label = "server", input = "bin/dev\r" })
    or shell(dir, { label = "shell" })
  local _, err = rex.session.new_window({
    window_label = basename(dir),
    layout = rex.layout.horizontal(0.6,
      shell(dir, { label = "main" }),
      rex.layout.vertical(0.5, server, shell(dir, { label = "shell" }))),
  })
  if err then error(err, 0) end
end

---------------------------------------------------------------------------
-- Actions (also in the command palette and `rex do NAME`)
---------------------------------------------------------------------------

rex.action({
  name = "dev",
  title = "Dev Layout Here",
  description = "New tab in this pane's folder: main shell, bin/dev, spare shell.",
  category = "Layout",
  run = function(ctx) dev_window(current_dir(ctx)) end,
})
rex.bind("shift+cmd+n", "dev")

rex.action({
  name = "project",
  title = "Open Project…",
  description = "Pick a git repo under ~/code and open it in a dev layout.",
  category = "Layout",
  run = function()
    local r = rex.exec({ "find", HOME .. "/code", "-mindepth", "2", "-maxdepth", "3",
      "-name", ".git", "-not", "-path", "*/node_modules/*" }, { timeout = 5 })
    local items = {}
    for git in (r and r.stdout or ""):gmatch("[^\n]+") do
      local dir = git:gsub("/%.git$", "")
      table.insert(items, { id = dir, title = basename(dir), subtitle = dir:gsub("^" .. HOME, "~") })
    end
    table.sort(items, function(a, b) return a.title < b.title end)
    local dir, reason = rex.ui.pick({ title = "Open project", items = items })
    if not dir then return reason end
    if type(dir) == "table" then dir = dir.id or dir[1] end
    dev_window(dir)
  end,
})
rex.bind("cmd+p", "project")

rex.action({
  name = "claude",
  title = "Claude Code Beside Me",
  description = "Split right and start Claude Code in this pane's folder.",
  category = "Agents",
  run = function(ctx)
    local _, err = rex.session.new_split({
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      ratio = 0.5,
      focus = true,
      layout = shell(current_dir(ctx), { label = "claude", input = "claude\r" }),
    })
    if err then error(err, 0) end
  end,
})
rex.bind("shift+cmd+c", "claude")
