## Graphite local_settings.py
# Edit this file to customize the default Graphite webapp settings
#
# Additional customizations to Django settings can be added to this file as well

from os import getenv, urandom

SECRET_KEY = getenv('SECRET_KEY', urandom(24).encode('hex'))

STORAGE_DIR = getenv('STORAGE_DIR')
CONTENT_DIR = getenv('CONTENT_DIR')


LOG_DIR = getenv('LOG_DIR')

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': 'INFO',
        },
        'graphite': {
            'handlers': ['console'],
            'level': 'INFO',
        },
    },
}

try:
    from graphite.custom_settings import *
except ImportError:
    pass
