@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
color 0A

:: =====================================================
::                YT-DLP Downloader
::        A simple, clean & friendly downloader
::                Creator: Miko Foxie
:: =====================================================

:menu
cls
echo ========================================
echo            YT-DLP DOWNLOADER
echo ========================================
echo  1. Download a single video
echo  2. Download multiple videos
echo  3. Download entire channel
echo  4. Download video/audio separately
echo  5. Exit
echo ========================================
set /p "choice=Select an option (1/2/3/4/5): "

if "%choice%"=="1" goto single_download
if "%choice%"=="2" goto multiple_download
if "%choice%"=="3" goto channel_download
if "%choice%"=="4" goto separate_download
if "%choice%"=="5" exit /b

echo.
echo [!] Invalid choice. Please try again.
timeout /t 2 >nul
goto menu

:: =====================================================
::            Separate Video/Audio Download
:: =====================================================
:separate_download
cls
echo ========================================
echo       SEPARATE VIDEO/AUDIO DOWNLOAD
echo ========================================
echo.
set /p "url=Enter the video URL (or type 'back' to return): "
if /i "!url!"=="back" goto menu
if "!url!"=="" goto separate_download

echo.
echo Choose what to download:
echo   1. Video only
echo   2. Audio only
echo   3. Both (separate files)
set /p "sep_choice=Select option (1/2/3) (or type 'back' to return): "
if /i "!sep_choice!"=="back" goto menu

echo.
set /p "folder=Enter the output folder (default: YTDLP-Videos) (or type 'back' to return): "
if /i "!folder!"=="back" goto menu
if "!folder!"=="" set "folder=YTDLP-Videos"
if not exist "!folder!" mkdir "!folder!"

if "!sep_choice!"=="1" (
    echo.
    echo Downloading video only...
    yt-dlp -f "bestvideo[ext=mp4]" -o "!folder!\%%(title)s_video.%%(ext)s" "!url!"
    
    echo.
    echo Download completed!
    pause
    goto continue
) else if "!sep_choice!"=="2" (
    echo.
    echo Choose audio format:
    echo   1. M4A
    echo   2. MP3
    set /p "audio_format=Select format (1/2): "
    
    if "!audio_format!"=="2" (
        echo.
        echo Downloading audio as MP3...
        yt-dlp -x --audio-format mp3 -o "!folder!\%%(title)s_audio.%%(ext)s" "!url!"
    ) else (
        echo.
        echo Downloading audio as M4A...
        yt-dlp -f "bestaudio[ext=m4a]" -o "!folder!\%%(title)s_audio.%%(ext)s" "!url!"
    )
    
    echo.
    echo Download completed!
    pause
    goto continue
) else if "!sep_choice!"=="3" (
    echo.
    echo Choose audio format:
    echo   1. M4A (default)
    echo   2. MP3
    set /p "audio_format=Select format (1/2): "
    
    echo.
    echo Downloading video file...
    yt-dlp -f "bestvideo[ext=mp4]" -o "!folder!\%%(title)s_video.%%(ext)s" "!url!"
    
    if "!audio_format!"=="2" (
        echo.
        echo Downloading audio as MP3...
        yt-dlp -x --audio-format mp3 -o "!folder!\%%(title)s_audio.%%(ext)s" "!url!"
    ) else (
        echo.
        echo Downloading audio as M4A...
        yt-dlp -f "bestaudio[ext=m4a]" -o "!folder!\%%(title)s_audio.%%(ext)s" "!url!"
    )
    
    echo.
    echo All downloads completed!
    pause
    goto continue
) else (
    echo.
    echo [!] Invalid choice. Please try again.
    timeout /t 2 >nul
    goto separate_download
)

:: =====================================================
::                Channel Download
:: =====================================================
:channel_download
cls
echo ========================================
echo          CHANNEL DOWNLOAD MODE
echo ========================================
echo.
set /p "channel_url=Enter the channel URL (or type 'back' to return): "
if /i "!channel_url!"=="back" goto menu
if "!channel_url!"=="" goto channel_download

echo.
set /p "folder=Enter the output folder (default: YTDLP-Videos) (or type 'back' to return): "
if /i "!folder!"=="back" goto menu
if "!folder!"=="" set "folder=YTDLP-Videos"
if not exist "!folder!" mkdir "!folder!"

echo.
echo Downloading channel videos... Please wait.
yt-dlp -f "bestvideo[ext=mp4][protocol*=m3u8]+bestaudio[ext=m4a]/best[ext=mp4]+bestaudio[ext=m4a]" --merge-output-format mp4 -o "!folder!/%%(uploader)s/%%(title)s.%%(ext)s" --download-archive "!folder!/downloaded_videos.txt" "!channel_url!"

echo.
echo Download completed!
pause
goto continue

:: =====================================================
::              Single Video Download
:: =====================================================
:single_download
cls
echo ========================================
echo          SINGLE VIDEO DOWNLOAD
echo ========================================
echo.
set /p "url=Enter the video URL (or type 'back' to return): "
if /i "!url!"=="back" goto menu
if "!url!"=="" goto single_download

echo.
echo Choose download method:
echo   1. Manual selection (IDs format)
echo   2. Automatic selection (m3u8, highest quality)
set /p "method=Select option (1/2) (or type 'back' to return): "
if /i "!method!"=="back" goto menu

if "!method!"=="1" goto single_download_ids
if "!method!"=="2" goto single_download_m3u8

echo.
echo [!] Invalid choice. Please try again.
timeout /t 2 >nul
goto single_download

:single_download_ids
cls
echo ========================================
echo       SINGLE VIDEO (Manual Format)
echo ========================================
echo.
echo Retrieving available formats for:
echo   !url!
echo.
yt-dlp -F "!url!"
echo.
set /p "video_id=Enter the video format ID (or type 'back' to return): "
if /i "!video_id!"=="back" goto menu
set /p "audio_id=Enter the audio format ID (or type 'back' to return): "
if /i "!audio_id!"=="back" goto menu

echo.
set /p "folder=Enter the output folder (default: YTDLP-Videos) (or type 'back' to return): "
if /i "!folder!"=="back" goto menu
if "!folder!"=="" set "folder=YTDLP-Videos"
if not exist "!folder!" mkdir "!folder!"

echo.
echo Downloading video with selected formats...
yt-dlp -f "!video_id!+!audio_id!" --merge-output-format mp4 -o "!folder!\%%(title)s.%%(ext)s" "!url!"

echo.
echo Download completed!
pause
goto continue

:single_download_m3u8
cls
echo ========================================
echo       SINGLE VIDEO (Auto m3u8 Mode)
echo ========================================
echo.
set /p "folder=Enter the output folder (default: YTDLP-Videos) (or type 'back' to return): "
if /i "!folder!"=="back" goto menu
if "!folder!"=="" set "folder=YTDLP-Videos"
if not exist "!folder!" mkdir "!folder!"

echo.
echo Downloading video using highest quality settings...
yt-dlp -f "bestvideo[ext=mp4][protocol*=m3u8]+bestaudio[ext=m4a]/best[ext=mp4]+bestaudio[ext=m4a]" --merge-output-format mp4 -o "!folder!\%%(title)s.%%(ext)s" "!url!"

echo.
echo Download completed!
pause
goto continue

:: =====================================================
::            Multiple Videos Download
:: =====================================================
:multiple_download
cls
echo ========================================
echo         MULTIPLE VIDEOS DOWNLOAD
echo ========================================
echo.
echo Select input method:
echo   1. Enter URLs one by one
echo   2. Load URLs from a file
set /p "input_method=Choose option (1/2) (or type 'back' to return): "
if /i "!input_method!"=="back" goto menu

if "!input_method!"=="1" goto input_urls
if "!input_method!"=="2" goto input_file

echo.
echo [!] Invalid choice. Please try again.
timeout /t 2 >nul
goto multiple_download

:input_urls
cls
echo ========================================
echo         MULTIPLE VIDEOS DOWNLOAD
echo         [Enter URLs one by one]
echo ========================================
echo.
echo Type each video URL and then press Enter.
echo When finished, type "done" and press Enter.
echo (or type "back" to return to main menu)
echo.
set "count=0"
set "tempFile=%temp%\temp_urls.txt"
if exist "!tempFile!" del "!tempFile!"

:input_loop
set /p "url=Enter URL (or type 'done'/'back'): "
if /i "!url!"=="back" goto menu
if /i "!url!"=="done" goto check_urls
echo !url!>> "!tempFile!"
set /a count+=1
goto input_loop

:check_urls
if !count! equ 0 (
    echo.
    echo [!] No URLs entered. Returning to main menu...
    timeout /t 2 >nul
    goto menu
)

echo.
set /p "folder=Enter the output folder (default: YTDLP-Videos) (or type 'back' to return): "
if /i "!folder!"=="back" goto menu
if "!folder!"=="" set "folder=YTDLP-Videos"
if not exist "!folder!" mkdir "!folder!"

echo.
for /f "usebackq delims=" %%A in ("!tempFile!") do (
    echo Downloading: %%A
    yt-dlp -f "bestvideo[ext=mp4][protocol*=m3u8]+bestaudio[ext=m4a]/best[ext=mp4]+bestaudio[ext=m4a]" --merge-output-format mp4 -o "!folder!\%%(title)s.%%(ext)s" "%%A"
)
if exist "!tempFile!" del "!tempFile!"

echo.
echo All downloads completed!
pause
goto continue

:input_file
cls
echo ========================================
echo         MULTIPLE VIDEOS DOWNLOAD
echo         [Load URLs from a File]
echo ========================================
echo.
set /p "file_path=Enter the full path to the file containing URLs (or type 'back' to return): "
if /i "!file_path!"=="back" goto menu
if not exist "!file_path!" (
    echo.
    echo [!] File not found! Please check the path.
    timeout /t 2 >nul
    goto multiple_download
)

echo.
set /p "folder=Enter the output folder (default: YTDLP-Videos) (or type 'back' to return): "
if /i "!folder!"=="back" goto menu
if "!folder!"=="" set "folder=YTDLP-Videos"
if not exist "!folder!" mkdir "!folder!"

echo.
for /f "usebackq delims=" %%A in ("!file_path!") do (
    if not "%%A"=="" (
        echo Downloading: %%A
        yt-dlp -f "bestvideo[ext=mp4][protocol*=m3u8]+bestaudio[ext=m4a]/best[ext=mp4]+bestaudio[ext=m4a]" --merge-output-format mp4 -o "!folder!\%%(title)s.%%(ext)s" "%%A"
    )
)

echo.
echo All downloads completed!
pause
goto continue

:continue
echo.
set /p "cont_choice=Do you want to perform another download? (y/n): "
if /i "!cont_choice!"=="y" goto menu
exit /b