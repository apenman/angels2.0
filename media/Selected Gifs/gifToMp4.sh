counter=0
for file in myimage*
do
  echo "$file"
  ffmpeg -f gif -i $file outfile$counter.mp4
  counter=$((counter+1))
done
