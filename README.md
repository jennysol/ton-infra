# TON API Infrastructure

Este repositório contém a infraestrutura como código (IaC) para o deploy de uma API Nest.js utilizando AWS Elastic Beanstalk e banco de dados DynamoDB, provisionados através do Terraform.

## Arquitetura

A infraestrutura provisionada inclui:

- **AWS Elastic Beanstalk**: Aplicação Node.js 22 em Amazon Linux 2023
- **DynamoDB**: Banco de dados NoSQL com índice secundário global
- **IAM**: Roles e políticas para acesso seguro aos recursos
- **S3**: Bucket para armazenamento de artefatos de deploy

## Estrutura do Projeto

```
├── main.tf         # Configuração principal do Terraform e provider AWS
├── locals.tf       # Variáveis locais do projeto
├── eb.tf           # Configuração do Elastic Beanstalk
├── dynamodb.tf     # Configuração da tabela DynamoDB
├── iam.tf          # Roles e políticas IAM
├── s3.tf           # Bucket S3 para deploy
```

## Recursos Provisionados

### DynamoDB
- **Tabela**: `ton-app`
- **Modo de Billing**: PROVISIONED
- **Capacidade de Leitura**: 20 RCU
- **Capacidade de Escrita**: 20 RCU
- **Chaves**: Primary Key (`pk`, `sk`) e Global Secondary Index (`gsi1pk`, `gsi1sk`)
- **TTL**: Habilitado no atributo `TimeToExist`

### Elastic Beanstalk
- **Aplicação**: `ton-api`
- **Ambiente**: `ton-api-environment`
- **Plataforma**: Node.js 22 em Amazon Linux 2023
- **Região**: us-east-1

### Variáveis de Ambiente Configuradas
- `PORT`: 5000
- `NODE_ENV`: production
- `DYNAMODB_ENDPOINT`: https://dynamodb.us-east-1.amazonaws.com
- `JWT_SECRET`: secret
- `SALT_ROUNDS`: 12

### IAM
- **Role EC2**: `aws-elasticbeanstalk-ec2-role` com permissões para:
  - Elastic Beanstalk Web Tier
  - Multicontainer Docker
  - CloudWatch Agent
  - Operações DynamoDB (GetItem, PutItem, Query, Scan, etc.)

## Pré-requisitos

1. **Terraform**: >= 1.0
2. **AWS CLI**: Configurado com credenciais válidas
3. **Conta AWS**: Com permissões para criar recursos EC2, DynamoDB, IAM, S3 e Elastic Beanstalk

## Configuração das Credenciais AWS

Certifique-se de ter as credenciais AWS configuradas:

```bash
aws configure
```

Ou configure as variáveis de ambiente:
```bash
export AWS_ACCESS_KEY_ID="access-key"
export AWS_SECRET_ACCESS_KEY="secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

## Deploy

### 1. Inicializar o Terraform
```bash
terraform init
```

### 2. Validar a configuração
```bash
terraform validate
```

### 3. Planejar as mudanças
```bash
terraform plan
```

### 4. Aplicar a infraestrutura
```bash
terraform apply
```


## Verificação do Deploy

Após o deploy bem-sucedido, você pode verificar:

1. **Elastic Beanstalk**: Acesse o console AWS e verifique se a aplicação está rodando
2. **DynamoDB**: Confirme se a tabela `ton-app` foi criada com os índices corretos
3. **S3**: Verifique se o bucket foi criado

## Limpeza

Para destruir todos os recursos criados:

```bash
terraform destroy
```


## Estrutura do DynamoDB

### Tabela Principal: ton-app
- **Partition Key**: `pk` (String)
- **Sort Key**: `sk` (String)

### Global Secondary Index: gsi1pk-gsi1sk-index
- **Partition Key**: `gsi1pk` (String) 
- **Sort Key**: `gsi1sk` (String)
- **Projeção**: ALL
- **Capacidade**: 5 RCU / 5 WCU

