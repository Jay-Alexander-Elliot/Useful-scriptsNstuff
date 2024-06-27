import os
from os import scandir, rename
from os.path import exists, join, splitext, expanduser
from shutil import move
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class FileMover:
    def __init__(self, source_dir, dest_dir_sfx, dest_dir_music, dest_dir_video, dest_dir_image, dest_dir_documents):
        self.source_dir = source_dir
        self.dest_dir_sfx = dest_dir_sfx
        self.dest_dir_music = dest_dir_music
        self.dest_dir_video = dest_dir_video
        self.dest_dir_image = dest_dir_image
        self.dest_dir_documents = dest_dir_documents

        self.file_types = {
            'audio': {
                'extensions': [".m4a", ".flac", ".mp3", ".wav", ".wma", ".aac"],
                'dest': self.dest_dir_music,
                'special_case': lambda name: self.dest_dir_sfx if 'SFX' in name or entry.stat().st_size < 10_000_000 else self.dest_dir_music
            },
            'video': {
                'extensions': [".webm", ".mpg", ".mp2", ".mpeg", ".mpe", ".mpv", ".ogg", ".mp4", ".mp4v", ".m4v", ".avi", ".wmv", ".mov", ".qt", ".flv", ".swf", ".avchd"],
                'dest': self.dest_dir_video
            },
            'image': {
                'extensions': [".jpg", ".jpeg", ".jpe", ".jif", ".jfif", ".jfi", ".png", ".gif", ".webp", ".tiff", ".tif", ".psd", ".raw", ".arw", ".cr2", ".nrw", ".k25", ".bmp", ".dib", ".heif", ".heic", ".ind", ".indd", ".indt", ".jp2", ".j2k", ".jpf", ".jpf", ".jpx", ".jpm", ".mj2", ".svg", ".svgz", ".ai", ".eps", ".ico"],
                'dest': self.dest_dir_image
            },
            'document': {
                'extensions': [".doc", ".docx", ".odt", ".pdf", ".xls", ".xlsx", ".ppt", ".pptx"],
                'dest': self.dest_dir_documents
            }
        }

        for dest_dir in [self.dest_dir_sfx, self.dest_dir_music, self.dest_dir_video, self.dest_dir_image, self.dest_dir_documents]:
            os.makedirs(dest_dir, exist_ok=True)

    def make_unique(self, dest, name):
        filename, extension = splitext(name)
        counter = 1
        while exists(f"{dest}/{name}"):
            name = f"{filename}({str(counter)}){extension}"
            counter += 1
        return name

    def move_file(self, dest, entry, name):
        if exists(f"{dest}/{name}"):
            unique_name = self.make_unique(dest, name)
            oldName = join(dest, name)
            newName = join(dest, unique_name)
            rename(oldName, newName)
        move(entry.path, dest)

    def scan_and_move_files(self):
        try:
            with scandir(self.source_dir) as entries:
                for entry in entries:
                    if entry.is_file():
                        self.check_file_type(entry)
        except Exception as e:
            logging.error(f"Failed to scan and move files: {e}")

    def check_file_type(self, entry):
        name = entry.name.lower()
        for file_type, config in self.file_types.items():
            if any(name.endswith(ext) for ext in config['extensions']):
                dest = config['special_case'](name) if 'special_case' in config else config['dest']
                self.move_file_by_type(entry, name, dest)
                break

    def move_file_by_type(self, entry, name, dest):
        self.move_file(dest, entry, name)
        logging.info(f"Moved file: {name} to {dest}")

# Set up the directories in the home directory
home_dir = expanduser("~")
source_dir = join(home_dir, "Downloads")

dest_dir_sfx = join(home_dir, "Music/SFX")
dest_dir_music = join(home_dir, "Music")
dest_dir_video = join(home_dir, "Videos")
dest_dir_image = join(home_dir, "Pictures")
dest_dir_documents = join(home_dir, "Documents")

# Create an instance of the FileMover class with the specified directories
file_mover = FileMover(source_dir, dest_dir_sfx, dest_dir_music, dest_dir_video, dest_dir_image, dest_dir_documents)

# Start the file moving process
file_mover.scan_and_move_files()
