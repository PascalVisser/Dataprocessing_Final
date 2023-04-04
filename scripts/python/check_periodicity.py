#! usr/bin/python3

"""
Script that creates meta analysis data of created .bed files
"""

import getopt
import sys
import time

t1 = time.time()


def get_argv(argv):
    """receives and process input arguments"""
    input_file = ""
    annotation_x = ""
    output_file = ""

    try:
        options, args = getopt.getopt(argv, 'hi:a:o:')
    except getopt.GetoptError:
        print('Error while reading arguments. Call CheckPeriodicity.py -h')
        sys.exit(2)
    if len(options) == 0:
        print('Error while reading arguments. Call CheckPeriodicity.py -h')
        sys.exit(2)
    for option, arg in options:
        if len(options) == 1:
            if option == '-h':
                print('Check Ribo_Seq integrity by periodicity.')
                print('Usage: CheckPeriodicity.py -i <input BED file> -a '
                      '<annotation GFF file> -o <output file>')
                sys.exit()
            else:
                print('Error while reading arguments. Call CheckPeriodicity.py -h')
                sys.exit(2)
        elif len(options) == 3:
            if option == '-i':
                if arg == '':
                    print('Error while reading arguments. Call CheckPeriodicity.py -h')
                    sys.exit(2)
                input_file = arg
                print('Input BED: ' + input_file)
            elif option == '-a':
                if arg == '':
                    print('Error while reading arguments. Call CheckPeriodicity.py -h')
                    sys.exit(2)
                annotation_x = arg
                print('Input annotation: ' + annotation_x)
            elif option == '-o':
                if arg == '':
                    print('Error while reading arguments. Call CheckPeriodicity.py -h')
                    sys.exit(2)
                output_file = arg
                print('Output file: ' + output_file)
    return input_file, annotation_x, output_file


def parse_annotation(file_in):
    """parse file annotations"""
    try:
        with open(file_in, encoding="UTF-8") as temporary:
            temporary_list = []
            for item in temporary:
                j = item.split('\n')[0].split('\t')
                temporary_list.append([j[3], j[4], j[6]])

    except FileNotFoundError:
        print('No such file or directory: ' + file_in)
        sys.exit(2)
    return temporary_list


def generate_profile(profile_file):
    """Generate profiles from file"""
    profile5, profile3 = {}, {}
    try:
        with open(profile_file, encoding="UTF-8") as temp:
            for pro in temp:
                j = pro.split('\n')[0].split('\t')
                if j[5] == '+':
                    try:
                        profile5[j[5] + str(int(j[1]) + 1)] += 1
                    except:
                        profile5[j[5] + str(int(j[1]) + 1)] = 1
                    try:
                        profile3[j[5] + j[2]] += 1
                    except:
                        profile3[j[5] + j[2]] = 1
                else:
                    try:
                        profile5[j[5] + j[2]] += 1
                    except:
                        profile5[j[5] + j[2]] = 1
                    try:
                        profile3[j[5] + str(int(j[1]) + 1)] += 1
                    except:
                        profile3[j[5] + str(int(j[1]) + 1)] = 1
    except FileNotFoundError:
        print('No such file or directory: ' + infile)
        sys.exit(2)
    return profile5, profile3


def calculate_density(profile, CDS):
    if CDS[2] == '+':
        ranges = range(int(CDS[0]) - 100, int(CDS[0]) + 301), \
            range(int(CDS[1]) - 300, int(CDS[1]) + 101)
    else:
        ranges = range(int(CDS[1]) + 100, int(CDS[1]) - 301, -1), \
            range(int(CDS[0]) + 300, int(CDS[0]) - 101, -1)

    temp = []
    count, num_reads = -100, 0
    for pos in ranges[0]:
        try:
            temp.append(profile[CDS[2] + str(pos)])
            num_reads += profile[CDS[2] + str(pos)]
        except:
            temp.append(0)
        count += 1
    if num_reads < 100:
        return None
    else:
        temp2 = [round(float(i) / float(max(temp)), 4) for i in temp]
        return temp2


def average_density(end_5p, end_3p):
    master_5p, master_3p = [], []
    for pos in range(0, 401, 1):
        pos_sum = 0
        for CDS in end_5p:
            pos_sum += CDS[pos]
        master_5p.append(round(pos_sum / len(end_5p), 4))
        pos_sum = 0
        for CDS in end_3p:
            pos_sum += CDS[pos]
        master_3p.append(round(pos_sum / len(end_3p), 4))
    return master_5p, master_3p


infile, annot, outfile = get_argv(sys.argv[1:])

annotation = parse_annotation(annot)
profiles = generate_profile(infile)

end_5p, end_3p = [], []
for CDS in annotation:
    if int(CDS[1]) - int(CDS[0]) > 300:
        temporary_x = calculate_density(profiles[0], CDS)
        if temporary_x is not None:
            end_5p.append(temporary_x)
        temporary_y = calculate_density(profiles[1], CDS)
        if temporary_y is not None:
            end_3p.append(temporary_y)

del profiles

avg_5p, avg_3p = average_density(end_5p, end_3p)

try:
    with open(outfile, 'w', encoding="UTF-8") as output:
        output.write('Position_relative_to_start_codon\t')
        output.write(f"5'_end_assigned (n={len(end_5p)})\t3'_end_assigned (n={len(end_3p)})\n")
        for i in range(401):
            output.write(f'{i - 100}\t{avg_5p[i]}\t{avg_3p[i]}\n')
except FileNotFoundError:
    print('No such file or directory: ' + outfile)
    sys.exit(2)

print('% sec' % round(time.time() - t1, 4))
