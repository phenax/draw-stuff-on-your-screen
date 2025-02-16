
build:
  mkdir -p build
  crystal build main.cr -O 3 -t -o build/dsoys

run:
  crystal run main.cr

fmt:
  crystal tool format

