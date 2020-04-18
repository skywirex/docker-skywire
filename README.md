**IMPORTANT:** INSTALL DOCKER FIRST IF YOU DON'T

- Install Docker using these 2 commands

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## Supported Architectures

The architectures supported by this image are:

| Architecture | Tag            |
| :----------: | -------------- |
|    x86-64    | amd64-latest   |
|    arm64     | arm64v8-latest |
|    armhf     | armhf-latest   |

## Usage

Here are some example snippets to help you get started creating a container.

Hypervisor container

```
docker create \
  --name=hypervisor \
  -it \
  --restart=unless-stopped \
  --net=host \
  -v ~/.config/skywire:/root/skywire/config \
skywirex/skywire-hypervisor:<tag>
```

Replace `<tag>` with appropriate tag above.

- Run hypervisor in Docker container

```
docker start hypervisor
```

From now you can access to hypervisorUI by typing <Hypervisor-IP>:8000

- Check your public key of hypervisor

```
cat ~/.config/skywire/hypervisor-config.json
```

Copy public key of hypervisor to input to the configuration file of visor `skywire-config.json`

- Visor container 

```
docker create \
  --name=visor \
  --cap-add=NET_ADMIN \
  -it \
  --restart=unless-stopped \
  --net=host \
  -v ~/.config/skywire:/root/skywire/config \
skywirex/skywire-visor:<tag>
```

- Run visor in Docker container

```
docker start visor
```

- Stop visor container to edit `skywire-config.json` to allow hypervisor access to visor 

```
docker stop visor
```

- Edit the contents of `skywire-config.json` file in the folder `~/.config/skywire` look like below

```
  "stcp": {
    "pk_table": null,
    "local_address": "localhost:7777"
  },
  ...................
  
  "hypervisors": [{
                 "public_key":"your-hypervisor-public-key-here",
               "address":"localhost:7080"  
  }],
```

- Start visor again

```
docker start visor
```

### Backup

Compress your visor folder using this command

```
tar czvf skywire-visor-backup.tgz ~/.config/visor
```

Use a program like `WinSCP` to access to your board and copy skywire-visor-backup.tgz file to save somewhere.

### Uptime checking

Check uptime of your public key at the address below

https://uptime-tracker.skywire.skycoin.com/visors

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. 

Below are the instructions for updating containers:

### Via Docker Run/Create

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
cd visor
docker build \
  --no-cache \
  --pull \
  -t skywirex/visor:latest .
```