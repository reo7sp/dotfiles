local function highlight_color(group, color)
  return vim.api.nvim_get_hl(0, { name = group, link = false })[color]
end

local function apply_highlights()
  local foreground = highlight_color("Normal", "fg")
  local background = highlight_color("Normal", "bg")
  local cursor_background = highlight_color("CursorColumn", "bg") or background
  local menu_background = highlight_color("SignColumnSB", "bg") or highlight_color("NormalFloat", "bg")
  local accent = highlight_color("Directory", "fg") or foreground

  vim.api.nvim_set_hl(0, "WinSeparator", { fg = highlight_color("LineNr", "fg") or foreground, bg = background, bold = true })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = cursor_background })
  vim.api.nvim_set_hl(0, "YankyYanked", { bg = "#3c5573" })
  vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#8094b4", ctermfg = 12, default = true })
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = menu_background, fg = highlight_color("Pmenu", "fg") or foreground })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = menu_background, fg = accent })
  vim.api.nvim_set_hl(0, "SatelliteBar", { bg = highlight_color("ColorColumn", "bg") or background })
  local visible_colors = {
    BufferVisible = foreground,
    BufferVisibleSign = accent,
    BufferVisibleTarget = highlight_color("BufferDefaultVisibleTarget", "fg"),
  }
  for group, color in pairs(visible_colors) do
    vim.api.nvim_set_hl(0, group, { bg = "#464b59", fg = color })
  end

  local links = {
    VirtColumn = "IblIndent",
    NvimTreeNormal = "Normal",
    NvimTreeNormalNC = "Normal",
    NvimTreeEndOfBuffer = "EndOfBuffer",
    NvimTreeWinSeparator = "WinSeparator",
    NvimTreeIndentMarker = "IblIndent",
    NeoTreeIndentMarker = "IblIndent",
    NvimTreeSpecialFile = "NvimTreeFileName",
    NvimTreeExecFile = "NvimTreeFileName",
    NvimTreeImageFile = "NvimTreeFileName",
    NvimTreeSymlink = "NvimTreeFileName",
    AerialLine = "CursorLine",
    AerialGuide = "IblIndent",
    BufferCurrent = "TabLineSel",
    BufferCurrentIndex = "BufferCurrent",
    BufferCurrentMod = "BufferCurrent",
    BufferCurrentSign = "BufferCurrent",
    BufferInactiveIndex = "BufferInactive",
    BufferInactiveMod = "BufferInactive",
    BufferTabpages = "BufferCurrent",
    BufferTabpagesSep = "BufferTabpages",
    BufferVisibleIndex = "BufferVisible",
    BufferVisibleMod = "BufferVisible",
    TroubleNormal = "Normal",
    TroubleNormalNC = "Normal",
    TroubleIndent = "IblIndent",
    TroubleIndentFoldClosed = "IblIndent",
    TroubleIndentFoldOpen = "IblIndent",
    TinyInlineDiagnosticVirtualTextArrow = "CursorLine",
    MarkSignHL = "SignColumn",
    MarkSignNumHL = "SignColumn",
    SatelliteSearch = "SatelliteMark",
    SatelliteSearchCurrent = "SatelliteMark",
  }
  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("EditorHighlights", { clear = true }),
  callback = function()
    vim.schedule(apply_highlights)
  end,
})
apply_highlights()
