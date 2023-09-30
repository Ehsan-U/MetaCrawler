from crawler import MetaCrawler
from flask import Flask, jsonify, request
from logger import logger
from werkzeug.exceptions import NotFound

app = Flask(__name__)
crawler = MetaCrawler()

@app.route("/", methods=["POST"])
def index():
    logger.info("[+] Request")
    request_data = request.get_json()
    url = request_data.get("url")
    render = request_data.get("render", False)
    metadata = crawler.crawl(url, render)
    if not metadata:
        return jsonify({"msg":"No metadata found in the requested resource"}), 404
    else:
        return jsonify(metadata)



