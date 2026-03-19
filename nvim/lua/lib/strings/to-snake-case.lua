return function(str)
  return str:gsub("(%l)(%u)", "%1_%2"):gsub("(%d)(%u)", "%1_%2"):gsub("-", "_"):gsub("\\.", "_"):lower()
end
