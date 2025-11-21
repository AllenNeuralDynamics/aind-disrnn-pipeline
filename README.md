# aind-disrnn-pipeline

Core pipeline to scale experiments for the AIND-disRNN project.

<img width="1291" height="812" alt="image" src="https://github.com/user-attachments/assets/bfd4c2a1-7936-4399-ac0c-8b65a8e76778" />

AIND-disRNN Dispatcher: [GitHub](https://github.com/AllenNeuralDynamics/aind-disrnn-dispatcher), [CO capsule](https://codeocean.allenneuraldynamics.org/capsule/7242130/tree)

AIND-disRNN Wrapper: [GitHub](https://github.com/AllenNeuralDynamics/aind-disrnn-wrapper), [CO capsule](https://codeocean.allenneuraldynamics.org/capsule/5421561/tree?cw=true)

## Credentials
You'll need a W&B API key to push your results to W&B:
1. Ask Han to invite you to the [AIND-disRNN team on W&B](https://wandb.ai/AIND-disRNN).
2. Copy your API key from `W&B - Account - API key`
3. First add your key to Code Ocean account: `Account - User Secrets - Add Secret - Custom key` <br>
   <img width="700" alt="image" src="https://github.com/user-attachments/assets/f3f587b7-cacd-483f-817b-0d7e7a10c6a6" />
4. Then attach the key to this pipeline: `Pipeline settings - Credentials` <br>
   <img width="500" alt="image" src="https://github.com/user-attachments/assets/8ce8365a-24ca-4729-ba52-6c017da097fe" />
5. You may also need to attach your Code Ocean API on the same page.

## Usage
In the [pipeline](https://codeocean.allenneuraldynamics.org/capsule/7873787/tree), enter the Hydra CLI override in the app panel, for example<br>`-m model.penalties.beta=0.0001,0.001,0.01 model.training.n_steps=100 model.training.n_warmup_steps=50` 

<img width="400" src="https://github.com/user-attachments/assets/46ee9325-186f-45ca-b3a5-d37aa517c619" />

Hit "Run", and you'll get results in CO asset (computation id `c4808a41-d686-4458-830e-a11d4d19ddb7`)

<img width="300" alt="image" src="https://github.com/user-attachments/assets/cc775d15-5a84-4df3-b165-fa52df59e7cf" />

Logging and visualization in W&B

<img width="2486" height="1052" alt="image" src="https://github.com/user-attachments/assets/cbee0f0a-358d-469e-88f0-c5d3fd038ea9" />

## Switching between CPU and GPU machines for the wrapper
Based on some [benchmark tests](https://wandb.ai/AIND-disRNN/han_cpu_gpu_test/reports/CPU-GPU-and-reproducibility--VmlldzoxNTEyNjg1OQ), we decided to use CPU machine for the wrapper by default.

To migrate from GPU to CPU, you should pull the latest wrapper and pipeline after [this PR](https://github.com/AllenNeuralDynamics/aind-disrnn-wrapper/pull/15) and [this PR](https://github.com/AllenNeuralDynamics/aind-disrnn-pipeline/pull/7) are merged.

If you want to switch between CPU/GPU machines in the future, follow these steps:
1. In the [DockerFile](https://github.com/AllenNeuralDynamics/aind-disrnn-wrapper/blob/d6ea4b135687edbd83b2037e165534c56d95f65a/environment/Dockerfile#L4-L10) of the wrapper capsule, uncomment the correct base image and jax version. 
```python
# --- Base image and Jax for CPU (preferred) ---
FROM $REGISTRY_HOST/codeocean/mambaforge3:24.5.0-0-python3.12.4-ubuntu22.04
ARG JAX_PKG="jax==0.6.1"

# --- Base image and Jax for GPU ---
# FROM $REGISTRY_HOST/codeocean/pytorch:2.4.0-cuda12.4.0-mambaforge24.5.0-0-python3.12.4-ubuntu22.04
# ARG JAX_PKG="jax[cuda12]==0.6.1"
```
2. In the pipeline, you should also check the machine resources. <br>
   <img width="300" alt="image" src="https://github.com/user-attachments/assets/14f73c2a-aa29-4a42-86a7-90c95022c1cb" />  <img width="500" alt="image" src="https://github.com/user-attachments/assets/8ff56a9d-6f03-4faa-adef-464377075725" /><br>
   For example, if you are using CPU machines, you should not see a "GPU" option there, and vice versa.
   
   However, there seems to be a bug that CO cannot automatically update the "Resources" field after you change the DockerFile of the capsule. A workaround is to add the same wrapper capsule to the pipeline like this<br>
   <img width="206" height="248" alt="image" src="https://github.com/user-attachments/assets/4d14928d-a680-470d-a03e-95bee8a4ec24" />   <img width="600" alt="image" src="https://github.com/user-attachments/assets/2734cfcd-bc59-4f49-ba2f-b095ba1106a8" />

   and it somehow forces CO to rethink whether it will need a GPU based on the DockerFile. Once this is done, you can remove the dummy wrapper capsule.

3. You'll need to do a Reproducible Run of the wrapper before you're able to trigger the pipeline with the new CPU/GPU setting.


