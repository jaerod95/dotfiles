return function(str)
  return str:gsub("(%l)(%u)", "%1-%2"):gsub("(%d)(%u)", "%1-%2"):gsub("_", "-"):gsub("\\.", "-"):lower()
end
