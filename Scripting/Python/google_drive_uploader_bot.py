import os
import google.auth
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# Specify the ID of the folder to upload files to (from the URL of the Drive folder)
folder_id = 'your_folder_id_here'

SCOPES = ['https://www.googleapis.com/auth/drive.file']

class GoogleDriveUploader:
    def __init__(self, folder_id, credentials_file='credentials.json', token_file='token.json'):
        self.folder_id = folder_id
        self.credentials_file = credentials_file
        self.token_file = token_file
        self.creds = self.create_connection()

    def create_connection(self):
        creds = None
        try:
            if os.path.exists(self.token_file):
                creds = Credentials.from_authorized_user_file(self.token_file, SCOPES)
            if not creds or not creds.valid:
                if creds and creds.expired and creds.refresh_token:
                    creds.refresh(Request())
                else:
                    flow = InstalledAppFlow.from_client_secrets_file(self.credentials_file, SCOPES)
                    creds = flow.run_local_server(port=0)
                with open(self.token_file, 'w') as token:
                    token.write(creds.to_json())
        except Exception as e:
            print(f"An error occurred while creating connection: {e}")
        return creds

    def upload_file(self, file_path, file_name):
        service = build('drive', 'v3', credentials=self.creds)
        try:
            file_media = MediaFileUpload(file_path, resumable=False)
            file_metadata = {
                'name': file_name,
                'parents': [self.folder_id]
            }
            file = service.files().create(
                body=file_metadata,
                media_body=file_media,
                fields='id'
            ).execute()
            print(f'File "{file_name}" uploaded to Google Drive with ID: {file.get("id")}')
        except HttpError as error:
            print(f'An error occurred while uploading file "{file_name}" to Google Drive: {error}')
            file = None
        return file

    def upload_files(self, directory_path):
        if not os.path.exists(directory_path):
            print(f"The directory {directory_path} does not exist.")
            return
        files = os.listdir(directory_path)
        for file_name in files:
            file_path = os.path.join(directory_path, file_name)
            if os.path.isfile(file_path):
                self.upload_file(file_path, file_name)

# Example usage
if __name__ == '__main__':
    # Fill in the path to the folder you want to upload files from (from your local computer)
    directory_path = 'your_directory_path_here'
    uploader = GoogleDriveUploader(folder_id)
    uploader.upload_files(directory_path)
