

<br />
<div align="center">
  <h1 align="center">DissentCart</h1>

  <h3 align="center">
    API de Gerenciamento de Carrinhos de Compras
    <br />
  </h3>

  [![Ruby][Ruby]][Ruby]
  [![Rails][Rails]][Rails]
  [![PostgreSQL][PostgreSQL]][PostgreSQL]
  [![Sidekiq][Sidekiq]][Sidekiq]
  [![Redis][Redis]][Redis]
</div>

## Sumário

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



<!-- ABOUT -->
## Sobre o Projeto

É uma API construída com o Rails API que usa processamento assíncrono com Sidekiq e armazenamento em Redis para cache e filas.

<p align="right">(<a href="#top">back to top</a>)</p>

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


<p align="right">(<a href="#top">back to top</a>)</p>

## Configuração do Ambiente

### Pré-requisitos

- Ruby 3.4.4
- Docker
- Redis
- Sidekiq

<p align="right">(<a href="#top">back to top</a>)</p>

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

<p align="right">(<a href="#top">back to top</a>)</p>

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

<p align="right">(<a href="#top">back to top</a>)</p>

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

<p align="right">(<a href="#top">back to top</a>)</p>

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

<p align="right">(<a href="#top">back to top</a>)</p>

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

<p align="right">(<a href="#top">back to top</a>)</p>

## Dockerização e Ambiente de Testes

### Script de Execução

O arquivo `run-docker.sh` automatiza a inicialização. Para rodar basta colar no console:

```bash
chmod +x ./run-docker.sh
./run-docker.sh
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- How to make badge shields https://shields.io/ -->
[Ruby]: https://img.shields.io/badge/Ruby-c01c28.svg?style=for-the-badge&logo=Ruby&logoColor=ffffff&labelColor=c01c28
[Rails]: https://img.shields.io/badge/Rails-f66151.svg?style=for-the-badge&logo=RubyonRails&logoColor=ffffff&labelColor=f66151
[PostgreSQL]: https://img.shields.io/badge/PostgreSQL-3584e4.svg?style=for-the-badge&logo=PostgreSQL&logoColor=ffffff&labelColor=3584e4
[Sidekiq]: https://img.shields.io/badge/Sidekiq-red?style=for-the-badge&logo=sidekiq
[Redis]: https://img.shields.io/badge/Redis-ed333b.svg?style=for-the-badge&logo=Redis&logoColor=ffffff&labelColor=ed333b