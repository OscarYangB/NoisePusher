local dialog = Dialog("Normal Map Shape Generator")

function roundTo(number, to)
  if to == 0 then
    return number
  end
  
  return math.floor(number - number % to)
end

function processPixel(value)
    local newValue = roundTo(value, tonumber(dialog.data.preround))
    newValue = math.random(newValue, newValue + dialog.data.noise)
    newValue = roundTo(newValue, tonumber(dialog.data.postround))
    newValue = math.min(newValue, 255)
    return newValue
end

function execute()
  local image = Image(app.image)
  
  for it in image:pixels() do
    local pixel = it()
    local r = processPixel(app.pixelColor.rgbaR(pixel))
    local g = processPixel(app.pixelColor.rgbaG(pixel))
    local b = processPixel(app.pixelColor.rgbaB(pixel))
    local newPixel = app.pixelColor.rgba(r, g, b)
    it(newPixel)
  end
  
  local layer = app.activeSprite:newLayer()
  layer.name = dialog.data.outputLayer
  app.activeSprite:newCel(layer, 1, image, Point(0, 0))
  app.refresh()
end

dialog:entry {
  id="outputLayer",
  label = "Output Layer: ",
  text = "Output"
}

dialog:entry {
  id="preround",
  label = "Pre-Noise Rounding: ",
  text = "1"
}

dialog:entry {
  id="noise",
  label = "Noise: ",
  text = "0"
}

dialog:entry {
  id="postround",
  label = "Post-Noise Rounding: ",
  text = "1"
}

dialog:button {
  id="execute",
  text = "Execute",
  onclick = execute
}

dialog:show()