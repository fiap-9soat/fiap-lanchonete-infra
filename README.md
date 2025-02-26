# fiap-lanchonete-infra

Fazer login no terraform
https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login

Repositório contendo os arquivos de configuração (Terraform) para viabilizar o deploy da API principal do projeto. A infraestrutura é baseada no uso do AWS ECS/EC2.

## Desenvolvimento

O desenvolvimento e construção da aplicação é feito diretamente no [repositório](https://github.com/fiap-9soat/fiap-lanchonete) da API principal, onde a imagem Docker é construida e enviada diretamente ao Dockerhub, onde pode ser consumida por qualquer canal.
