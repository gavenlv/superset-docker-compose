FROM zlsmshoqvwt6q1.xuanyuan.run/apache/superset:latest

USER root

RUN /usr/local/bin/pip install --target /app/.venv/lib/python3.10/site-packages psycopg2-binary

USER superset
