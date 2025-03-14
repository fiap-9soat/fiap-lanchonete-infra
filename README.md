# fiap-lanchonete-infra

Repositório contendo a configuração (Terraform) do EKS, API Gateway, e VPC compartilhado para viabilizar o deploy da API
principal do projeto.

## Ordem de execução

A maioria dos projetos nessa organização exporta e importa estados no backend compartilhado do Terraform (utilizando
HCP).
Sendo assim, no primeiro deploy, os projetos devem ser executados na seguinte ordem:

```
fiap-lanchonete-auth
fiap-lanchonete-infra
fiap-lanchonete-db
```

**Importante**: esse passo só é necessário caso você esteja "subindo" o projeto pela primeira vez,
como em uma troca de organização do HCP ou troca de conta do AWS.
Essa ordem garante que os projetos exportarão as variaveis necessárias no backend compartilhado corretamente.    
Nos demais casos (como CI/CD, execuções do `terraform apply` posteriores),
a ordem de execução não é importante.

## Instalação e Execução

### Pre-requisitos

Certifique-se de ter instalado uma versão recente da CLI do `terraform`.

### Autenticação com o Terraform HCP

Essa organização utiliza o Terraform HCP para compartilhamento de estado entre os repositórios.  
Isso significa que é **obrigatório** realizar o login na plataforma para prosseguir com a instalação:
https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login

### Criando uma organização e workspace

No Painel do Terraform HCP, é importante copiar o nome da organização e o workspace alvo da configuração.  
Esse passo é essencial, e os valores devem ser especificados nas variaveis de ambiente a seguir:

```hcl
hcp_org = "fiap-lanchonete" # Nome da organização no Terraform HCP
hcp_workspace = "lanchonete-infra-2" # Nome da workspace pertencente a organização no Terraform HCP
```

Esse passo é obrigatório para **todos** os projetos de Terraform dessa organização.

### Variaveis de ambiente

É necessário criar algumas variaveis de ambiente para viabilizar a aplicação das configurações pelo CLI do Terraform.  
Para ambiente local, basta utilizar o arquivo `dev.auto.tfvars.example` como exemplo, criando um `dev.auto.tfvars`
correspondente:

```hcl
aws_access_key = "ASIAVEZQ3WJY2KR216362"
aws_secret_key = "TU+qlmgcNsX5MQz1238214821748211"
aws_token_key  = "12387218372185712887482173821849211299ddwq+Wp+JXsIYgo8GwFKk7Ms6y7wmGc9J1CqCJ1dAiALfo+D+BERHahJ1CpswGvC0BZah/cF7XIfZNgrxpIbLiq9AghgEAEaDDM1MzkwMDQwOTQ1NyIM5y1D/eAy2LhTThABKpoCER68KmMdcDD57aDTEC8KjfdDsLcco3EN8HfrspVnBAWXhQxMT3bF4aVVusYwMTbjKA4wBb1AK34SohcvbMQvKX+iIZGsIm7CkuMkIZsUeto9bDkwHq7P6e2ctJvUUf4khVv9armJYpqdb7sytoqfjRbYxU8WIgXXRaodcpxxusX1KkzP2DWBb5wKBQy/Cv8c0uiUKL1WtfTobjEZj5eEV9Kjf4GtXvjrfS0QU/eLs6kvsrEiQU6+ZCMeDdvAfWIEritAMFSUEaVDDsPn8uq7CJ0LWbcTB6qHMkP9l4PFMIZiNNQPycS79+4X/2T85jc+QIX4hZDMDrTm5lMmY4Ya5q0y8jxZQMsMbNkEL2JfP9pklquyMT0oQdUOMMLS/L0GOp4Bd6Y8K1rgPaKQkveh74WrGZHa+VNO5V24vSLiTnHr4F/fJFD/ZMz6nBRlwQbX3wUQxAujUPLKDAzF4oEvPzu69L09Q9msZTzFJMVNS/1mwFSqkxRtDjl+SejFFAm55be2YPwpb7qFOy+KFmPj3zlTe8+8Grnk7HjabAukdmAjlXpG3Q/ClJyQ2nc1skl5RHCXkBDG3wQdlj7DorTtHcw="
hcp_org = "fiap-lanchonete" # Nome da organização no Terraform HCP
hcp_workspace  = "lanchonete-infra-2" # Nome da workspace pertencente a organização no Terraform HCP
```

_Atenção: essas credenciais são inválidas, e servem apenas como exemplo. Você deve obter as credenciais corretas do
próprio ambiente da AWS. Todas as variáveis são obrigatórias._

Caso você utilize o `AWS CLI`, os parametros no arquivo `~/.aws/credentials` podem ser utilizados para autenticação.
A tabela abaixo relaciona as credenciais especificadas nas variaveis do Terraform com as presentes no arquivo
`~/.aws/credentials`.

| tfvars         | ~/.aws/credentials    |
|----------------|-----------------------|
| aws_access_key | aws_access_key_id     |
| aws_secret_key | aws_secret_access_key |
| aws_token_key  | aws_session_token     |

### Estrutura

Esse repositório faz uso da funcionalidade de `modules` do Terraform, onde um arquivo principal (`main.tf`) orquestra o
deploy
de sub-modulos (pasta `modules`), passando as variaveis necessárias.
Para realizar os comandos (`terraform apply`, etc). Apenas as variaveis presentes no arquivo `variables.tf` devem ser
preenchidas.  
Estas estão especificadas logo acima.

## Aplicar configurações

Inicialize os módulos do Terraform do repositório:

```shell
terraform init
```

Com a configuração realizada, basta executar o seguinte comando para validar a configuração e conferir as alterações
que serão realizadas:

```shell
terraform plan
```

Caso o comando execute corretamente, você está devidamente autenticado em alguma instância válida do `AWS`.  
Para aplicar as alterações, basta rodar o seguinte comando e inserir 'yes' quando solicitado:

```shell
terraform apply
```

Em caso de erro, verifique se o usuario executante tem permissões para criações de instâncias do AWS RDS, VPC e Subnets.

**Importante**: Caso seja a primeira "subida" do projeto, siga a ordem de execução
especificada [aqui](#ordem-de-execução).

## Erros comuns

### AWS com LabRole

Devido a natureza efêmera da instância de AWS utilizada pelo AWS Instructure, pode ser que você receba erros ao executar
o
`terraform plan` ou `terraform apply` depois da primeira execução.  
Por esse motivo, recomendamos limpar o estado local do Terraform sempre que subir uma nova instância do AWS Lab.

### Limpando estado local

Na maioria das vezes, os erros são solucionados simplesmente limpando o estado local para remover referências a
elementos
que não existem mais.  
Para isso, basta remover esses arquivos e diretórios da pasta raiz do repositório:

```
.terraform
terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
```

E em seguida re-iniciar os módulos:

```shell
terraform init
```

#### Error: Kubernetes cluster unreachable

```
╷
│ Error: Kubernetes cluster unreachable: invalid configuration: no configuration has been provided, try setting KUBERNETES_MASTER environment variable
│ 
│   with module.api_gateway.helm_release.aws_load_balancer_controller,
│   on modules/api_gateway/0-load-balancer.tf line 2, in resource "helm_release" "aws_load_balancer_controller":
│    2: resource "helm_release" "aws_load_balancer_controller" {
│ 
╵
```

Esse erro ocorre porque o Terraform tenta realizar uma conexão automatica com o cluster do Kubernetes (especificado nos
providers `helm` e `kubernetes`)  
e caso o cluster "suma" depois que o estado inicial é gerado, a conexão falha e consequentemente um erro é retornado no
`plan`.
A solução é [limpar o estado local](#limpando-estado-local) e [re-aplicar](#aplicar-configurações) a configuração.

