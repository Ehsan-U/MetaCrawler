import logging
import os.path
from settings import LOG_LEVEL

def setup_logger(log_file, log_level):
    logger = logging.getLogger("MetaLogger")
    logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    log_dir = os.path.join(os.getcwd(), "logs")
    if not os.path.exists(log_dir):
        os.mkdir(log_dir, mode=0o777)
    file_handler = logging.FileHandler(f"./logs/{log_file}.log", mode='w')
    match log_level:
        case "DEBUG":
            file_handler.setLevel(logging.DEBUG)
        case "INFO":
            file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    return logger

logger = setup_logger("Meta", LOG_LEVEL)