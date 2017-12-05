#!/usr/bin/env python3

# This command line script parses a png file and outputs it as an array of
# string colors (approximated with euclidean distance) that is readable in
# pico8.

import argparse
import numpy as np
from scipy.misc import imread


def dist(pixel, color):
    s = 0
    for i in range(len(pixel)):
        s += np.power(pixel[i]-color[i], 2)
    return np.sqrt(s)

def closest_color(p):
    colors_rgb = [
                    (0,0,0),
                    (29,43,83),
                    (126,37,83),
                    (0,135,81),
                    (171,82,54),
                    (95,87,79),
                    (194,195,199),
                    (255,241,232),
                    (255,0,77),
                    (255,163,0),
                    (255,236,39),
                    (0,228,54),
                    (41,173,255),
                    (131,118,156),
                    (255,119,168),
                    (255,204,170)
                 ]
    closest_idx = 0
    cur_closest = float('inf')
    for c in colors_rgb:
        distance = dist(p, c)
        if distance < cur_closest:
            cur_closest = distance
            closest_idx = colors_rgb.index(c)

    return closest_idx

def convert(in_file, out_file):
    img = imread(in_file, mode='RGB')
    with open(out_file, 'w') as f:
        f.write("{\n")
        for line in img:
            f.write("\"")
            for pixel in line:
                p = closest_color(pixel)
                out = "{},"# if p > 9 else " {},"
                f.write(out.format(p))
            f.write("\",\n")
        f.write("}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='convert PNG file to parseable array of strings')
    parser.add_argument('--input', type=str,
                        help="input file name")
    parser.add_argument('--output', type=str, default='picture.txt',
                        help='output file name')

    args = parser.parse_args()

    convert(args.input, args.output)
