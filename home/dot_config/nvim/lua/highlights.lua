local function highlight_color(group, color)
  return vim.api.nvim_get_hl(0, { name = group, link = false })[color]
end

local function apply_highlights()
  local colors
  if vim.g.colors_name and vim.g.colors_name:match("^catppuccin") then
    colors = require("catppuccin.palettes").get_palette()
  else
    colors = {
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

  local links = {
    VirtColumn = "IblIndent",
    NvimTreeNormal = "Normal",
    NvimTreeNormalNC = "Normal",
    NvimTreeWinSeparator = "WinSeparator",
    NvimTreeIndentMarker = "IblIndent",
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
