import os

bind = f"0.0.0.0:{os.getenv('PORT', '5000')}"
workers = 2
threads = 4
timeout = 120
preload_app = True