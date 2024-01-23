
import os
import csv
import json
from pdfminer.pdfinterp import PDFResourceManager, PDFPageInterpreter
from pdfminer.converter import TextConverter
from pdfminer.layout import LAParams
from pdfminer.pdfpage import PDFPage
from io import StringIO

def pdf_to_text(pdf_file):
    resource_manager = PDFResourceManager()
    string_io = StringIO()
    converter = TextConverter(resource_manager, string_io, laparams=LAParams())
    interpreter = PDFPageInterpreter(resource_manager, converter)
    for page in PDFPage.get_pages(pdf_file, check_extractable=True):
        interpreter.process_page(page)
    text = string_io.getvalue()
    converter.close()
    string_io.close()
    return text

directory = '.'
for filename in os.listdir(directory):
    if filename.endswith('.pdf'):
        filepath = os.path.join(directory, filename)
        with open(filepath, 'rb') as pdf_file:
            text = pdf_to_text(pdf_file)
            # Write text file
            text_filename = os.path.splitext(filename)[0] + '.txt'
            text_filepath = os.path.join(directory, text_filename)
            with open(text_filepath, 'w') as text_file:
                text_file.write(text)
            # Write CSV file
            csv_filename = os.path.splitext(filename)[0] + '.csv'
            csv_filepath = os.path.join(directory, csv_filename)
            with open(csv_filepath, 'w', newline='') as csv_file:
                writer = csv.writer(csv_file)
                writer.writerow([text])
            # Write JSON file
            json_filename = os.path.splitext(filename)[0] + '.json'
            json_filepath = os.path.join(directory, json_filename)
            with open(json_filepath, 'w') as json_file:
                json.dump({'text': text}, json_file)



