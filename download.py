import asyncio
import aiohttp
import aiofiles
import os
import random

SAVE_DIR = "ts_files"
M3U8_DIR = "m3u8"
M3U8_CNT = 5

PATH = os.path.join(os.getcwd(), SAVE_DIR)
if not os.path.exists(PATH):
    os.mkdir(PATH)


async def download(session, url, cnt):
    try:
        async with session.get(url, ssl=False, timeout=10000) as resp:
            dir = os.path.join(PATH, cnt)

            if not os.path.exists(dir):
                os.mkdir(dir)

            path = os.path.join(dir, url[url.rfind("/") + 1 : url.rfind("?")])
            async with aiofiles.open(path, mode="wb") as f:
                while True:
                    try:
                        chunk = await resp.content.read(81920)
                    except:
                        break
                    if not chunk:
                        break
                    await f.write(chunk)
    except:
        print("ERROR ", url, cnt)
        return


async def main():
    connector = aiohttp.TCPConnector(force_close=True, limit=5)
    async with aiohttp.ClientSession(connector=connector, trust_env=True) as session:
        tasks = []
        for i in range(1, M3U8_CNT + 1):
            with open(os.path.join(os.getcwd(), M3U8_DIR, f"{i}.m3u8"), "r") as file:
                urls = [l for l in file if l.startswith("https")]

            tasks.extend([asyncio.ensure_future(download(session, url, str(i))) for url in urls])
        random.shuffle(tasks)
        await asyncio.gather(*tasks)


asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
asyncio.run(main())
