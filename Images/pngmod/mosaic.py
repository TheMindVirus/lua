#pip install pillow
from PIL import Image

blocks = \
{
    ":red_square:":         (0xFF, 0x00, 0x00),
    ":green_square:":       (0x00, 0xFF, 0x00),
    ":blue_square:":        (0x00, 0x00, 0xFF),
    ":yellow_square:":      (0xFF, 0xFF, 0x00),
    ":orange_square:":      (0xFF, 0x77, 0x00),
    ":brown_square:":       (0x77, 0x00, 0x00),
    ":purple_square:":      (0x77, 0x00, 0xFF),
    ":white_large_square:": (0xFF, 0xFF, 0xFF),
    ":black_large_square:": (0x00, 0x00, 0x00),
}

def main():
    w, h = [16, 16]
    img = Image.open("img.png").resize((w, h), Image.Resampling.NEAREST).getdata()
    data = ""

    col = 1
    for pixel in img:
        block = rgb2block(pixel)
        data += str(block)
        if col >= w:
            data += "\n"
            col = 0
        col += 1

    with open("txt.txt", "w") as file:
        file.write(data)
    print(data)
    print("Done!")

def rgb2block(rgb):
    block = ""
    size = len(blocks)
    diff = [0] * size
    idx = 0
    for c in blocks:
        diff[idx] = abs(blocks[c][0] - rgb[0]) \
                  + abs(blocks[c][1] - rgb[1]) \
                  + abs(blocks[c][2] - rgb[2])
        idx += 1
    minx = 765 # 255 * 3
    i = 0
    for c in blocks:
        if diff[i] < minx:
            minx = diff[i]
            block = c
        i += 1
    return block

if __name__ == "__main__":
    main()
