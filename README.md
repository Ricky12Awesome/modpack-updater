# Modpack Updater
Updates modpacks for minecraft

I made this since `itzg/minecraft-server` doesn't support using server packs instead basing it off of client manifest

## Docker Compose

### Enviroment

#### `CF_API_KEY`
**Required**

You can find how [here](https://docker-minecraft-server.readthedocs.io/en/latest/types-and-platforms/mod-platforms/auto-curseforge/#api-key)

#### `CF_PROJECT_ID`
**Reuiqred**

`Project ID` can be found on the right side under `About Project` section of a modpack page you can find modpacks [here](https://www.curseforge.com/minecraft/search?page=1&pageSize=20&sortBy=relevancy&class=modpacks)

#### `AUTO_DELETE`
default: `"true"`

Auto deletes downloaded server archive

#### `FORCE_UNPACK`
default: `"false"`

Will always unpack server archive

### Volumes

`/data`: Should be the same as in [itzg/minecraft-server](https://docker-minecraft-server.readthedocs.io/en/latest/data-directory/)

### Compose
```yaml
services:
  modpack-updater:
    build: https://github.com/Ricky12Awesome/modpack-updater.git

    environment:
      CF_API_KEY: ${CF_API_KEY}
      CF_PROJECT_ID: ${CF_PROJECT_ID}

    volumes:
      - ./data:/data
```