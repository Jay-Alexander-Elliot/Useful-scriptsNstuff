
import requests
from bs4 import BeautifulSoup
import datetime

# Get the website URL
website_url = input("Enter the website URL: ")

# Get the criteria for links to extract
criteria = input("Enter the criteria for links to extract (e.g. '.pdf'): ")

# Send a request to the website
response = requests.get(website_url)

# Parse the HTML content
soup = BeautifulSoup(response.text, 'html.parser')

# Find all links that match the criteria
links = [link.get('href') for link in soup.find_all('a') if link.get('href') and criteria in link.get('href')]

# Create a filename using the website name and the current date
filename = website_url.split("//")[-1].replace("/", "_") + "_" + datetime.datetime.now().strftime("%Y%m%d") + ".txt"

# Write the links to the file
with open(filename, 'w') as file:
            for link in links:
                                    file.write(link + '\n')

                                    print(f"Links matching the criteria have been saved in the file '{filename}'.")




