# aind-disrnn-pipeline

Core pipeline to scale experiments for the AIND-disRNN project.

<img width="1291" height="812" alt="image" src="https://github.com/user-attachments/assets/bfd4c2a1-7936-4399-ac0c-8b65a8e76778" />

AIND-disRNN Dispatcher: [GitHub](https://github.com/AllenNeuralDynamics/aind-disrnn-dispatcher), [CO capsule](https://codeocean.allenneuraldynamics.org/capsule/7242130/tree)

AIND-disRNN Wrapper: [GitHub](https://github.com/AllenNeuralDynamics/aind-disrnn-wrapper), [CO capsule](https://codeocean.allenneuraldynamics.org/capsule/5421561/tree?cw=true)


## Usage
In the [pipeline](https://codeocean.allenneuraldynamics.org/capsule/7873787/tree), enter the Hydra CLI override in the app panel, for example<br>`-m model.penalties.beta=0.0001,0.001,0.01 model.training.n_steps=100 model.training.n_warmup_steps=50` 

<img width="400" src="https://github.com/user-attachments/assets/46ee9325-186f-45ca-b3a5-d37aa517c619" />

Hit "Run", and you'll get results in CO asset (computation id `c4808a41-d686-4458-830e-a11d4d19ddb7`)

<img width="300" alt="image" src="https://github.com/user-attachments/assets/cc775d15-5a84-4df3-b165-fa52df59e7cf" />

Logging and visualization in W&B

<img width="2486" height="1052" alt="image" src="https://github.com/user-attachments/assets/cbee0f0a-358d-469e-88f0-c5d3fd038ea9" />
