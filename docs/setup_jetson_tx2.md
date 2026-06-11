# Jetson TX2 Setup Notes

This document records the setup process used to run local image object detection on Jetson TX2.

## 1. Verify System Environment

```bash
python3 -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
nvcc --version
cat /etc/nv_tegra_release
hostname -I
```

Expected environment:

```text
PyTorch 1.10.0
torch.cuda.is_available(): True
CUDA 10.2
L4T R32.7.6
```

## 2. Build Dependencies

Install the required development packages:

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

## 3. Build jetson-inference

```bash
git clone --recursive https://github.com/dusty-nv/jetson-inference
cd jetson-inference
mkdir build
cd build
cmake ../
make -j2
```

## 4. Run Local Image Detection

```bash
cd ~/jetson-inference
./build/aarch64/bin/detectnet --network=ssd-mobilenet-v2 data/images/peds_0.jpg output.jpg
```

## 5. Copy Output Back to Windows

```powershell
scp <jetson-user>@<jetson-ip>:/home/<jetson-user>/jetson-inference/output.jpg <windows-output-path>\
```

## 6. Performance Result

The tested image was `peds_0.jpg`.

```text
Detected objects: 4 persons
Total CUDA time: 35.79715 ms
Approx FPS: 27.9
```
