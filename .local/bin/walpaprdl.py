import requests
import string
import os
import random



def wallpaper_search_api(query):
    url = f"https://wallhaven.cc/api/v1/search?q={query}"
    res = requests.get(url)
    json_data = res.json()
    dwl_links = []

    for wallpaper in json_data["data"]:
        dwl_links.append(wallpaper["path"])
    return dwl_links


def generaterid():
    return (''.join(random.choices(string.ascii_lowercase+string.ascii_uppercase+string.digits, k = 6)))


def downld_wallpaper(url):
    print(f"Downloading . . . {url}")
    res = requests.get(url)
    wall_name = generaterid()
    ext = os.path.splitext(url)[1]
    dwl_path = f"/home/shiv/Shiv/wallpapers/{wall_name}{ext}"
    open(dwl_path, 'wb').write(res.content)


inp = input('Enter THEME: ')
walurl = wallpaper_search_api(inp)

for url in walurl:
    downld_wallpaper(url)
