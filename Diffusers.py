import torch
from diffusers import StableDiffusionPipeline
from diffusers import StableDiffusionXLPipeline
from diffusers import DDIMScheduler, EulerAncestralDiscreteScheduler, DPMSolverMultistepScheduler
import runpod
import subprocess
#import nest_asyncio
import base64
from PIL import Image
from io import BytesIO
#nest_asyncio.apply()

pipe = StableDiffusionPipeline.from_single_file("epicrealism_naturalSinRC1VAE.safetensors", 
                                                   safety_checker = None, requires_safety_checker = False, 
                                                   use_safetensors=True, custom_pipeline="lpw_stable_diffusion")
#pipe.unet.load_attn_procs(lora_path)
pipe = pipe.to("cuda")
pipe.enable_attention_slicing()

pipe.load_textual_inversion("UnrealisticDream.pt")
#pipe.scheduler.config["use_karras_sigmas"] = True
pipe.scheduler = EulerAncestralDiscreteScheduler.from_config(pipe.scheduler.config)
pipe.safety_checker = None
pipe.requires_safety_checker = False
def gen_image(jobs):
    job_input = jobs["input"]
    
    prompt = job_input["prompt"]
    negative_prompt = ""

    #nprompt = """UnrealisticDream {neg}"""
    nprompt = "ugly, deformed, noisy, blurry, distorted, grainy"
    pprompt = """Portrait photo of (Breathtaking) wet and (curvy) Kerala woman with (plump big belly:1.2) in rainy beach, 
    wearing (wet) saree, 
    {pos}, with cleavage and (curvy fat hips) exposed"""
    negative_prompt = nprompt.format(neg = negative_prompt)
    prompt = pprompt.format(pos = prompt)

        #protovision - 896x1152 and nightvision 832x1216
    image = pipe(prompt= prompt, negative_prompt=negative_prompt, num_images_per_prompt = 1, 
                 guidance_scale = 3, height = 1216, width = 832, num_inference_steps=35).images
    
    image[0].save(str(job_input["id"])+".png")
    img_name = str(job_input["id"])+".png"

    cmd = ['python', 'GFPGAN/inference_gfpgan.py', '-i', img_name, '-o', 'results', '-v', '1.3', '-s', '2']

    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        return f"Oops! Something went wrong: {e}"

    # Open image file
    with open("results/restored_imgs"+img_name, "rb") as image_file:
        # Read the file
        image_data = image_file.read()

        # Encode as base64
        base64_image = base64.b64encode(image_data).decode("utf-8")

    # Now, `base64_image` contains the base64 string representation of your image


    return base64_image

runpod.serverless.start({"handler": gen_image})




