FROM langchain/langchain

# Recreate sources.list if it doesn't exist
RUN if [ ! -f /etc/apt/sources.list ]; then echo "deb http://ftp.us.debian.org/debian/ stretch main" > /etc/apt/sources.list; fi

RUN sed -i 's/deb.debian.org/ftp.us.debian.org/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y build-essential curl software-properties-common \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN pip install --upgrade -r requirements.txt

HEALTHCHECK CMD curl --fail http://localhost:8504
ENTRYPOINT [ "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8504" ]