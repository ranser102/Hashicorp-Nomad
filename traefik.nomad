job "traefik" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik"
        force_pull   = "false"
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":8082"
    [entryPoints.traefik]
    address = ":8081"

[api]
    dashboard = true
    insecure  = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
    prefix           = "traefik"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "<your consul server ip>:8500"
      scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128

        network {
          mbits = 10

          port "http" {
            static = 8082
          }

          port "api" {
            static = 8081
          }
        }
      }

      service {
        name = "traefik"

        check {
          name     = "alive"
          type     = "tcp"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
