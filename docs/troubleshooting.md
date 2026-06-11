# Troubleshooting

This page records the build and runtime issues encountered during the Jetson TX2 deployment.

## `cmake: command not found`

Install CMake and build tools:

```bash
sudo apt update
sudo apt install -y cmake build-essential git
```

## `fatal error: gst/gst.h: No such file or directory`

Install GStreamer development packages:

```bash
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

## `fatal error: libsoup/soup.h: No such file or directory`

Install libsoup:

```bash
sudo apt install -y libsoup2.4-dev
```

## `fatal error: gst/webrtc/webrtc.h: No such file or directory`

Install the GStreamer bad plugin development package:

```bash
sudo apt install -y libgstreamer-plugins-bad1.0-dev
```

## `fatal error: json-glib/json-glib.h: No such file or directory`

Install json-glib:

```bash
sudo apt install -y libjson-glib-dev
```

## `fatal error: GL/glew.h: No such file or directory`

Install GLEW:

```bash
sudo apt install -y libglew-dev
```

## `fatal error: gst/rtsp-server/rtsp-server.h: No such file or directory`

Install the RTSP server development package:

```bash
sudo apt install -y libgstrtspserver-1.0-dev
```

## `/usr/bin/ld: cannot find -lnpymath`

Reinstall NumPy and expose the NumPy math library path:

```bash
sudo apt install --reinstall -y python3-numpy
find /usr -name "libnpymath*"
export LIBRARY_PATH=/usr/lib/python3/dist-packages/numpy/core/lib:$LIBRARY_PATH
```

Then rerun:

```bash
cmake ../
make -j2
```

## Internal model download fails because the path contains spaces

Avoid project paths such as:

```text
/home/<jetson-user>/Documents/Jeston TX2/jetson-inference
```

Use:

```text
/home/<jetson-user>/jetson-inference
```

## Jetson cannot download model files

Download the model on a PC and transfer it to Jetson:

```powershell
scp "$env:USERPROFILE\Downloads\SSD-Mobilenet-v2.tar.gz" <jetson-user>@<jetson-ip>:/home/<jetson-user>/jetson-inference/build/aarch64/bin/networks/
```

Then extract it on Jetson:

```bash
cd ~/jetson-inference/build/aarch64/bin/networks
tar -xzvf SSD-Mobilenet-v2.tar.gz
rm SSD-Mobilenet-v2.tar.gz
```

## OpenGL X11 warning

When running over SSH or without a display, the following warning may appear:

```text
[OpenGL] failed to open X11 server connection.
[OpenGL] failed to create X11 Window.
```

This can be ignored when the command saves the result to an output image file.
