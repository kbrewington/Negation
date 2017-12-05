import re
import glob

p8 = glob.glob("../src/*.p8")[0]

if __name__ == "__main__":
    with open(p8, 'r') as f:
        lines = f.readlines()
    with open("test.p8", 'w') as f:
        for line in lines:
            line = re.sub(re.compile("--[[.*?]]", re.DOTALL), "", line)
            line = re.sub(re.compile("--.*?\n"), "", line)
            f.write(line)
