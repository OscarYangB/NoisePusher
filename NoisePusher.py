from PIL import Image
import random
import math

def roundTo(number, to):
    return math.floor(number - number % to)

def processPixel(value, noiseAmount):
    newValue = random.randrange(value, value + noiseAmount)
    newValue = min(newValue, 255)
    newValue = roundTo(newValue, 17)
    return newValue

noiseAmount = int(input("Noise Amount: "))
nextInput = ""
paths = []
while (True):
    nextInput = input("File (Done when done): ")
    if nextInput.lower() == "done": break
    nextInput = nextInput.replace("\"", "")
    paths.append(nextInput)

for path in paths:
    im = Image.open(path)
    rgb_im = im.convert('RGBA')
    width, height = im.size
    for x in range(width):
        for y in range(height):
            r,g,b,a = rgb_im.getpixel((x,y))
            if a == 0: continue
            im.putpixel((x,y), (processPixel(r, noiseAmount), processPixel(g, noiseAmount), processPixel(b, noiseAmount)))
    im.save(path)
    print("Done: " + path)

print("Okay everything is done bye bye")