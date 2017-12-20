import csv

# open file
with open('g:/ldl_project_stash/pintado/pintado_test.csv', 'r') as infile, open('g:/ldl_project_stash/pintado/pintado_output.csv', 'w', newline='') as outfile:
	reader = csv.reader(infile)
	writer = csv.writer(outfile)
	headers = next(reader, None)

	#read file row by row
	if headers:
		writer.writerow(headers)

	for row in reader:
		writer.writerow(row)
		identifier = row[0]
		directory = row[2]
		images = int(row[4])
		collection = row[6]
		source = row[7]
		relation = row[8]
		resourcetype = row[9]
		if images > 1:
			n = 1
			while n < images + 1:
				child = str(n)
				writer.writerow([identifier + '_%02d' % n,'%02d' % n, directory, '', '', 'Page ' + child, collection, source, relation, resourcetype])
				n = n + 1