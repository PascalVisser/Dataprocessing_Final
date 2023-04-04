#! usr/bin/env python3

"""
Script for generating ribo seq profiles
"""

import getopt
import sys


def get_argv(argv):
    """receives and processes arguments"""
    input_file = ""
    end = ""
    acc = ""
    norm = ""
    output_file = ""

    try:
        options, arguments = getopt.getopt(argv, 'hi:e:a:n:o:')
    except getopt.GetoptError:
        print('Error while reading arguments. GenerateProfile.py -h')
        sys.exit(2)
    if len(options) == 0:
        print('Error while reading arguments. GenerateProfile.py -h')
        sys.exit(2)
    for option, arg in options:
        if len(options) == 1:
            if option == '-h':
                print('Generate genome-wide RiboSeq profile by user-selected read end.')
                print(
                    'Usage: GenerateProfile.py -i <input BED file> -e '
                    '<end, either 5 or 3> -n <normalization factor> -o <output file>')
                sys.exit()
            else:
                print('Error while reading arguments. GenerateProfile.py -h')
                sys.exit(2)
        elif len(options) == 5:
            if option == '-i':
                if arg == '':
                    print('Error while reading arguments. GenerateProfile.py -h')
                    sys.exit(2)
                input_file = arg
                print('Input BED: ' + input_file)
            elif option == '-e':
                if arg == '':
                    print('Error while reading arguments. GenerateProfile.py -h')
                    sys.exit(2)
                print("args end of the reads will be used")
                end = arg
            elif option == '-a':
                if arg == '':
                    print('Error while reading arguments. GenerateProfile.py -h')
                    sys.exit(2)
                acc = arg
            elif option == '-n':
                if arg == '':
                    print('Error while reading arguments. GenerateProfile.py -h')
                    sys.exit(2)
                norm = arg
            elif option == '-o':
                if arg == '':
                    print('Error while reading arguments. GenerateProfile.py -h')
                    sys.exit(2)
                output_file = arg
                print('Output file: ' + output_file)

    return input_file, end, acc, norm, output_file


def generate_profile(infile, end):
    """Generates ribo seq profile"""
    profile = {}
    read_numbers = 0
    if end == '5':
        try:
            with open(infile, encoding="UTF-8") as temp:
                for i in temp:
                    read_numbers += 1
                    j = i.split('\n')[0].split('\t')
                    if j[5] == '+':
                        try:
                            profile[j[5] + str(int(j[1]) + 1)] += 1
                        except:
                            profile[j[5] + str(int(j[1]) + 1)] = 1
                    else:
                        try:
                            profile[j[5] + j[2]] += 1
                        except:
                            profile[j[5] + j[2]] = 1

        except FileNotFoundError:
            print('No such file or directory: ' + infile)
            sys.exit(2)

    elif end == '3':
        try:
            with open(infile, encoding="UTF-8") as temp:
                for i in temp:
                    read_numbers += 1
                    j = i.split('\n')[0].split('\t')
                    if j[5] == '+':
                        try:
                            profile[j[5] + j[2]] += 1
                        except:
                            profile[j[5] + j[2]] = 1
                    else:
                        try:
                            profile[j[5] + str(int(j[1]) + 1)] += 1
                        except:
                            profile[j[5] + str(int(j[1]) + 1)] = 1
        except FileNotFoundError:
            print('No such file or directory: ' + infile)
            sys.exit(2)

    else:
        print('Wrong read end. Select either 5 or 3')
        sys.exit(2)
    return profile, float(read_numbers)


def get_accession(infile):
    """get accession from input file"""
    try:
        with open(infile, encoding="UTF-8") as input_file:
            for item in range(10):
                temp = input_file.readline()
            accession = temp.split('\t')[0]
            input_file.close()

    except FileNotFoundError:
        print('No such file or directory: ' + infile)
        sys.exit(2)
    return accession


def print_profile(gen_profile, sample, acc, outfile, norm, read_num):
    """Print the profile"""
    temp_dic = {'+': sample + '_F', '-': sample + '_R'}
    prefix = [acc, 'STATR']
    suffix = ['.', '.\n']
    if norm == 'N':
        try:
            with open(outfile, 'w', encoding="UTF-8") as temp:
                for pos, score in gen_profile.items():
                    strand = pos[0]
                    line = prefix + [temp_dic[strand], pos[1:], pos[1:],
                                     strand + str(score), strand] + suffix
                    temp.write('\t'.join(line))
        except:
            print('No such file or directory: ' + outfile)
            sys.exit(2)
    else:
        try:
            norm2 = float(norm)

            nfactor = read_num / norm2
            try:
                with open(outfile, 'w', encoding="UTF-8") as temp:
                    for pos, score in gen_profile.items():
                        strand = pos[0]
                        line = prefix + [temp_dic[strand], pos[1:], pos[1:],
                                         strand + str(round(float(score) / nfactor, 2)),
                                         strand] + suffix
                        temp.write('\t'.join(line))
            except:
                print('No such file or directory: ' + outfile)
                sys.exit(2)

        except:
            print('Wrong normalization paramter.')
            sys.exit(2)

    return True


args = get_argv(sys.argv[1:])
new_profile, new_read_num = generate_profile(args[0], args[1])
print_profile(new_profile, args[0][:-4], get_accession(args[2]), args[4], args[3], new_read_num)
del new_profile
