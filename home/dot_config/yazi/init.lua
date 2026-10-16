-- File list

function Linemode:permissions_size()
  local permissions = self._file.cha:perm() or "----------"
  local size = self._file:size()
  return string.format("%s %6s", permissions, size and ya.readable_size(size) or "-")
end

-- Icons

function Entity:icon()
  local icon = th.icon:match(self._file, { hovered = self._file.is_hovered })
  return icon and (icon.text:gsub("%s+$", "") .. "  ") or ""
end

-- Layout

Header:children_remove(1, Header.LEFT)

function Root:layout()
  self._chunks = ui.Layout()
    :direction(ui.Layout.VERTICAL)
    :constraints({
      ui.Constraint.Length(0),
      ui.Constraint.Length(Tabs.height()),
      ui.Constraint.Fill(1),
      ui.Constraint.Length(1),
    })
    :split(self._area)
end

-- MIME types

require("mime-ext.local"):setup {
  fallback_file1 = true,
}
require("mime-ext"):setup()

-- Status bar

Status:children_remove(2, Status.LEFT) -- File size
Status:children_remove(4, Status.RIGHT) -- Permissions
Status:children_remove(5, Status.RIGHT) -- Percentage

Status:children_add(function(self)
  local files, dirs = 0, 0
  for _, file in ipairs(self._current.files) do
    if file.cha.is_dir then
      dirs = dirs + 1
    else
      files = files + 1
    end
  end
  return string.format(" %d dirs %d files ", dirs, files)
end, 1000, Status.RIGHT)

function Status:name()
  local path = ya.readable_path(tostring(self._current.cwd)) .. Header.flags(self)
  local count = #self._tab.selected
  local selected = count > 0 and ui.Span(string.format(" %d selected ", count)):style(th.mgr.count_selected) or ""
  local max = self._area.w - self:children_redraw(Status.RIGHT):width() - self:mode():width() - ui.width(selected) - 2
  if max <= 0 then
    return selected
  end
  return ui.Line { selected, " " .. ui.truncate(path, { max = max, rtl = true }) }
end

function Status:mode()
  local mode = tostring(self._tab.mode):sub(1, 1):upper()
  local style = self:style()
  return ui.Line {
    ui.Span(th.status.sep_left.open):fg(style.main:bg()):bg(App.bg()),
    ui.Span(" " .. mode .. " "):style(style.main),
    ui.Span(th.status.sep_left.close):fg(style.main:bg()):bg(style.alt:bg()),
  }
end

-- Terminal title

ps.sub("ind-app-title", function(args)
  args.value = ya.readable_path(tostring(cx.active.current.cwd)) .. " - Yazi"
  return args
end)
