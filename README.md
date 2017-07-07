# docker-graphite-web #
Minimal image based on python:2.7.12-slim with graphite-web server running.

## Base usage ##
```
docker run -p 80:8000 mateuszm/graphite-web
```

## Configuration ##
You can configure `STORAGE_DIR` and `LOG_DIR` via environment variables with 
same names. If you need some not standard configuration copy your own 
settings:

```
COPY custom_settings.py $SETTINGS_DIR/custom_settings.py
```

Image's entrypoint always run Django migrations at startup.

Note that you need proper web server (e.g. containerized nginx) to serve
Graphite's static files (`/var/graphite`).

## Base compose file to run minimal graphite stack ##

```yaml
version: '2'

services:
   cache:
       image: mateuszm/carbon-cache
       volumes:
         - storage:/var/lib/carbon/whisper
   web:
       image: mateuszm/graphite-web
       ports:
          - 80:8000
       volumes:
          - storage:/var/lib/carbon/whisper

volumes:
    storage:
        driver: local
```

## More complex setup with relay and aggregators daemon and postgres as db ##

```yaml
version: '2'

services:
   aggregator:
      image: mateuszm/carbon-aggregator
      links:
        - cache
      environment:
        DESTINATIONS: cache:2004
   cache:
       image: mateuszm/carbon-cache
       volumes:
         - storage:/var/lib/carbon/whisper
   relay:
       image: mateuszm/carbon-relay
       environment:
         DESTINATIONS: aggregator:2024
       links:
         - aggregator
   web:
       image: mateuszm/graphite-web:0.9.15-postgres
       environment:
          DATABASE_HOST: postgres
       volumes:
          - storage:/var/lib/carbon/whisper
          - /var/graphite:/var/graphite
       links:
          - postgres
   nginx:
        image: nginx
        ports:
          - 80:80
        volumes:
          - /var/graphite:/var/graphite
   postgres:
       image: postgres
       environment:
           POSTGRES_USER: graphite
           POSTGRES_PASSWORD: graphite
           POSTGRES_DB: graphite

volumes:
    storage:
        driver: local

```