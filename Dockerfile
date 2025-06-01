# Dockerfile
FROM ruby:3.3.1

# Dependências básicas
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Cria diretório da aplicação
WORKDIR /app

# Instala bundler
RUN gem install bundler

# Copia os arquivos de dependências
COPY Gemfile Gemfile.lock ./

# Instala as gems
RUN bundle install --jobs $(nproc) --retry 3

# Copia o restante da aplicação
COPY . .

# Script de inicialização
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Porta padrão
EXPOSE 3000

# Comando padrão
CMD ["rails", "server", "-b", "0.0.0.0"]
