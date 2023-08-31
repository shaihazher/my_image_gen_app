# Include Python
FROM python:3.11.1-buster

# Define your working directory
WORKDIR /

# Install wget, git, and unzip
RUN apt-get update && apt-get install -y wget git unzip

# Create cache directory
RUN mkdir -p /root/.cache/huggingface

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*
RUN pip install -v -r requirements.txt
RUN pip install gdown

# Download and unzip the cached models from Google Drive
RUN gdown --id 1ZQFB3p2O0GoVOCVtKiw_7qkAp_rSZmaE -O /tmp/hub.zip
RUN unzip /tmp/hub.zip -d /root/.cache/huggingface
RUN rm /tmp/hub.zip

# Copy all other files and directories
COPY . .

# Download any additional files you need
RUN gdown --id 12Qhp1wNRlhORZ2JO_HliL5pP1w-WNzpQ -O /epicrealism_naturalSinRC1VAE.safetensors

# Call your file when your container starts
CMD [ "python", "-u", "Diffusers.py" ]
