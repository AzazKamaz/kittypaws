
#!/bin/bash

echo "This script will modify your system by creating a new directory, cloning a repository, and creating a new configuration file. Do you wish to continue? [Y/n]"
read -r answer
if [[ "$answer" =~ ^[Nn]$ ]]; then
  echo "Script cancelled by user."
  exit 0
fi


# Create directory
echo "Creating directory ~/.kittypaws/plugins/dropper/"
mkdir -p ~/.kittypaws/plugins/dropper/

# Clone repository
echo "Downloading main.py to ~/.kittypaws/plugins/dropper/main.py"
wget https://raw.githubusercontent.com/subatiq/kittypaws-dropper/master/main.py -P ~/.kittypaws/plugins/dropper/

# Create container and ping target
echo "Creating container with name 'container-name' and pinging $target_ip"
docker stop container1 container2
docker rm container1 container2
docker run -d --name container1 alpine sleep 999999999
docker run -d --name container2 alpine sleep 999999999

docker network create dropper
docker network connect dropper container1
docker network connect dropper container2

target_ip=$(docker inspect container1 | jq -r '.[0].NetworkSettings.Networks.bridge.IPAddress'
)

echo -e "\033[31mTarget IP that will be blocked: $target_ip\033[0m"

# Create configuration file
echo "Creating configuration file ./config.yml"
cat > ./config.yml <<EOF
plugins:
- dropper:
    target: container-name
    ip: $target_ip
    unavailable_seconds: 1800
    frequency: random
    min_interval: PT1H
    max_interval: PT90M
EOF


echo -e 'Run \033[31mdocker exec container1 ping -c 100 container2\033[0m'

# Run program
echo "Running program with config.yml"
cargo run config.yml


