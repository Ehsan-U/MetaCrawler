import requests
from settings import *
from logger import logger
from playwright.sync_api import sync_playwright
from dataclasses import dataclass
from typing import Union


@dataclass
class Response:
    status: int
    text: str


@dataclass
class Request:
    url: str
    render: bool


def fetch(request, headers=DEFAULT_HEADERS):
    try:
        url, render = (request.url, request.render)
        if render:
            logger.debug("Rendering")
            with sync_playwright() as play:
                page = play.chromium.launch(headless=True).new_page()
                page.goto(url)
                response = page.content()
                resp_obj = Response(status=200, text=response)
        else:
            response = requests.request("GET", url, headers=headers)
            resp_obj = Response(status=response.status_code, text=response.text)
        return resp_obj
    except Exception as e:
        logger.debug("Error while fetch")
        logger.error(e)