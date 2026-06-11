# Sample Result

Test image:

```text
data/images/peds_0.jpg
```

Command:

```bash
./build/aarch64/bin/detectnet --network=ssd-mobilenet-v2 data/images/peds_0.jpg output.jpg
```

Detection result:

```text
detected obj 0 class #1 (person) confidence=0.984375
detected obj 1 class #1 (person) confidence=0.698242
detected obj 2 class #1 (person) confidence=0.975586
detected obj 3 class #1 (person) confidence=0.863281
```

Performance:

```text
Pre-Process   CUDA   0.53402ms
Network       CUDA  19.68826ms
Post-Process  CUDA   1.46272ms
Visualize     CUDA  14.11216ms
Total         CUDA  35.79715ms
```

Approximate FPS:

```text
27.9 FPS
```
