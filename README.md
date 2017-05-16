# WoTB_Batch_Texture_Converter
Simple WoTB Texture Converter, Based off Windows CMD script.

# Feature of this Texture Converter
- Ability to convert .png files to all WoTB Support Textures
	- Mali (RGBA8888)
	- Adreno (ATC RGBA Explicit, Specifically for Adreno)
	- PowerVR (iOS and Android) (PVRTC 4bpp RGBA)
	- Tegra (DXT3/BC2)
	- DX11 (MacOS and Windows) (DXT3/BC2)
- Used .tex file to Force WoTB to read the respective texture, which solves the problem where T71 Texture being in pvr and RGBA 8888 regardless of GPU.
- Ability to scale down textures by 50% (which helps when you are moving old textures from WoT PC Version to Blitz)
- First Startup the exe will create a whole new folder with the interior just like WOTB Game folder. Put the .png files into the Tanks/Nation/Images folder and restart the exe to see the magic.

# Details of this Converter
- Used the .exe from a very old version of the Compressantor just for the Adreno Textures (Sorry I know I shouldn't be putting .exe s in here, but forgive my lack of knowledge on learning how stuff works on Github)
- The script first convert the current .png to every single available texture formate allowed in Blitz, then move onto the next texture.

# Complie
Use the enclosed Bat to exe converter, which you will have to reset the included files path (because it's absolute path), and the details of the files and such.

# Things to note
This Script won't work if you don't convert it into .exe via using Bat to exe converter because two of the path variables depend on the conversion.
- %b2eincfilepath% is where the "Included" files are extracted inside the "Temp" folders of Windows
- %b2eprogrampathname% is where the .exe was excuted