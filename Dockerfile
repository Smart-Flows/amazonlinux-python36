FROM amazonlinux:2017.03

ENV PYTHON_VERSION 3.6.1

RUN yum update -y && \
    yum install gcc zlib zlib-devel openssl openssl-devel libffi libffi-devel wget zip -y && \
    yum clean all

RUN wget https://www.python.org/static/files/pubkeys.txt && \
    gpg --import pubkeys.txt; exit 0

RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz.asc && \
    gpg --verify Python-${PYTHON_VERSION}.tgz.asc && \
    tar -xvzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -fr Python-${PYTHON_VERSION}

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip3 install --no-cache-dir -r requirements.txt

ONBUILD COPY . /usr/src/app
