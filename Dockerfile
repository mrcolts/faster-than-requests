FROM nimlang/nim
RUN rm -rf /tmp/*
RUN : \
    && apt-get update -y --quiet \
    && apt-get install -y curl python3-pycurl wget python3-wget python3-pip \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip==18.1
RUN pip3 install --upgrade requests==2.20.1
RUN pip3 install --upgrade urllib3==1.24.1
RUN nimble -y refresh
RUN nimble -y install nimpy@0.1.0
ADD src/faster_than_requests.nim /tmp/
ADD src/faster_than_requests_nossl.nim /tmp/
RUN nim c -d:release -d:ssl --app:lib --out:/tmp/faster_than_requests.so /tmp/faster_than_requests.nim
RUN nim c -d:release --app:lib --out:/tmp/faster_than_requests_nossl.so /tmp/faster_than_requests_nossl.nim
ADD server4benchmarks.nim /tmp/
RUN nim c -d:release /tmp/server4benchmarks.nim
ADD benchmark.py /tmp/
RUN rm -rf /var/tmp/* /tmp/nimblecache/ /tmp/*.nim
EXPOSE 5000
