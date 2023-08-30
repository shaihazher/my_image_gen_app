# Include Python
FROM python:3.11.1-buster

# Define your working directory
WORKDIR /

# Install wget
RUN apt-get update && apt-get install -y wget

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*
RUN pip install -v -r requirements.txt

# Copy all other files and directories
COPY . .

RUN wget -O /epicrealism_naturalSinRC1VAE.safetensors https://drive.google.com/file/d/12Qhp1wNRlhORZ2JO_HliL5pP1w-WNzpQ/view?usp=drive_link

RUN wget -O /GFPGAN/weights/detection_Resnet50_Final.pth https://drive.google.com/file/d/1pQXZl-0qLDCy1hC0wVvvEEwJtPtr-ODu/view?usp=drive_link

RUN wget -O /GFPGAN/weights/parsing_parsenet.pth https://drive.google.com/file/d/1_vUNbqM5v6cbPVVh8KUCKeD3xTdtaPdv/view?usp=drive_link

RUN wget -O /GFPGAN/experiments/pretrained_models/GFPGANv1.3.pth https://drive.google.com/file/d/1_vUNbqM5v6cbPVVh8KUCKeD3xTdtaPdv/view?usp=drive_link

RUN wget -O /GFPGAN/gfpgan/weights/GFPGANv1.3.pth https://drive.google.com/file/d/1_vUNbqM5v6cbPVVh8KUCKeD3xTdtaPdv/view?usp=drive_link

# Call your file when your container starts
CMD [ "python", "-u", "Diffusers.py" ]
