FROM python:3

WORKDIR /usr/src/app

COPY ./python ./

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "test.py" ]

