docker build -t my-dev-env .
docker stop ariel-ide 
docker rm ariel-ide 
docker run -it  -v ~/git:/workspace   -v ~/.ssh:/home/ariel/.ssh:ro  -e DISPLAY=$DISPLAY  -d --name ariel-ide  --network host  my-dev-env
