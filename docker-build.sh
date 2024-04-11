docker build . -t cross
docker run --rm -v "$(pwd)":/app cross
