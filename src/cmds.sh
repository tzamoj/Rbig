## To load image with big.matrix, convert first to txt, then csv
pnmnoraw data/pizza.ppm > data/pizza.txt
sed -e '4,$ s/  / /g' data/pizza.txt | awk -F' ' -f src/imageFormatting.awk | sponge data/pizza.txt

## To reconstruct the image from the binary raw image and display it in report.
rawtoppm -interpixel 11038 8278 data/pizzaComp100.bin > data/pizzaComp100.ppm
ppmtojpeg data/pizzaComp100.ppm > data/pizzaComp100.jpeg
convert -thumbnail 200 data/pizzaComp100.jpeg data/thumbPizzaComp100.jpg
