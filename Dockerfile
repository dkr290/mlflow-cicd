FROM python:3.9
RUN apt update && apt install -y python3-venv gcc
RUN apt-get install -y python3-dev build-essential

ENV VENV=/.venv/myenv
RUN python3 -m venv ${VENV}
RUN mkdir -p $VENV/src
ENV PATH=$VENV/bin:$PATH
RUN pip install -U pip
RUN pip install psycopg2 mlflow==1.28.0 azure-storage-blob

# Expose the port that the MLFlow tracking server runs on
EXPOSE 5000
# Default database credentials
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_NAME
ARG DB_URL
ARG DEFAULT_ARTIFACT_ROOT
ENV DB_USERNAME=$DB_USERNAME
ENV DB_PASSWORD=$DB_PASSWORD
ENV DB_URL=$DB_URL:5432
ENV DB_NAME=$DB_NAME
ENV DEFAULT_ARTIFACT_ROOT=$DEFAULT_ARTIFACT_ROOT

ENTRYPOINT mlflow server \
        --default-artifact-root  $DEFAULT_ARTIFACT_ROOT \
        --backend-store-uri postgresql://$DB_USERNAME:$DB_PASSWORD@$DB_URL/$DB_NAME --host 0.0.0.0