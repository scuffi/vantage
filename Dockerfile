FROM python:3.8-slim-buster

RUN apt-get update &&\
    apt-get upgrade &&\
    apt-get install curl -y &&\
    apt-get install gcc -y &&\
    apt-get install xz-utils -y &&\
    apt-get install git -y &&\
    apt-get install liblmdb0

WORKDIR /root/
# RUN pip install choosenim_install
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
ENV PATH=/root/.nimble/bin:$PATH

WORKDIR /
# RUN curl https://nim-lang.org/choosenim/init.sh -sSf -y | sh
# RUN apt-get update &&\
#     apt-get upgrade &&\
#     apt-get install nim -y

RUN pip install --upgrade pip

RUN pip install nimporter

RUN pip install lmdbm

COPY . .

# Allows Python calling of Nim objects
RUN nimble install nimpy --accept

# Install the Nim backend
RUN nimble install httpbeast
RUN nimble install schedules

# Test: Key-value database to get endpoints and redirects, 1st is official package, second looks easier to use lol
# RUN nimble install lmdb
RUN nimble install https://github.com/capocasa/limdb

# RUN nim c --threads:on --out:src/example.so --d:release --app:lib src/example.nim

CMD [ "python", "main.py" ]