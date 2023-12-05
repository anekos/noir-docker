FROM python:3.12.0-bullseye

WORKDIR /app/api

RUN pip install --upgrade pip setuptools

COPY noir_api-0.1.0-py3-none-any.whl /tmp/noir_api-0.1.0-py3-none-any.whl
RUN pip install /tmp/noir_api-0.1.0-py3-none-any.whl -t /app/api

ENV PYTHONPATH /app/api

CMD ["python", "bin/uvicorn", "noir_api.server.app:app", "--host", "0.0.0.0"]
