FROM python:2.7-slim

MAINTAINER mateuszmoneta@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y\
        build-essential\
        libcairo2\
        libffi-dev\
        libpq-dev\
    && env READTHEDOCS=1 pip install\
#        Django==1.11.3\
#        scandir==1.5\
#        python-memcached==1.58\
#        pytz==2017.2\
        graphite-web==1.1.3\
        whisper==1.1.3\
        gunicorn\
#        cairocffi==0.8.0\
        psycopg2-binary\
    && apt-get purge -y build-essential libffi-dev\
    && apt-get autoremove -y\
    && apt-get clean\
    && rm -rf /root/.cache /var/lib/apt/lists/*

ENV SETTINGS_DIR=/usr/local/lib/python2.7/site-packages/graphite\
    LOG_DIR=/var/log/graphite\
    STORAGE_DIR=/var/lib/carbon\
    DJANGO_SETTINGS_MODULE=graphite.settings\
    STATIC_ROOT=/usr/local/webapp/content\
    GRAPHITE_ROOT=/var/graphite\
    GRAPHITE_USER=graphite

COPY graphite.wsgi /wsgi.py
#COPY local_settings.py $SETTINGS_DIR/local_settings.py

RUN mkdir -p $LOG_DIR $STORAGE_DIR $GRAPHITE_ROOT\
    && useradd -m $GRAPHITE_USER\
    && chown -R $GRAPHITE_USER $LOG_DIR $STORAGE_DIR $STATIC_ROOT $GRAPHITE_ROOT

USER $GRAPHITE_USER
VOLUME $STORAGE_DIR
EXPOSE 8000

ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8000", "wsgi"]
