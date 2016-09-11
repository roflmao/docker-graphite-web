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
