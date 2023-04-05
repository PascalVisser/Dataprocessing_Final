#! usr/bin/env python3


"""
Merge and re-format the read count into a single
file that can be analyzed by the DESeq2 package.
"""

import getopt
import os.path
import sys
import argparse


def read_coverage(infile):
    """Read the mapped coverage"""
    try:
        temp_dic = {}
        with open(infile, encoding="UTF-8") as temp:
            for i in temp:
                j = i.split('\t')
                temp_dic[j[8]] = j[9]

    except FileNotFoundError:
        print('No such file or directory: ' + infile)
        sys.exit(2)

    return temp_dic


def write_coverage(outfile, coverages, order):
    """Write the coverage to a file"""
    CDSs = list(coverages[order[0]].keys())
    CDSs.sort()
    try:
        with open(outfile, 'w', encoding="UTF-8") as temp:
            temp.write('\t'.join(['GI', ] + [i.split('/')[-1][:-4] for i in order]))
            temp.write('\n')
            for CDS in CDSs:
                temp.write(CDS)
                for sample in order:
                    temp.write('\t' + coverages[sample][CDS])
                temp.write('\n')

    except FileNotFoundError:
        print('No such file or directory: ' + outfile)
        sys.exit(2)

    return False


def main():
    """execute functions and collect inputs"""

    parser = argparse.ArgumentParser(description="Merge/format expression level "
                                                 "counts from multiple samples")

    parser.add_argument("-i", "--input", help="Input files to merge", required=True, metavar="", nargs="+", type=str)
    parser.add_argument("-o", "--output", help="output path", required=True, metavar="", nargs=1)

    args = parser.parse_args()
    output = " ".join(args.output)

    coverages_x = {}
    for samples in args.input:
        coverages_x[samples] = read_coverage(samples)

    write_coverage(output, coverages_x, args.input)

    return 0


if __name__ == "__main__":
    sys.exit(main())
