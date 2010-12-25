import re, string
rec = re.compile("^#define\s+(?P<name>\w+)\s+(?P<key>\d+).*$", re.M)

qwerty = "1234567890qwertyuiopasdfghjklzxcvbnm"

xkeys = {65: "SPACE" , 113: "LEFT", 111:"UP", 116:"DOWN", 114: "RIGHT", 36: "ENTER", 22: "BACKSPACE", 32:"O",
    112:"PG_UP", 117:"PG_DOWN", 65:"SPACE", 135:"MENU", 9: "ESCAPE"}

offset = 10
for idx, letter in enumerate(qwerty):
    if letter == 'a':
        offset += 4
    elif letter == 'z':
        offset += 5
    elif letter == 'q':
        offset += 4
    xkeys[idx+offset] = letter

def parseKeys():
    keys = open("key.h")
    keyfile = keys.read()
    keys.close()
    return dict((iter.group('name'), iter.group('key')) for iter in rec.finditer(keyfile))


xboxkeys = parseKeys()
keymap = {"LEFT":"KEY_BUTTON_DPAD_LEFT", "UP": "KEY_BUTTON_DPAD_UP", "DOWN":"KEY_BUTTON_DPAD_DOWN",
            "RIGHT":"KEY_BUTTON_DPAD_RIGHT", "ENTER": "KEY_BUTTON_A", "SPACE": "0xF120",
            "BACKSPACE":"KEY_BUTTON_B", "MENU": "KEY_BUTTON_WHITE", "ESCAPE": "KEY_BUTTON_BACK"}

for letter in qwerty+string.ascii_uppercase:
    keymap[letter] = hex(0xF100 + ord(letter)).upper().replace("X", "x")

actionmap = {"O": "ACTION_SHOW_OSD_TIME", "PG_UP": "ACTION_SCROLL_UP", "PG_DOWN": "ACTION_SCROLL_DOWN",
        }

