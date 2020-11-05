The docker images can be found at 

- For hypervisor image: https://hub.docker.com/r/skywirex/skywire-hypervisor

- For visor image: https://hub.docker.com/r/skywirex/skywire-visor

### 1. Stop and remove the old visor and hypervisor container

```
docker stop visor && docker rm visor
```

##### ONLY use the below command on HYPERVISOR board 

```
docker stop hypervisor && docker rm hypervisor
```

### 2. Backup your public and private keys and rename skywire config folder

```
mv ~/.config/skywire/ ~/.config/skywire-bak/
```

### 3. Get your backup visor and hypervisor key information

```
cat ~/.config/skywire-bak/skywire-config.json
```

##### ONLY use the below command on HYPERVISOR board 

```
cat ~/.config/skywire-bak/hypervisor-config.json
```

Copy your private key and public key to txt file

For example:

VISOR keys

```
"public_key": "026eed937354de7e658ecba631df5740193027ca363c26244e4b1192ed12aea132",
"secret_key": "cc9a99c32a5df9bfa55278a2804ed98686b1dc77cffb0ec985bed33166217b96"
```

### 4. Build docker images for your board if it's not available (**SKIP THIS STEP** if your architecture board is supported, see support <tag> in the link above)

Check your board architecture on the above link

```
uname -a
```

See **Building locally** section if you need to build docker images

### 5. Create new `skywire-hypervisor` and `skywire-visor` docker containers

For example, using **<tag>** v0.3.0-aarch64, you can run the following command

```
docker create \
  --name=visor \
  --cap-add=NET_ADMIN \
  -it \
  --restart=unless-stopped \
  --net=host \
  -v ~/.config/skywire:/root/skywire/config \
skywirex/skywire-visor:v0.3.0-aarch64
```

##### ONLY use the below command on HYPERVISOR board 

```
docker create \
  --name=hypervisor \
  -it \
  --restart=unless-stopped \
  --net=host \
  -v ~/.config/skywire:/root/skywire/config \
skywirex/skywire-hypervisor:v0.3.0-aarch64
```

### 6. Start and stop container to create default configuration files

```
docker start visor && docker stop visor
```

##### ONLY use the below command on HYPERVISOR board 

```
docker start hypervisor && docker stop hypervisor
```

### 7. Replace the key in the `~/.config/skywire` folder and start container

Using `nano` command to replace your key in the new generated configuration file

```
nano ~/.config/skywire/skywire-config.json
```

Change the below section using YOUR KEYS

```
"sk": "47507d291fc761603f23d3b26b2746fbbe4bfe7dac99b520da185b55c5b55336",
"pk": "0393944d8afb53d3eaea80379e3c64cdccf842f311766094ce1033c1685bf828a4",
...
"hypervisors": ["02c488d6f813a456f3429586e17e101f4fa7df5de26a782bbff18a3a223d586abf"]
```

After replacing you keys, `Ctrl + o` to save and `Ctrl + x` to exit

```
docker start visor
```


### 8. Check your public keys on uptime page

https://uptime-tracker.skywire.skycoin.com/uptimes