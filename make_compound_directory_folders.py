import os,csv

file = open('g:/ldl_project_stash/pintado/pintado_test.csv')
read_f = csv.reader(file)

for row in read_f: os.mkdir(row[0])