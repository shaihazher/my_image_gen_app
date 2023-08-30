# Include Python
FROM python:3.11.1-buster

# Define your working directory
WORKDIR /

# Install wget and git
RUN apt-get update && apt-get install -y wget git

# Clone GFPGAN and install its dependencies
RUN git clone https://github.com/TencentARC/GFPGAN.git
# Set permissions just in case
RUN mkdir -p /GFPGAN/weights && chmod 777 /GFPGAN/weights
RUN cd GFPGAN && \
    pip install basicsr && \
    pip install facexlib && \
    pip install -r requirements.txt && \
    python setup.py develop && \
    pip install realesrgan

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*
RUN pip install -v -r requirements.txt
RUN pip install gdown

# Copy all other files and directories
COPY . .

# Make your inference_gfpgan.py script executable
RUN chmod +x GFPGAN/inference_gfpgan.py

RUN gdown --id 12Qhp1wNRlhORZ2JO_HliL5pP1w-WNzpQ -O /epicrealism_naturalSinRC1VAE.safetensors
RUN gdown --id 1pQXZl-0qLDCy1hC0wVvvEEwJtPtr-ODu -O /GFPGAN/weights/detection_Resnet50_Final.pth
RUN gdown --id 1_vUNbqM5v6cbPVVh8KUCKeD3xTdtaPdv -O /GFPGAN/weights/parsing_parsenet.pth
RUN gdown --id 1_vUNbqM5v6cbPVVh8KUCKeD3xTdtaPdv -O /GFPGAN/experiments/pretrained_models/GFPGANv1.3.pth
RUN gdown --id 1_vUNbqM5v6cbPVVh8KUCKeD3xTdtaPdv -O /GFPGAN/gfpgan/weights/GFPGANv1.3.pth

# Call your file when your container starts
CMD [ "python", "-u", "Diffusers.py" ]
