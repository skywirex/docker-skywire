**IMPORTANT:** INSTALL DOCKER FIRST IF YOU DON'T

- Install Docker using these 2 commands

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## Supported Architectures

The architectures supported by this image are: 


| Architecture |  Tag           |
| :----------: | -------------- |
|    aarch64   | v0.4.2-aarch64 |
|    armhf     | not available  |
|    x86_64    | v0.4.2-x86_64  |

Check your board architecture using `arch` command. 

If you boards are not support, see **Building locally** to build your own docker images. You need to build `skywire-hypervisor` and `skywire-visor` images

## Usage

Here are some example snippets to help you get started creating a container.

### VISOR WITH HYPERVISOR UI INSTALLATION

- Step 1: Create visor with hypervisor in a container (replace `<tag>` with appropriate tag above)

```
docker create \
    --name=visor \
    --net=host \
    -v ~/.config/skywire:/opt/skywire \
    --restart=unless-stopped \
  skywirex/skywire:<tag> skywire-visor
```

***Example***: your board architecture `aarch64` using the below command to create hypervisor docker container:

```
docker create \
    --name=visor \
    --net=host \
    -v ~/.config/skywire:/opt/skywire \
    --restart=unless-stopped \
  skywirex/skywire:v0.4.2-aarch64 skywire-visor
```

- Step 2: Run visor with hypervisor in Docker container

```
docker start visor
```

- Step 3: Check the visor with hypervisor container if it run correctly

```
docker ps
```

- Step 4: Access to hypervisor UI by typing `<IP>:8000` in your browser

- Step 5: Get your public key of hypervisor

```
cat ~/.config/skywire/skywire-config.json
```

- Copy public key to input into the configuration file of visor `skywire-config.json`

### VISOR INSTALLATION

- Creat visor container (replace `<tag>` with appropriate tag above.)

```
docker create \
    --name=visor \
    --net=host \
    -v ~/.config/skywire:/opt/skywire \
    --restart=unless-stopped \
  skywirex/skywire:<tag> skywire-visor
```

- Run visor in a Docker container

```
docker start visor
```

- Stop visor container to edit `skywire-config.json` to allow hypervisor access to visor 

```
docker stop visor
```

- Edit the contents of `skywire-config.json` file in the folder `~/.config/skywire` look like below

```
"hypervisors": ["hypervisor-public-key-here"],
```

- Start visor again

```
docker start visor
```

### Backup KEYS

Compress your visor folder using this command

```
tar czvf skywire-visor-backup.tgz ~/.config/skywire
```

Use a program like `WinSCP` to access to your board and copy skywire-visor-backup.tgz file to save somewhere.

### Uptime checking

Check uptime of your public key at the address below

http://uptime-tracker.skywire.skycoin.com/uptimes

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. 

Below are the instructions for updating containers:

### Via Docker Run/Create

The example below for updating visor container

* Update the image: `docker pull skywirex/visor:<tag>`
* Stop the running container: `docker stop visor`
* Delete the container: `docker rm visor`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `~/.config/skywire` folder and settings will be preserved)
* Start the new container: `docker start visor`
* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```
git clone https://github.com/skywirex/docker-skywire.git
cd docker-skywire
VERSION=$(git ls-remote --tags --refs --sort="v:refname" git://github.com/skycoin/skywire.git | tail -n1 | sed 's/.*\///')
ARCH=$(arch)
docker build -t skywirex/skywire:$VERSION-$ARCH .
```

### UPDATE FROM PREVIOUS INSTALLATION

#### BACK UP YOUR KEYS FIRST

HYPERVISOR

Dung va go docker cu

```
docker stop visor && docker rm visor
```

```
mv ~/.config/skywire/skywire-config.json ~/.config/skywire/skywire-config.json-bak
```

Thay thế pk và sk của file cấu hình trong thư mục `~/.config/skywire/`, file cấu hình tương tự như sau:

https://gist.github.com/magicstone1412/ce267562a5fedc01cd576a0a7ed7e4ba
 
```
docker run --rm \
    -v ~/.config/skywire:/opt/skywire \
  skywirex/skywire:v0.4.2-aarch64 skywire-cli visor gen-config --is-hypervisor
```

```  
docker create \
    --name=visor \
    --net=host \
    -v ~/.config/skywire:/opt/skywire \
    --restart=unless-stopped \
  skywirex/skywire:v0.4.2-aarch64 skywire-visor
```
```  
docker start visor
```

VISOR

```
docker stop visor && docker rm visor
```

```
mv ~/.config/skywire/skywire-config.json ~/.config/skywire/skywire-config.json-bak
```
```
docker run --rm \
    -v ~/.config/skywire:/opt/skywire \
  skywirex/skywire:v0.4.2-aarch64 skywire-cli visor gen-config -r
```
 
```
docker create \
    --name=visor \
    --net=host \
    -v ~/.config/skywire:/opt/skywire \
    --restart=unless-stopped \
  skywirex/skywire:v0.4.2-aarch64 skywire-visor  

```

Thay thế sk và pk và thêm pk của hypervisor vào phần hypervisors, Sau khi chỉnh sửa tương tự như sau:

https://gist.github.com/magicstone1412/dc815a1866cc8f2d1fd6bdcb84b83436

```
docker start visor
```
