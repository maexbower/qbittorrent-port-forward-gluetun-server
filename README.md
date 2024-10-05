# qbittorrent-port-forward-gluetun-server

A shell script and Docker container for automatically setting qBittorrent's listening port from Gluetun's control server.

## Config

### Environment Variables

| Variable     | Example                     | Default                      | Description                                                     |
|--------------|-----------------------------|------------------------------|-----------------------------------------------------------------|
| QBT_USERNAME | `username`                  | `admin`                      | qBittorrent username                                            |
| QBT_PASSWORD | `password`                  | `adminadmin`                 | qBittorrent password                                            |
| QBT_ADDR     | `http://192.168.1.100:8080` | `http://localhost:8080`      | HTTP URL for the qBittorrent web UI, with port                  |
| GTN_ADDR     | `http://192.168.1.100:8000` | `http://localhost:8000`      | HTTP URL for the gluetun control server, with port              |
| GTN_USERNAME | `admin`                     | `admin`                      | Only to be set when GTN_AUTH is set to `basic`              |
| GTN_PASSWORD | `admin`                     | `admin`                      | Only to be set when GTN_AUTH is set to `basic`              |
| GTN_API_KEY  | `123456789`                 | `123456789`                  | Only to be set when GTN_AUTH is set to `api`              |
| GTN_AUTH     | `basic`                     | `basic`                      | Gluetun Control server reuqires Auth. Possible options are `basic or `api`. |

### Gluetun Control Server Auth
As of Version 3.40 Gluetun Control server will require authentication set up. Please refer to the gluetun wiki for instructions to set up authentication.

## Example

### Docker-Compose

The following is an example docker-compose:

```yaml
  qbittorrent-port-forward-gluetun-server:
    image: mjmeli/qbittorrent-port-forward-gluetun-server
    container_name: qbittorrent-port-forward-gluetun-server
    restart: unless-stopped
    environment:
      - QBT_USERNAME=username
      - QBT_PASSWORD=password
      - QBT_ADDR=http://192.168.1.100:8080
      - GTN_ADDR=http://192.168.1.100:8000
```

## Development

### Build Image

`docker build . -t qbittorrent-port-forward-gluetun-server`

### Run Container

`docker run --rm -it -e QBT_USERNAME=admin -e QBT_PASSWORD=adminadmin -e QBT_ADDR=http://192.168.1.100:8080 -e GTN_ADDR=http://192.168.1.100:8000 qbittorrent-port-forward-gluetun-server:latest`
