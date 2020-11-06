job "jenkins" {
  datacenters = ["dc1"]

  group "app" {
    volume "jnk_home" {
      type      = "host"
      source    = "jnk"
      read_only = false
    }

    network {
       port "http" {
        to = 8080
      }
    }

    service {
      port = "http"
      name = "myjnk"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.myjnk.rule=PathPrefix(`/myjnk`)",
      ]
 
      check {
          type     = "http"
          path     = "/myjnk/login"
          interval = "10s"
          timeout  = "10s"
      }
    }    

    task "jenkins" {
      driver = "docker"

      volume_mount {
        volume      = "jnk_home"
         destination = "/var/jenkins_home/"
         read_only   = false
      }

      config {
        image = "docker.io/jenkins/jenkins"
        ports = ["http"]
        force_pull   = "false"
      }

      env {
         JENKINS_OPTS = "--prefix=/myjnk"
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}
  
