import logging
import sys
import random
from telegram import Update
from telegram.ext import Application, CommandHandler, InlineQueryHandler, ContextTypes

async def snek(update, msg):
    pack = await update.get_bot().get_sticker_set('Sneksbot')
    sticker = random.choice(pack.stickers)
    await update.message.chat.send_sticker(sticker)

def main():
    logging.basicConfig(
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO
    )
    logging.getLogger('httpx').setLevel(logging.WARNING)
    logger = logging.getLogger(__name__)

    with open(sys.argv[1], 'r') as f:
        token = f.read().strip()

    app = Application.builder().token(token).build()
    app.add_handler(CommandHandler('snek', snek))
    app.run_polling(allowed_updates=Update.MESSAGE)
