FROM ${ARCH}alpine:3.19
WORKDIR /app
COPY checkkarlmarx.py requirements.txt androidtemplate.html iostemplate.html ./

RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl \
    && apk add --no-cache unzip \
    && apk add --no-cache openjdk8-jre \
    && apk add --no-cache bash \
    && apk add --no-cache python3

RUN rm /usr/lib/python3.*/EXTERNALLY-MANAGED \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && pip3 install --no-cache-dir -r requirements.txt \
    && rm -r /usr/lib/python*/ensurepip \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi \
    && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    && rm -r /root/.cache

RUN curl -L -o /usr/local/bin/apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.5.0.jar \
    && curl -L -o /usr/local/bin/apktool https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool \
    && chmod +x /usr/local/bin/apktool.jar /usr/local/bin/apktool

RUN curl -LO https://dl.google.com/android/repository/build-tools_r29.0.2-linux.zip \
    && unzip build-tools_r29.0.2-linux.zip -d build-tools \
    && mv build-tools/android-10/* /usr/local/bin/ \
    && rm -f build-tools_r29.0.2-linux.zip \
    && rm -rf build-tools \
    && chmod +x /usr/local/bin/aapt

ENTRYPOINT ["python", "checkkarlmarx.py"]