FROM python:3.11.5-alpine

COPY ./src /data/app/
COPY ./requirements.txt /data/

RUN python3 -m pip install -r /data/requirements.txt --no-cache-dir 

CMD ["python3", "/data/app/main.py"]
