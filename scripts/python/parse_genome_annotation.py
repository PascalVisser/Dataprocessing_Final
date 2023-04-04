#! usr/bin/python3

"""
Python script that transform genome annotation file into usable .ggf file
"""

import getopt
import sys


def get_argv(argv):
    """Collect and process arguments"""
    input_file = ''
    output_file = ''
    try:
        options, argv = getopt.getopt(argv, 'hi:o:')
    except getopt.GetoptError:
        print('Error while reading argument. Call ParseGenomeAnnotation.py -h')
        sys.exit(2)
    if len(options) == 0:
        print('Error while reading argument. Call ParseGenomeAnnotation.py -h')
        sys.exit(2)
    for option, arg in options:
        if len(options) == 1:
            if option == '-h':
                print('ParseGenomeAnnotation.py sweeps unnecessarily long '
                      'attribute section of GFF3 file downloaded '
                      'from NCBI.')
                print('Usage: Parse_genome_annotation.py -i <input_file> -o <output_file>')
                sys.exit()
            else:
                print('Error while reading argument. Call ParseGenomeAnnotation.py -h')
                sys.exit(2)
        elif len(options) == 2:
            if option == '-i':
                if arg == '':
                    print('Error while reading argument. Call ParseGenomeAnnotation.py -h')
                    sys.exit(2)
                input_file = arg
                print('Input GFF3: ' + input_file)
            elif option == '-o':
                if arg == '':
                    print('Error while reading argument. Call ParseGenomeAnnotation.py -h')
                    sys.exit(2)
                output_file = arg
                print('Output GFF3: ' + output_file + '\n')
    return input_file, output_file


def parse_input(infile):
    """Parse input arguments"""
    try:
        with open(infile, 'r', encoding="UTF-8") as temp:
            temp2 = temp.readline()
            while temp2[0] == '#':
                temp2 = temp.readline()
            temp3 = [temp2] + temp.readlines()
            temp4 = []
        for i in temp3:
            temp4.append(i.split('\t'))
        accession = temp4[0][0]

    except FileNotFoundError:
        print('No such file or directory: ' + infile)
        sys.exit(2)
    return temp4, accession


def sweep_and_output(inputlist, accession, output_file):
    """Sweeps and creates output"""
    in_count = len(inputlist)
    out_count = 0
    with open(output_file, 'w', encoding="UTF-8") as output:
        for i in inputlist:
            try:
                if i[2] == 'CDS':
                    start, end, strand = i[3], i[4], i[6]
                    anno = get_id(i[8])
                    output.write('\t'.join([accession, 'RefSeq', 'CDS', start,
                                            end, '.', strand, '.', anno]) + '\n')
                    out_count += 1
            except IndexError:
                pass
    print(f'Read {in_count} lines from GFF3')
    print(f'{out_count} CDSs remained')


def get_id(attribute):
    """Get attribute ID"""
    attributes = attribute.split(';')
    attributes_dic = {}
    for i in attributes:
        attributes_dic[i.split('=')[0]] = i.split('=')[1]
    return attributes_dic['locus_tag']


def main():
    """Main executing func"""
    inputfile, outputfile = get_argv(sys.argv[1:])
    input_list, accession1 = parse_input(inputfile)
    sweep_and_output(input_list, accession1, outputfile)


if __name__ == "__main__":
    sys.exit(main())
