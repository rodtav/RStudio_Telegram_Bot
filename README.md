# Bot para o Telegram feito no Rstudio
Este é um bot feito para o telegram utilizando a liguagem R.

## Objetivo
O objetivo deste bot é permitir a aplicação de questionários, preferencialmente a partir de questões e alternativas presentes em planilhas.

## Sobre bots do telegram
O Telegram possibilita a livre criação de bots por desenvolvedores, fornecendo uma [documentação](https://core.telegram.org/bots) detalhada sobre como criar bots.

## Bots de Telegram no R
O pacote [telegram.bot](https://github.com/ebeneditos/telegram.bot) implementa vários métodos disponíveis na API de bots do Telegram, contando também com uma [documentação](https://cran.r-project.org/web/packages/telegram.bot/telegram.bot.pdf) detalhada no CRAN.

## Visão geral
Para construir este bot, foram utilizados
* R como linguagem de programação
* Rstudio server como IDE para edição do código
* MySQL como banco de dados
* telegram.bot como pacote do R para interação com a API de bots do Telegram
* RMariaDB como pacote do R para interação com o banco de dados MySQL

## Variáveis de ambiente necessárias
Para funcionar, é necessário haver um arquivo com variáveis de ambiente .Renviron no mesmo diretório do código principal. Nesse arquivo, devem ser definidas as seguintes variáveis

| Variável                 | Definição                     |
|--------------------------|-------------------------------|
| RBOT_TELEGRAM_DBNAME     | Nome da database no MySql     |
| RBOT_TELEGRAM_DBHOST     | Host da database no MySql     |
| RBOT_TELEGRAM_DBPORT     | Port da database no MySql     |
| RBOT_TELEGRAM_DBUSERNAME | Username da database no MySql |
| RBOT_TELEGRAM_DBPASSWORD | Password da database no MySql |
| RBOT_TELEGRAM_TOKEN      | Token do bot do telegram      |







