# WAI - Winetricks Auto Install Script

This Bash script is designed to simplify the installation of Wine configurations via the Winetricks Terminal. You no longer need to install them manually, as the installer handles everything, including potential errors. The tutorial only provides guidance.

---

## List of Installed Components

- `winetricks allfonts` *(winetricks_list_1)*
- `winetricks vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015` *(winetricks_list_2)*
- `winetricks dotnet40 dotnet35` *(winetricks_list_3)* → *Optional*
- `winetricks directplay directx9` *(winetricks_list_4_OpenGL)*
- `winetricks directplay directx9 dxvk vkd3d` *(winetricks_list_4_VulkanSupport)*

---

## **REQUIREMENTS**

1. Ensure your drivers are correctly installed (sound & GPU).
2. OpenGL version **3.1** is recommended, but **2.1** may work for some applications/games.
3. Make sure Wine & Winetricks are installed.
4. Install necessary dependencies: `wget`, `tar`, `cabextract`, `mesa-demos`.
5. Verify whether your hardware supports OpenGL or Vulkan.
6. Follow the video tutorial carefully.
7. Ensure you are connected to the internet during the installation process.

---
## **Install the required components or packages (non vulkan in Debian base, other distros can be customized)**
   ```bash
   sudo apt install winetricks wget tar cabextract mesa-demos
   ```
---
## **Install the required components or packages (with vulkan Driver in Debian base, other distros can be customized)**
   ```bash
   sudo apt install winetricks wget tar cabextract mesa-demos vulkan-tools
   ```
---
## **How to Use the Winetricks Configuration Script**

1. Download Winetricks Auto Install Script (WAI)
2. extract it
   ```bash
   tar -xf wai.tar.gz
   ```
3. Open a terminal in the **Winetricks_Conf** directory.
   ```bash
   cd wai/
   ```
4. Grant execution permissions to the script files:
   ```bash
   chmod +x rgame.sh winetricks_list_1.sh winetricks_list_2.sh winetricks_list_3.sh winetricks_list_4_OpenGL.sh winetricks_list_4_VulkanSupport.sh
   ```
5. Run the scripts as a **user** (not root) :
### Note: wait until completion for each running session
   ```bash
   ./winetricks_list_1.sh
   ```
   ```bash
   ./winetricks_list_2.sh
   ```
   ```bash
   ./winetricks_list_3.sh
   ```
---

## **For GPUs with OpenGL Only (No Vulkan Support):**

```bash
./winetricks_list_4_OpenGL.sh
```

---

## **For GPUs with Vulkan Support (Vulkan Drivers Installed on OS):**

```bash
./winetricks_list_4_VulkanSupport.sh
```
---
How to remove Wine Cache
---
```bash
sudo rm -rf ~/.wine
```
```bash
sudo rm -rf ~/.cache/wine
```
```bash
sudo rm -rf ~/.cache/winetricks
```
