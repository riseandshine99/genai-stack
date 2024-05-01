FROM langchain/langchain

# Update sources.list to use Bullseye
RUN echo "deb http://deb.debian.org/debian/ bullseye main" > /etc/apt/sources.list \
    && echo "deb http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list \
    && echo "deb http://deb.debian.org/debian/ bullseye-updates main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN pip install --upgrade -r requirements.txt

HEALTHCHECK CMD curl --fail http://localhost:8504
ENTRYPOINT [ "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8504" ]