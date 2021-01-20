FROM python:3.6.12-alpine3.12
COPY entrypoint.sh /entrypoint.sh
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
ENTRYPOINT ["/entrypoint.sh"]
