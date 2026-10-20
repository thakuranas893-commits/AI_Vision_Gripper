# 🤖 AI Vision Teleoperated Robotic Gripper

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.10%2B-blue?logo=python&logoColor=white" alt="Python Version" />
  <img src="https://img.shields.io/badge/OpenCV-5.0%2B-5C3EE8?logo=opencv&logoColor=white" alt="OpenCV" />
  <img src="https://img.shields.io/badge/Google-MediaPipe-0078D4?logo=google&logoColor=white" alt="MediaPipe" />
  <img src="https://img.shields.io/badge/Hardware-ESP32-E7352C?logo=espressif&logoColor=white" alt="ESP32" />
  <img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License" />
</p>

An ultra-low latency, vision-based tele-operation station that mirrors human finger pinch and grasp gestures onto a physical 1-servo robotic gripper in real time. Built using **OpenCV**, **MediaPipe Hand AI (Temporal Tracking)**, and an **ESP32 microcontroller**.

---

## 🌟 Key Engineering Features

- **📏 Distance-Invariant Pinch Tracking**: Calculates normalized Euclidean distance between thumb and index finger relative to hand anatomical scale (`Wrist` to `Middle MCP`), ensuring identical grip response whether your hand is 20 cm or 2 meters from the camera.
- **🛡️ Occlusion-Resistant Dual Anchor**: Simultaneously tracks Thumb-to-Index Tip and Thumb-to-Index MCP to maintain rock-solid tracking even when the thumb physically occludes the fingertip.
- **❄️ Anti-Chatter Deadband & Servo Overheat Protection**: The servo motor only receives PWM position updates when intentional movement exceeds `2.5°`. Static positions draw zero active stall current, completely preventing motor buzzing and overheating.
- **🔒 Virtual Clutch & Hands-Free Grip Lock**: Double-pinch or press `L` to lock the claw clamped in place. You can rest your hand or leave the webcam frame while the gripper holds an object securely.
- **🎯 3-Second Interactive Calibration Wizard**: Press `C` to launch an interactive calibration that measures your hand's unique anatomy (full open span vs. tight pinch) and saves the profile to `config.json`.
- **🔊 Sci-Fi Cybernetic Sound Effects**: Integrated non-blocking acoustic cues for grab, release, and clutch lock chimes (toggleable with `M`).
- **🎛️ Digital Twin HUD**: Cyberpunk overlay with hand skeleton, grip percentage gauge, and an animated 2D digital twin claw mirroring the physical gripper in real time.
- **🔄 Dynamic Multi-Camera Switching**: Seamlessly toggle between webcam, phone cam, and virtual feeds on the fly with `Tab` or `0-9`.
- **🧪 Simulation Fallback Mode**: Automatically runs with a responsive on-screen simulated claw if no ESP32 is plugged in.

---

## 🏛️ System Architecture

```text
  +-------------------------------------------------------------------------+
  |                              PC / LAPTOP                                |
  |                                                                         |
  |  [Webcam Feed] ---> [MediaPipe Hand AI] ---> [Normalized Distance Math] |
  |                             |                                           |
  |                             v                                           |
  |                  [5-Frame Median Filter]                                |
  |                             |                                           |
  |                             v                                           |
  |                  [Exponential Smoothing]                                |
  |                             |                                           |
  |                             v                                           |
  |             [Anti-Chatter Deadband Filter (2.5°)]                       |
  |                             |                                           |
  +-----------------------------|-------------------------------------------+
                                |  USB Serial (<angle>\n @ 115200 baud)
                                v
  +-------------------------------------------------------------------------+
  |                           ESP32 CONTROLLER                              |
  |                                                                         |
  |   Serial Buffer ---> Clamp Bounds [15°-165°] ---> Easing Interpolation  |
  |                                                           |             |
  +-----------------------------------------------------------|-------------+
                                                              v  PWM (GPIO 18)
                                                     [Robotic Gripper Servo]
```

---

## 📐 Hardware Wiring

| Servo Wire | ESP32 Pin | Details |
| :--- | :--- | :--- |
| **Yellow / Orange (Signal)** | **GPIO 18** | Controlled via `ESP32Servo` |
| **Red (VCC)** | **VIN / 5V** | 5V power supply |
| **Brown / Black (GND)** | **GND** | Must share common ground with ESP32 |

> [!TIP]
> If using high-torque servos (e.g. MG995 / MG996R) or if the ESP32 restarts during motor movement, power the servo with a dedicated 5V power source and connect its ground pin to the ESP32 GND pin.

---

## 🚀 Quick Start (Running on Any PC)

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/AI_Vision_Gripper.git
cd AI_Vision_Gripper
```

### 2. Install Dependencies
Double-click **`setup_env.bat`** (or install via terminal):
```bash
pip install -r python/requirements.txt
```
*(The MediaPipe AI model downloads automatically on first run).*

### 3. Flash the ESP32 Firmware
1. Open [`ESP32_Gripper_Receiver/ESP32_Gripper_Receiver.ino`](file:///c:/Users/thaku/OneDrive/Documents/Arduino/AI_Vision_Gripper/ESP32_Gripper_Receiver/ESP32_Gripper_Receiver.ino) in the Arduino IDE.
2. Ensure you have the `ESP32Servo` library installed (`Tools` -> `Manage Libraries...` -> search `ESP32Servo`).
3. Select your ESP32 board and COM port, then click **Upload**.

### 4. Run the Vision Station
Double-click **`run_teleop.bat`** or run:
```bash
cd python
python ai_vision_teleop.py
```

---

## ⌨️ Interactive Controls & Shortcuts

All hotkeys work regardless of whether **Caps Lock is ON or OFF**:

| Key / Gesture | Action |
| :---: | :--- |
| **`Tab`** | **Cycle camera feeds** (e.g., switch between Phone on 0 and Webcam on 1) |
| **`0`, `1`, `2`** | **Directly switch** to Camera index 0, 1, or 2 |
| **`c`** | **3-Second Calibration Wizard** (Follow on-screen prompt: Open hand -> Pinch tight) |
| **`l`** (or **Double-Pinch**) | **Virtual Clutch / Grip Lock** (Locks claw clamped shut for hands-free holding) |
| **`m`** | **Mute / Unmute** cybernetic sound effects |
| **`r`** | **Invert direction** (swap open vs close mapping) |
| **`s`** | **Rescan hardware** and auto-connect to ESP32 USB COM port |
| **`q` or `Esc`** | **Quit** the application |

---

## 🛠️ File Structure

```text
AI_Vision_Gripper/
├── .gitignore                          # Ignores local models, caches & configs
├── LICENSE                             # MIT Open Source License
├── README.md                           # Documentation & Wiring Guide
├── setup_env.bat                       # One-click dependency installer for fresh PCs
├── run_teleop.bat                      # Main batch launcher
├── select_camera.bat                   # Visual camera selector tool
├── ESP32_Gripper_Receiver/
│   └── ESP32_Gripper_Receiver.ino     # Anti-jitter ESP32 firmware
└── python/
    ├── ai_vision_teleop.py             # Main MediaPipe OpenCV tele-op pipeline
    ├── camera_selector.py              # Visual multi-camera selector & preview
    ├── config.example.json             # Default config template
    └── requirements.txt                # Python package dependencies
```

---

## 📜 License
Distributed under the **MIT License**. See `LICENSE` for more information.
