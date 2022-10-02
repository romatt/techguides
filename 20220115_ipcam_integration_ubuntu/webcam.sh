#!/bin/bash
# Generate a small and larger preview of current webcam image and adds current weather information

# Read weather data from disk
overlay=$(cat /var/www/html/weewx/overlay.txt)
update=$(cat /var/www/html/weewx/update.txt)

# Get the current date and time
year=$(date +"%Y")
month=$(date +"%m")
day=$(date +"%d")
hour=$(date +"%H")
min=$(date +"%M")

# Retrieve raw image
wget -O raw_image.jpg --no-http-keep-alive "http://192.168.1.115/cgi-bin/api.cgi?cmd=Snap&channel=0&r
s=${year}${month}${day}${hour}${min}&user=server&password=secretubuntu"

# Blur parts of image
convert raw_image.jpg -resize 2560x1440 \
\( -clone 0 -fill white -colorize 100 -fill black \
-draw 'rectangle 0,1330,2560,1440' -alpha off -write mpr:mask +delete \) \
-mask mpr:mask -blur 0x5 +mask \
-fill '#0008' -draw 'rectangle 0,1330,2560,1440' \
-pointsize 35 -font "Nimbus-Sans" -fill white -interline-spacing -13 -annotate +18+1380 "${overlay}" \
-pointsize 35 -font "Nimbus-Sans" -fill white -annotate +2000+1415 "${update}" \
-pointsize 40 -font "Nimbus-Sans-Bold" -fill white -annotate +2000+1380 'limmattalerwetter.ch' \
current.jpg

# Generate a small preview
convert raw_image.jpg -resize 480x270 ${dir}/current_small.jpg

# Save image in archive
mkdir -p ${year}/${month}/${day}
cp current.jpg "${dir}/${year}/${month}/${day}/REOLINK_${year}${month}${day}_${hour}${min}.jpg"
