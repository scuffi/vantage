FROM python:3.8-slim-buster

RUN apt-get update &&\
    apt-get upgrade &&\
    apt-get install curl -y &&\
    apt-get install gcc -y &&\
    apt-get install xz-utils -y &&\
    apt-get install git -y

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

# RUN pip install nimporter

COPY . .

RUN nimble install nimpy --accept
RUN nimble install httpbeast
RUN nim c --threads:on --out:ex --d:release example.nim

CMD [ "python", "main.py" ]