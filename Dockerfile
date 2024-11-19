FROM python:3.12.7-alpine3.20
COPY entrypoint.sh /entrypoint.sh
COPY requirements.txt /requirements.txt
RUN /usr/local/bin/python -m pip install --upgrade pip && \
    pip install -r /requirements.txt
ENTRYPOINT ["/entrypoint.sh"]
