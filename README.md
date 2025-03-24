# fiap-lanchonete-infra

Repositório contendo a configuração (Terraform) do EKS, API Gateway, e VPC compartilhado para viabilizar o deploy da API
principal do projeto.

## Tutorial em video
Fizemos um tutorial em vídeo explicando todo o processo de deploy da API com Terraform, desde o clone dos repositórios até o teste de requisições em produção. Confira no link abaixo:
https://www.youtube.com/watch?v=X9SdKJ1l160

## Deploy pelo CI/CD
É necessário ter acesso as credenciais da organização para executar esse passo.
Caso não esteja disponível, veja o tutorial de deploy manual abaixo. 

### Instale o Github CLI

Siga as instruções desse link:
https://github.com/cli/cli#installation

### Faça o login com as credenciais da organização

Digite

```
gh auth login
```

Escolha a opção `Github.com`, depois `HTTPS` e então `Paste an authentication token`.

Insira seu token e pressione enter.

### Execute o comando para iniciar o deploy no Github Actions

```
echo '{
"aws_access_key":"",
"aws_secret_access_key":"",
"aws_session_token":"",
"pat":""}' | gh workflow run trigger-workflow.yml --ref main --json
```

Obs: PAT é o token da organização

Argumentos opcionais para se incluir no json:

```
"mercado_api_key":
"id_conta":
"id_loja":
"url_notificacao":
"aws_region":
"db_password":
```

## Ordem de execução

A maioria dos projetos nessa organização exporta e importa estados no backend compartilhado do Terraform (utilizando
HCP).
Sendo assim, no primeiro deploy, os projetos devem ser executados na seguinte ordem:

```
fiap-lanchonete-auth
fiap-lanchonete-infra
fiap-lanchonete-db
fiap-lanchonete-api
```

**Importante**: esse passo só é necessário caso você esteja "subindo" o projeto pela primeira vez,
como em uma troca de organização do HCP ou troca de conta do AWS.
Essa ordem garante que os projetos exportarão as variaveis necessárias no backend compartilhado corretamente.  
Nos demais casos (como CI/CD, execuções do `terraform apply` posteriores),
a ordem de execução não é importante.

## Instalação e Execução

### Pre-requisitos

Certifique-se de ter instalado uma versão recente da CLI do `terraform` e do `aws`.

### Autenticação no AWS CLI

É necessário autenticar-se com o `AWS` para viabilizar o deploy desse projeto.  
https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-authentication.html

### Variaveis de ambiente

É necessário criar algumas variaveis de ambiente para viabilizar a aplicação das configurações pelo CLI do Terraform.  
Para ambiente local, basta utilizar o arquivo `dev.auto.tfvars.example` como exemplo, criando um `dev.auto.tfvars`
correspondente:

```hcl
aws_access_key        = "ASIAVEZQ3WJY2KR216362"
aws_secret_key        = "TU+qlmgcNsX5MQz1238214821748211"
aws_token_key         = "123872183721857128............."
db_url = "mysql:3306" # recebido APÓS a subida do RDS, altere assim que finalizar o deploy do fiap-lanchonete-db (AWS RDS).
db_username = "fiap" # correspondente ao valor especificado no fiap-lanchonete-db (AWS RDS)
db_password = "fiap-lanchonete" # correspondente ao valor especificado no fiap-lanchonete-db (AWS RDS)
mercado_pago_api_key  = "TEST-8402790990254628-112619-4290252fdac6fd07a3b8bb555578ff39-662144664"
mercado_pago_id_loja  = "1B2D92F23"
mercado_pago_id_conta = "662144664"
```

_Atenção: essas credenciais são inválidas (exceto as relacionadas ao MercadoPago), e servem apenas como exemplo.
Você deve obter as credenciais corretas do próprio ambiente da AWS. Todas as variáveis são obrigatórias._

Para ambientes de teste, pode-se utilizar essas variaveis relacionadas ao MercadoPago:

```hcl
mercado_pago_api_key  = "TEST-8402790990254628-112619-4290252fdac6fd07a3b8bb555578ff39-662144664"
mercado_pago_id_loja  = "1B2D92F23"
mercado_pago_id_conta = "662144664"
```

A tabela abaixo relaciona as credenciais especificadas nas variaveis do Terraform com as presentes no arquivo
`~/.aws/credentials`.

| tfvars         | ~/.aws/credentials    |
| -------------- | --------------------- |
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

**Atenção**: o processo de deploy pode levar até 15 minutos.

## Erros comuns

**Importante**: Caso seja a primeira "subida" do projeto, siga a ordem de execução
especificada [aqui](#ordem-de-execução).

### Permissões

Verifique se o usuario executante tem permissões para criações de instâncias do AWS EKS, AWS EKS NodeGroups, VPC e
Subnets.

### AWS com LabRole

Devido a natureza efêmera da instância de AWS utilizada pelo AWS Instructure, pode ser que você receba erros ao executar
o
`terraform plan` ou `terraform apply` depois da primeira execução.  
Por esse motivo, recomendamos [limpar o estado local](#limpando-estado-local) do
Terraform sempre que subir uma nova instância do AWS Lab.

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

E em seguida reiniciar os módulos:

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

#### Error: Search returned 0 results, please revise so only one is returned

```
│ Error: Search returned 0 results, please revise so only one is returned
│
│   with module.api_gateway.data.aws_lb.fiap_lanchonete_nlb,
│   on modules/api_gateway/main.tf line 12, in data "aws_lb" "fiap_lanchonete_nlb":
│   12: data "aws_lb" "fiap_lanchonete_nlb" {
│
╵
```

Esse erro pode acontecer devido a necessidade do `NLB`, componente do `AWS Load Balancer`, estar como `READY`
antes da configuração do `API Gateway`. Isso também pode acontecer caso você não esteja corretamente autenticado na
`AWS CLI`.  
A solução é garantir que a o NLB esteja disponível antes de executar o apply, o que significa aguardar alguns segundos
até o recurso terminar de ser provido, e executar o comando `terraform apply`.

#### Error: error deleting API Gateway VPC Link (ox6a0g): BadRequestException: Cannot delete vpc link.

```
Error: error deleting API Gateway VPC Link (ox6a0g): BadRequestException: Cannot delete vpc link. Vpc link 'ox6a0g', is referenced in [ANY:kx106x:dev] in format of [Method:Resource:Stage].
```

Esse é um erro ocasionado pela exigência do provedor de Terraform AWS de destruir e recriar as entidades relacionadas ao
API Gateway.  
Caso aconteça, a única forma de resolver é excluindo o VPC Link e os itens relacionados ao API Gateway diretamente do
dashboard  
da AWS, incluindo as informações do Cloudfront.
Fonte: https://github.com/hashicorp/terraform-provider-aws/issues/12195

#### NLB is already associated with another VPC Endpoint Service

```
╷
│ Error: waiting for API Gateway VPC Link (jwqd3s) create: unexpected state 'FAILED', wanted target 'AVAILABLE'. last error: NLB is already associated with another VPC Endpoint Service
│
│   with module.api_gateway.aws_api_gateway_vpc_link.fiap_lanchonete_vpc_link,
│   on modules/api_gateway/2-vpc_link.tf line 14, in resource "aws_api_gateway_vpc_link" "fiap_lanchonete_vpc_link":
│   14: resource "aws_api_gateway_vpc_link" "fiap_lanchonete_vpc_link" {
```

Este erro pode ocorrer durante a re-criação do VPC link, afirmando que o LoadBalancer do VPC já está associado a outro
recurso.  
Infelizmente, a unica maneira de resolver é desassociar manualmente o recurso pela interface do AWS ou pelo `AWS CLI`:  
https://repost.aws/knowledge-center/elb-fix-nlb-associated-with-service
