# ! bin/bash

if [ ! -d "./latex" ]; then
  mkdir ./latex
fi

if [ ! -d "./markdown" ]; then
  mkdir ./markdown
fi

if [ ! -d "./html" ]; then
  mkdir ./html
fi

if [ ! -d "./pdf" ]; then
  mkdir ./pdf
fi

rm -f  ./markdown/*
rm -f ./html/*
rm -f ./pdf/*
rm -f ./latex/*


echo "Converting text to markdown..."
for filename in text/guide*.txt; do
   [ -e "$filename" ] || continue
   pandoc "$filename" --to markdown > markdown/$(basename "$filename" .txt).md 
done


echo "Converting markdown to latex..."
for filename in markdown/guide*; do
   [ -e "$filename" ] || continue
   pandoc "$filename" --to latex > latex/$(basename "$filename" .md).tex  
done


pandoc -s latex/*.tex -o latex/guide.tex 

echo "Converting latex to pdf..."

pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="MesloLGS NF Regular" --variable sansfont="MesloLGS NF Regular" --variable monofont="MesloLGS NF Regular" --variable fontsize=12pt --variable version=2.0 latex/guide.tex  --pdf-engine=xelatex --toc -o pdf/guide.pdf


echo "Converting latex to html..."
pandoc -s --quiet latex/guide.tex -o html/index.html
