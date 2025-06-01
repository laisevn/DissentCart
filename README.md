# Documentação da API de Carrinhos de Compras

<div id="top"></div>

<br />
<div align="center">
  <h1 align="center">DissentCart</h1>

  <h3 align="center">
    API de Gerenciamento de Carrinhos de Compras, construído com Ruby on Rails 8.0.2 seguindo os princípios de Clean Code  e Service Objects.
    <br />
  </h3>

[![Ruby][Ruby]][Ruby]
[![Rails][Rails]][Rails]
[![PostgreSQL][PostgreSQL]][PostgreSQL]
[![Sidekiq][Sidekiq]][Sidekiq]
[![Redis][Redis]][Redis]

</div>

## Sumário

- [Documentação da API de Carrinhos de Compras](#documentação-da-api-de-carrinhos-de-compras)
  - [Sumário](#sumário)
  - [Sobre o Projeto](#sobre-o-projeto)
  - [Arquitetura e Design](#arquitetura-e-design)
  - [Configuração do Ambiente](#configuração-do-ambiente)
    - [Pré-requisitos](#pré-requisitos)
  - [Jobs Agendados](#jobs-agendados)
  - [Documentação da API](#documentação-da-api)
    - [Listagem de carrinho `GET /carts/:id`](#listagem-de-carrinho-get-cartsid)
    - [Adição de carrinho `POST /carts`](#adição-de-carrinho-post-carts)
    - [Atualização de item `POST /carts/add_item`](#atualização-de-item-post-cartsadd_item)
    - [Remove produto do carrinho DELETE `/carts/:product_id`](#remove-produto-do-carrinho-delete-cartsproduct_id)
  - [Dockerização e Ambiente de Testes](#dockerização-e-ambiente-de-testes)
    - [Script de Execução](#script-de-execução)

## Sobre o Projeto

API para gerenciamento de carrinhos de compras com:

- Operações CRUD para produtos em carrinhos
- Cálculo automático de totais
- Sistema de abandono de carrinhos
- Processamento assíncrono com Sidekiq
- Armazenamento em Redis para cache e filas

## Arquitetura e Design

A estrutura segue princípios de Clean Architecture com uma abordagem amigável e que não muda a estrutura do rails Api, com uma adição da camada de negócio.

1. **Use Cases** (`app/use_cases/`)

   - Lógica de negócio isolada
   - Herdam de BaseService para compartilhar comportamento comum

2. **Models**

   - Cart: Gerencia estado do carrinho e relações com os produtos
   - Product: Dados dos produtos

3. **Jobs**

   - AbandonCartsJob: Marca carrinhos abandonados
   - DeleteAbandonedCartsJob: Remove carrinhos antigos

4. **Services**
   - Cálculo do carrinho é guardado em cache com o redis para não bloquear ou sobrecarregar o banco de dados

## Configuração do Ambiente

### Pré-requisitos

- Ruby 3.4.4
- Docker
- Redis
- Sidekiq

## Jobs Agendados

Configuração em `config/sidekiq.yml`:

```yml
:schedule:
  abandon_carts_job:
    cron: "0 */3 * * *"
    class: AbandonCartsJob
    queue: default
  delete_abandoned_carts_job:
    cron: "0 0 * * *"
    class: DeleteAbandonedCartsJob
    queue: default
:concurrency: 5
```

## Documentação da API

### Listagem de carrinho `GET /carts/:id`

**Exemplo de Resposta:**

```json
{
  "id": 11,
  "products": [
    {
      "id": 123,
      "name": "Produto A",
      "quantity": 2,
      "unit_price": "3.50",
      "total_price": "3.50"
    }
  ],
  "total_price": 3.50
}
```

### Adição de carrinho `POST /carts`

**Parâmetros:**

```json
{ "product_id": 999, "quantity": 1 }
```

**Exemplo de Resposta:**

```json
{
  "id": 11,
  "products": [
    {
      "id": 123,
      "name": "Produto A",
      "quantity": 2,
      "unit_price": "3.50",
      "total_price": "7.00"
    },
    {
      "id": 999,
      "name": "Produto A",
      "quantity": 1,
      "unit_price": "3.50",
      "total_price": "3.50"
    }
  ],
  "total_price": 9.50
}
```

### Atualização de item `POST /carts/add_item`

**Parâmetros:**

```json
{ "product_id": 999, "quantity": 2 }
```

**Exemplo de Resposta:**

```json
{
  "id": 11,
  "products": [
    {
      "id": 123,
      "name": "Produto A",
      "quantity": 2,
      "unit_price": "3.50",
      "total_price": "7.00"
    },
    {
      "id": 999,
      "name": "Produto A",
      "quantity": 2,
      "unit_price": "3.50",
      "total_price": "7.00"
    }
  ],
  "total_price": 14.00
}
```

### Remove produto do carrinho DELETE `/carts/:product_id`

**Parâmetros:**

```bash
 product_id: 999
```

**Exemplo de Resposta:**

```json
{
  "id": 11,
  "products": [
    {
      "id": 123,
      "name": "Produto A",
      "quantity": 2,
      "unit_price": "3.50",
      "total_price": "7.00"
    }
  ],
  "total_price": 7.00
}
```

## Dockerização e Ambiente de Testes

### Script de Execução

O arquivo `run-docker.sh` automatiza a inicialização. Para rodar basta colar no console:

```bash
chmod +x ./run-docker.sh
./run-docker.sh
```
