@ECHO off
color F1
setlocal enabledelayedexpansion

set Version=V 1.3.2

Title Maddox's Batch Tank Texture Converter !version!
Echo -------------------------
Echo Maddox's Batch Tank Texture Converter !version!
Echo Made By Maddox
echo WARNING: please do close all windows and programs which might be using the folders involved in the conversion.
echo this tool supports the export of PNG textures to the following types of textures:
echo - Mali Textures
echo - PowerVR Textures (iOS and Android Variant)
echo - Tegra Textures
echo - Win10 Textures
echo - Adreno Textures 
echo Notes:
echo - This Batch script is written and tested on Win10 machines, I cannot ensure it's usability on other Windows Operating systems
echo - this tool will only support the conversion of PNG tank textures to the mentioned textures above. any other format of texture input will not be supported.
echo - using textures input other than 1024x1024 or 2048x2048 might cause unexpected results.
rem echo - the specifications of the encoding used for the mentioned textures are listed in the batch file in the format of PVRTextool CLI command options.
echo - any editing and redistribution of this tool must first obtain my permission.
echo -------------------------
pause

rem echo %b2eincfilepath%
rem %b2eincfilepath% is where the exe content is extracted inside the temp folder
if "%b2eincfilepath%"=="" ( set "b2eincfilepath=%cd%\converter_files" )

rem echo b2eprogrampathname
rem %b2eprogrampathname% is where the exe is started
if "%b2eprogrampathname%"=="" ( set "b2eprogrampathname=%cd%" )


rem Mali devices Specifications
set texturetype[0]=Android_Mali
set texture[0]=r8g8b8a8,UBN,lRGB
set extension[0]=mali.pvr

rem Tegra Specifications
set texturetype[1]=Android_Tegra
set texture[1]=BC2,UBN,lRGB
set extension[1]=tegra.dds

rem PowerVR for Android Devices Specifications
set texturetype[2]=Android_PowerVR
set texture[2]=PVRTC1_4,UBN,lRGB -q pvrtcbest
set extension[2]=PowerVR_Android.pvr

rem PowerVR for iOS devices specifications
set texturetype[3]=iOS_PowerVR
set texture[3]=PVRTC1_4,UBN,lRGB -q pvrtcbest
set extension[3]=PowerVR_iOS.pvr

rem DX11 Specifications
set texturetype[4]=PC_DX11
set texture[4]=BC2,UBN,lRGB
set extension[4]=dx11.dds


rem Adreno Specifications 
set texturetype[5]=Android_Adreno
set extension[5]=adreno.dds
rem set texture(unused)= ATC RGBA Explicit


rem set nation
set nation[0]=China
set nation[1]=France
set nation[2]=GB
set nation[3]=German
set nation[4]=Japan
set nation[5]=Other
set nation[6]=USA
set nation[7]=USSR

rem OriginalInputFolder Check
ECHO Checking for necessary Folders and programs to begin....
set shortDIR=Data\3d\Tanks
set myDIR="%b2eprogrampathname%\OriginalInputFolder"
for /l %%d in (0,1,7) do (
	IF not exist %myDIR%\%shortDIR%\!nation[%%d]!\images\ mkdir %myDIR%\%shortDIR%\!nation[%%d]!\images\ & set repair=true
)
if !repair!==true (
	ECHO The input folder was created/ repaired due to the structure of input folders being incomplete. Please load the .png textures into the respective folders before restarting the CMD file. The Command window will now close.
	Echo How to use: just put the .png files into the respective folders, just like how you install mods to the game
	Pause
	Exit
)


rem compressonator exsistance check
set compressonator="%b2eincfilepath%\TheCompressonator.exe"
if exist %compressonator% (
	echo Compressonator Module Detected....
	) else (
	Echo "Compressonator is not found, please make sure you got the correct files complied into this exe"
	pause
	exit ) 

rem CLI Exsistance check
Set CLI=%b2eincfilepath%\PVRTexToolCLI.exe
if exist %CLI% ( 
	echo PVRTexTool Module Detected....
	ECHO Ready to begin.... 
	if exist %b2eprogrampathname%\Output rd /s /q %b2eprogrampathname%\Output
) else ( 
	ECHO "PVRTexToolCLI.exe is not found, please make sure you got the correct files complied into this exe"
	pause
	Exit )

rem askes whether the user wants to resize output or not (it can help with performance, but might cause distortion.)
echo -------------------------
:resize
echo Select The Input Textures ^(What the Program will does^)
echo 1^) 1024x1024 ^(Won^'t resize anything^)
echo 2^) 2048x2048 ^(Will resize everything to 50%% of it^'s original Size^, PC textures will be decided next^)
set /p resizes="Your Input "
if [!resizes!]==[] echo echo Invaild Input detected & goto resize
if !resizes!==1 goto end1
if !resizes!==2 (
	echo Select Whether you want to Resize PC DX11 Textures to 50%% of it's original size as well [Y/N] ^(Default N^)
	set /p PCResize="Your Input "
	if !PCResize!==y set PCResize=Y
	goto end1
)
echo Invaild Input detected
goto resize
:end1

rem Main operation
rem for each nation
if exist %b2eprogrampathname:~0,2%\Texture_Cache rd /s /q %b2eprogrampathname:~0,2%\Texture_Cache
mkdir %b2eprogrampathname:~0,2%\Texture_Cache
for /l %%d in (0,1,7) do (
	rem for each texture png in each folder
	For /f %%G in ('dir /b %myDIR%\%shortDIR%\!nation[%%d]!\images\') DO (
		rem for each GPU (6 for now)
		for /l %%n in (0,1,5) do ( 
			if not exist %b2eprogrampathname%\Output\!texturetype[%%n]!\%shortDIR%\!nation[%%d]!\images mkdir %b2eprogrampathname%\Output\!texturetype[%%n]!\%shortDIR%\!nation[%%d]!\images
			rem check for file extension, anything other than png might not be compatible with the software used so png is the only accepted one.
			if %%~xG==.png (
				copy /y "%myDIR%\%shortDIR%\!nation[%%d]!\images\%%G" "%b2eprogrampathname:~0,2%\Texture_Cache"
				if !resizes!==2 (
					if !texturetype[%%n]!==PC_DX11 (
						if !PCResize!==Y mogrify -resize 50%% %b2eprogrampathname:~0,2%\Texture_Cache\%%G
					) else (
					mogrify -resize 50%% %b2eprogrampathname:~0,2%\Texture_Cache\%%G )
				)
				if !texturetype[%%n]!==Android_Adreno (
					rem for Adreno.dds textures only
					%compressonator% -convert %b2eprogrampathname:~0,2%/Texture_Cache/%%G %b2eprogrampathname:~0,2%/Texture_Cache/%%~nG.!extension[%%n]! -codec ATICompressor.dll +fourCC ATCA -mipper boxfilter.dll
					copy /y %b2eprogrampathname:~0,2%\Texture_Cache\%%~nG.!extension[%%n]! %b2eprogrampathname%\Output\!texturetype[%%n]!\%shortDIR%\!nation[%%d]!\images
				) else (
					rem for all other texture types
					%CLI% -i %b2eprogrampathname:~0,2%\Texture_Cache\%%G -dither -m -f !texture[%%n]! -o %b2eprogrampathname%\Output\!texturetype[%%n]!\%shortDIR%\!nation[%%d]!\images\%%~nG.!extension[%%n]! )
				copy /y %b2eincfilepath%\!texturetype[%%n]!.tex %b2eprogrampathname%\Output\!texturetype[%%n]!\%shortDIR%\!nation[%%d]!\images\%%~nG.tex
				Echo Copied tex file
			)
		)
	)
)
rd /s /q %b2eprogrampathname:~0,2%\Texture_Cache
pause
