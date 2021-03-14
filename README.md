# developertyrone/docker-keeweb

Free cross-platform password manager compatible with KeePass.
https://keeweb.info/

- WebDAV support
- TLS support

## Suggestion

To current version is highly suggested to use with VPN or your own intranet

## Before you use it

Make sure you have your own config.json. By default the file is:
```json
{
	"settings": {
		"theme": "fb",
		"autoSave": true,
		"autoSaveInterval": 1,
		"canOpenDemo": false,
		"dropbox": false,
		"gdrive": false,
		"onedrive": false,
		"canExportXml": false
	},
	"files": [{
		"storage": "webdav",
		"name": "Database",
		"path": "/webdav/database.kdbx", // path to your database files
		"options": { "user": "webdav", "password": "secret" } // Change it
	}]
}
```
## Uasage
### match the setting with your config.json

```bash
docker run -d -p 80:80 -p 443:443 -e WEBDAV_USERNAME=webdav -e WEBDAV_PASSWORD=secret -v ${PWD}/vault:/keeweb/webdav --name mykeeweb developertyrone/keeweb-webdav:v1.17 
```
### Access to https://localhost

## To run custom port and custom config.json
```bash
docker run -d -p 9080:80 -p 9443:443 -e WEBDAV_USERNAME=webdav -e WEBDAV_PASSWORD=secret -e KEEWEB_CONFIG_URL=config.json -v ${PWD}/vault:/keeweb/webdav --name mykeeweb developertyrone/keeweb-webdav:v1.17 
```
