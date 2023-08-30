# Include Python
FROM python:3.11.1-buster

# Define your working directory
WORKDIR /

# Install wget and git
RUN apt-get update && apt-get install -y wget git

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*
RUN pip install -v -r requirements.txt
RUN pip install gdown

# Copy all other files and directories
COPY . .

RUN gdown --id 12Qhp1wNRlhORZ2JO_HliL5pP1w-WNzpQ -O /epicrealism_naturalSinRC1VAE.safetensors

# Call your file when your container starts
CMD [ "python", "-u", "Diffusers.py" ]
