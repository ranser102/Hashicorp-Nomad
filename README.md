# Experiment with Hashicorp Nomad and Consul

This exmaple will launch Hashicorp Nomad and Consul on single node
Nomad will act as server+client

Traefik will serve as load balancer
(Webapp.nomad is an exmaple for app running behind load balancer)

Jenkins (with persistent volume) will be used as exmaple for job running on Nomad cluster

### Nomad

Download:  
https://www.nomadproject.io/downloads 

Startup command:  
`nomad agent -dev -config /apps/GIT/nomad/config/agent_server.conf`

Clean cache:  
`nomad system reconcile summaries`

Web UI:  
http://<your nomad server ip>:4646/ui/

### Consul

Download:  
https://www.consul.io/downloads 

Startup command:  
`consul agent -dev -client <your consul server ip>`

Web UI:    
http://<your consul server ip>:8500/ui/

### Traefik

Run Traefik:  
`nomad run traefik.nomad`  

Web UI:  
http://<your nomad server ip>:8081/dashboard/#/

### Jenkins

Run Jenkins:  
`nomad run jenkins.nomad`  

Jenkins is available through the traefik reverse proxy:  
http://<your nomad server ip>:8082/myjnk
