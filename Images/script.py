from PIL import Image #C:\Python310>.\python.exe -m pip install pillow

def main():
    w, h = [320, 240]

    img = Image.open("img.jpg").resize((w, h), Image.Resampling.BOX).getdata()
    data = ""

    col = 1
    for pixel in img:
        wool = rgb2wool(pixel)
        data += (str(wool) + "\n")
        if col >= w:
            data += "\n"
            col = 0
        col += 1

    with open("img.txt", "w") as file:
        file.write(data)

    print("Done!")

def test():
    wool = rgb2wool([127, 127, 127])
    print(str(wool) + " - " + str(list(wools.keys())[wool]))

def rgb2wool(rgb):
    wool = 0
    size = len(wools)
    diff = [0] * size
    idx = 0
    for c in wools:
        diff[idx] = abs(wools[c][0] - rgb[0]) + abs(wools[c][1] - rgb[1]) + abs(wools[c][2] - rgb[2])
        idx += 1
    minx = 765 # 255 * 3
    for i in range(0, size):
        if diff[i] < minx:
            minx = diff[i]
            wool = i
    return wool

wools = \
{
    "white":         (255, 255, 255),
    "orange":        (255, 127,   0),
    "magenta":       (255,   0, 255),
    "light blue":    (  0, 255, 255),
    "yellow":        (255, 255,   0),
    "light green":   (127, 255, 127),
    "pink":          (255, 127, 255),
    "dark gray":     (100, 100, 100),
    "light gray":    (200, 200, 200),
    "cyan":          (  0, 127, 127),
    "purple":        (127,   0, 255),
    "blue":          (  0,   0, 255),
    "brown":         (127,   0,   0),
    "dark green":    (  0, 127,   0),
    "red":           (255,   0,   0),
    "black":         (  0,   0,   0),
}

if __name__ == "__main__":
    main()
    #test()
    
    


