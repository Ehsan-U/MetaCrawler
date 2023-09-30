FROM ubuntu:jammy

COPY . .

RUN apt update && apt install -y python3 \
    && apt install -y python3-pip && pip install -r requirements.txt \
    && playwright install chromium && playwright install-deps

CMD ["gunicorn", "-w", "4", "main:app", "-b", "0.0.0.0:80"]