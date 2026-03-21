local status_ok, bookmarks = pcall(require, "bookmarks")
if not status_ok then
  return
end

bookmarks.setup({
  -- override default configuration values
  selected_browser = 'chrome',
})
