from PIL import Image #C:\Python310>.\python.exe -m pip install pillow

def main():
    w, h = [300, 300]

    img = Image.open("img.png").resize((w, h), Image.Resampling.NEAREST).getdata()
    data = ""

    col = 1
    for pixel in img:
        wool = (pixel[0] << 16) + (pixel[1] << 8) + (pixel[2])
        data += (str(wool) + "\n")
        if col >= w:
            data += "\n"
            col = 0
        col += 1

    with open("img.txt", "w") as file:
        file.write(data)

    print("Done!")

if __name__ == "__main__":
    main()
