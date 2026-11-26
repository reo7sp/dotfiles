local function highlight_color(group, color)
  return vim.api.nvim_get_hl(0, { name = group, link = false })[color]
end

local function apply_highlights()
  local colors
  local visible_background
  if vim.g.colors_name and vim.g.colors_name:match("^catppuccin") then
    colors = require("catppuccin.palettes").get_palette()
    visible_background = require("catppuccin.utils.colors").blend(colors.surface0, colors.mantle, 0.7)
  else
    colors = {
      surface0 = highlight_color("TabLine", "bg") or highlight_color("Normal", "bg"),
      surface1 = highlight_color("LineNr", "fg") or highlight_color("Normal", "fg"),
      mantle = highlight_color("CursorColumn", "bg") or highlight_color("Normal", "bg"),
      crust = highlight_color("SignColumnSB", "bg") or highlight_color("NormalFloat", "bg"),
      overlay2 = highlight_color("Pmenu", "fg") or highlight_color("Normal", "fg"),
      blue = highlight_color("Directory", "fg") or highlight_color("Normal", "fg"),
      surface2 = highlight_color("ColorColumn", "bg") or highlight_color("Normal", "bg"),
    }
  end

  vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.surface1, bg = highlight_color("Normal", "bg"), bold = true })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.mantle })
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.crust, fg = colors.overlay2 })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = colors.crust, fg = colors.blue })
  vim.api.nvim_set_hl(0, "SatelliteBar", { bg = colors.surface2 })
  vim.api.nvim_set_hl(0, "BufferTabpages", { bg = colors.blue, fg = colors.mantle, bold = true })
  vim.api.nvim_set_hl(0, "BufferTabpagesSep", { bg = colors.blue, fg = colors.mantle, bold = true })
  local visible_colors = {
    BufferVisible = colors.text or highlight_color("Normal", "fg"),
    BufferVisibleIndex = colors.blue,
    BufferVisibleMod = colors.yellow or highlight_color("BufferDefaultVisibleMod", "fg"),
    BufferVisibleSign = colors.blue,
    BufferVisibleTarget = colors.red or highlight_color("BufferDefaultVisibleTarget", "fg"),
  }
  for group, foreground in pairs(visible_colors) do
    vim.api.nvim_set_hl(0, group, { bg = visible_background or colors.surface0, fg = foreground })
  end

  local links = {
    VirtColumn = "IblIndent",
    NvimTreeNormal = "Normal",
    NvimTreeNormalNC = "Normal",
    NvimTreeWinSeparator = "WinSeparator",
    NvimTreeIndentMarker = "IblIndent",
    NeoTreeIndentMarker = "IblIndent",
    NvimTreeSpecialFile = "NvimTreeFileName",
    NvimTreeExecFile = "NvimTreeFileName",
    NvimTreeImageFile = "NvimTreeFileName",
    NvimTreeSymlink = "NvimTreeFileName",
    AerialLine = "CursorLine",
    AerialGuide = "IblIndent",
    BufferCurrentMod = "BufferCurrent",
    BufferInactiveMod = "BufferInactive",
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
