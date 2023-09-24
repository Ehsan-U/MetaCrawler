import extruct
from typing import Union
from w3lib.html import get_base_url
from logger import logger
from utils import Response, Request, fetch


class MetaCrawler:

    def get_metadata(self, response: Response) -> Union[dict, None]:
        metadatas = {}
        if response:
            try:
                base_url = get_base_url(response.text)
                data = extruct.extract(response.text, base_url)
                for tg, tg_data in data.items():
                    if tg in ['microdata', 'json-ld'] and tg_data:
                        metadatas[tg] = tg_data
                return metadatas
            except Exception as e:
                logger.debug("Error in get_metadata")
                logger.error(e)

    def crawl(self, url: str, render: bool = False) -> Union[dict, None]:
        request = Request(url=url, render=render)
        response = fetch(request)
        metadata = self.get_metadata(response)
        return metadata

