#!/usr/bin/awk -f

# colour is either 1, 2, 3 depending on which colour you are requesting
# eg use -v colour=1

NR == 2{
  ncol = $1;
  fixedWidth = 6;
  chunkSize = int(ncol / fixedWidth) + 1;
}

NR > 3{
  for(i = colour; i <= NF; i = i + 3){
    if( (NR - 3) % chunkSize == 0 && (i - colour + 3) == 3 * (ncol % fixedWidth)){
      printf("%s\n", $i);
    } else {
      printf("%s ", $i);
    }
  }
}
   
   


