import shutil
import os
from pathlib import Path

SAVE_DIR = "merged"
TS_DIR = "ts_files"
CNT = 6

PATH = os.path.join(os.getcwd(), TS_DIR)

for i in range(1, CNT + 1):
    paths = list(Path(os.path.join(PATH, str(i))).rglob("*.ts"))
    with open(os.path.join(os.getcwd(), f"merged_{i}.ts"), "wb") as merged:
        for ts_file in paths:
            with open(ts_file, "rb") as mergefile:
                shutil.copyfileobj(mergefile, merged)
