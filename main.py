from crawler import MetaCrawler
from flask import Flask, jsonify, request

app = Flask(__name__)
crawler = MetaCrawler()

@app.route("/", methods=["POST"])
def index():
    request_data = request.get_json()
    url = request_data.get("url")
    render = request_data.get("render", False)
    metadata = crawler.crawl(url, render)
    return jsonify(metadata)



