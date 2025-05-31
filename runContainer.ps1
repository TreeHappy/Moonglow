# Build the image
podman build -t dev-env .

# Run interactive container with home directory mounted
podman run -it --rm -v ~:/home/developer/host dev-env

