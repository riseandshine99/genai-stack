FROM langchain/langchain

# Change Debian mirror to a more reliable one
RUN sed -i 's/deb.debian.org/ftp.us.debian.org/g' /etc/apt/sources.list

WORKDIR /app

RUN apt-get update && apt-get --allow-unauthenticated install -y \
    build-essential \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade -r requirements.txt

COPY api.py .
COPY utils.py .
COPY chains.py .

HEALTHCHECK CMD curl --fail http://localhost:8504

ENTRYPOINT [ "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8504" ]