#!/usr/bin/env python
from telethon import TelegramClient, events
from importlib.resources import files
import os
import random
import sys

def main():
    dictionary = {}

    def keyfilter(key):
        ret = key.split(" ")[0].lower()
        ret = ret.replace("'", "")
        return ret

    datadir = files('elderbot')
    filelist = os.listdir(datadir)
    filelist.sort()
    for path in filelist:
        if path.endswith(".txt"):
            print(f"Loading file {path}")
            entry = []
            with open(os.path.join(datadir, path), "r") as f:
                for line in f:
                    if not line.startswith("#"):
                        entry.append(line[:-1])
            dictionary[path[:-4]] = entry

    api_id = 720317
    api_hash = "aa451ff9c81314ea255198cd170ee101"

    with open(sys.argv[1], 'r') as f:
        bottoken = f.read().strip()

    client = TelegramClient("TheElderBot", api_id, api_hash)

    print("Loaded")

    @client.on(events.NewMessage())
    async def handler(event):
        for key in dictionary:
            if keyfilter(event.message.message) == f"/{keyfilter(key)}":
                await event.respond(random.choice(dictionary[key]))
                break

    @client.on(events.InlineQuery)
    async def inlinehandler(event):
        response = []
        for key in dictionary:
            if len(response) >= 50:
                break
            if key.lower().startswith(event.text.lower()):
                response.append(event.builder.article(key, text=random.choice(dictionary[key])))
        if len(response) > 0:
            await event.answer(results=response)

    client.start(bot_token=bottoken)
    client.run_until_disconnected()
