**IMPORTANT:** INSTALL DOCKER FIRST IF YOU DON'T

- Install Docker using these 2 commands

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## Supported Architectures

Tag Structure: $VERSION-$ARC 

The architectures supported by this image are: 


| Architecture | Latest Tag   |
| :----------: | -------------- |
|    aarch64   | v0.3.0-aarch64 |
|    armhf     | v0.3.0-armhf |
|    x86_64    | v0.3.0-x86_64   |

## Usage

Here are some example snippets to help you get started creating a container.

### HYPERVISOR

- Step 1: Create hypervisor container (replace `<tag>` with appropriate tag above.)

```
docker create \
  --name=hypervisor \
  -it \
  --restart=unless-stopped \
  --net=host \
  -v ~/.config/skywire:/root/skywire/config \
skywirex/skywire-hypervisor:<tag>
```

- Step 2: Run hypervisor in Docker container

```
docker start hypervisor
```

- Step 3: Check the hypervisor container if it run correctly

```
docker ps -a
```

- Step 4: Access to hypervisorUI by typing `<Hypervisor-IP>:8000` in your browser

- Step 5: Get your public key of hypervisor

```
cat ~/.config/skywire/hypervisor-config.json
```

- Copy public key of hypervisor to input to the configuration file of visor `skywire-config.json`

### VISOR

- Creat visor container (replace `<tag>` with appropriate tag above.)

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
                 "public_key":"your-hypervisor-public-key-here"
  }],
```

- Start visor again

```
docker start visor
```

### Backup

Compress your visor folder using this command

```
tar czvf skywire-visor-backup.tgz ~/.config/skywire
```

Use a program like `WinSCP` to access to your board and copy skywire-visor-backup.tgz file to save somewhere.

### Uptime checking

Check uptime of your public key at the address below

https://uptime-tracker.skywire.skycoin.com/uptimes

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
cd visor
VERSION=$(git ls-remote --tags --refs --sort="v:refname" git://github.com/skycoin/skywire.git | tail -n1 | sed 's/.*\///')
docker build --no-cache --pull -t skywirex/skywire-visor:$VERSION .
```

## Track visors

You can now track your running visors using google sheet by:

1. Making a copy of google sheet here https://bit.ly/2KAY3Yx

2. Add the trigger to run script in the interval time

3. Bookmark your google sheet and check it manually (about 1 time/day)

To add the trigger and run script in the interval time

+ Step 1+2: Make a copy of the above google sheet and click Tools --> Script editor

![step-make-a-copy-and-script-editor](https://user-images.githubusercontent.com/9553811/80311102-dfda5d80-8807-11ea-9b8a-3de91cc13977.png)

+ Step 3: 

![step-to-add-trigger](https://user-images.githubusercontent.com/9553811/80311106-e4067b00-8807-11ea-975f-413cff273d49.png)

+ Step 4+5: 

![step-add-trigger](https://user-images.githubusercontent.com/9553811/80311110-e8329880-8807-11ea-95f4-3b67fcc4e3b4.png)