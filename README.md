# Jetson TX2 Image Detection with TensorRT

This project records the deployment process of a local image object detection pipeline on NVIDIA Jetson TX2.

The pipeline uses NVIDIA `jetson-inference`, CUDA, TensorRT, and SSD-Mobilenet-v2 to detect objects from local images and save annotated output images. It is designed for a Jetson TX2 environment without a camera, using local image files as input.

## Project Goal

- Set up an object detection environment on Jetson TX2
- Verify PyTorch, CUDA, and JetPack/L4T compatibility
- Build `jetson-inference` from source
- Run SSD-Mobilenet-v2 detection on local images
- Save annotated detection results
- Record common build issues and fixes

## Hardware and Software

| Item | Version |
| --- | --- |
| Device | NVIDIA Jetson TX2 |
| JetPack / L4T | R32.7.6 |
| Architecture | aarch64 |
| CUDA | 10.2 |
| Python | 3.6 |
| PyTorch | 1.10.0 |
| Inference backend | TensorRT |
| Input source | Local image files |

## Environment Check

```bash
python3 -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
nvcc --version
cat /etc/nv_tegra_release
ls /dev/video*
```

Observed result:

```text
PyTorch: 1.10.0
CUDA available: True
CUDA: 10.2
L4T: R32.7.6
Camera device: not required
```

## Build jetson-inference

```bash
git clone --recursive https://github.com/dusty-nv/jetson-inference
cd jetson-inference
mkdir build
cd build
cmake ../
make -j2
```

`make -j2` is recommended on Jetson TX2 to reduce memory pressure during compilation.

## Install Dependencies

During the build, several development packages may be required:

```bash
sudo apt update
sudo apt install -y \
  cmake \
  build-essential \
  git \
  pkg-config \
  python3-dev \
  python3-numpy \
  libpython3-dev \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  libgstreamer-plugins-bad1.0-dev \
  libsoup2.4-dev \
  libjson-glib-dev \
  libglew-dev \
  libglfw3-dev \
  libglm-dev \
  libgstrtspserver-1.0-dev \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  libjpeg-dev \
  libpng-dev
```

## Run Detection

Use the compiled binary directly:

```bash
cd ~/jetson-inference
./build/aarch64/bin/detectnet --network=ssd-mobilenet-v2 data/images/peds_0.jpg output.jpg
```

The first run may take a long time because TensorRT builds and optimizes the inference engine. Later runs are much faster because the engine is cached.

## Result

Example output from `peds_0.jpg`:

```text
detected obj 0 class #1 (person) confidence=0.984375
detected obj 1 class #1 (person) confidence=0.698242
detected obj 2 class #1 (person) confidence=0.975586
detected obj 3 class #1 (person) confidence=0.863281
```

Timing report:

```text
Pre-Process   CUDA   0.53402ms
Network       CUDA  19.68826ms
Post-Process  CUDA   1.46272ms
Visualize     CUDA  14.11216ms
Total         CUDA  35.79715ms
```

Approximate single-image throughput:

```text
1000 / 35.8 = 27.9 FPS
```

## File Transfer Between Windows and Jetson

From Windows to Jetson:

```powershell
scp <windows-path>\test.jpg <jetson-user>@<jetson-ip>:/home/<jetson-user>/jetson-inference/
```

From Jetson to Windows:

```powershell
scp <jetson-user>@<jetson-ip>:/home/<jetson-user>/jetson-inference/output.jpg <windows-output-path>\
```

## Notes

- Avoid spaces in the project path. A path such as `Jeston TX2/jetson-inference` may break internal download scripts.
- Recommended path: `~/jetson-inference` or `~/projects/jetson-inference`.
- If the Jetson cannot download models directly, download the model on a PC and transfer it with `scp`.
- OpenGL/X11 warnings can be ignored when saving output to an image file instead of displaying a window.

## Future Work

- Add batch image detection
- Export detection results to CSV or JSON
- Add custom image examples
- Add a simple web UI for local result preview
- Test more lightweight models on Jetson TX2
