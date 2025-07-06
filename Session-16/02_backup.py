import shutil
import os

from datetime import datetime
source="D:/important_data"
backup_dir="D:/backups"
timestamp=datetime.now().strftime("%Y%m%d_%H%M%S")
backup_file=os.path.join(backup_dir,f"backups_{timestamp}.zip")
shutil.make_archive(backup_file.replace('.zip',''),'zip',source)
print(f"Backup created at: {backup_file}")