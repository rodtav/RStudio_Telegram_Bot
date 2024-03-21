##https://cran.r-project.org/web/packages/telegram.bot/telegram.bot.pdf

library(telegram.bot)
library(DBI)
library(RMariaDB)
library(Dict)
library(dplyr)

################################################################################

caminho_arquivo_catalogo_questionarios <- "/home/arquivos/catalogo_questionarios.csv"
caminho_arquivo_respostas <- "/home/arquivos/respostas.csv"
caminho_arquivos_comandos <- "/home/arquivos/comandos"
caminho_arquivos_utilidades <- "/home/arquivos/utilidades"
caminho_arquivos_questionarios <- "/home/arquivos/questionarios"

################################################################################

# Fechar todas as conexões
#lapply(dbListConnections(RMariaDB::MariaDB()), dbDisconnect)

# Conexão com o banco de dados mysql
db_con <- dbConnect(RMariaDB::MariaDB(),
                    dbname=Sys.getenv("RBOT_TELEGRAM_DBNAME"),
                    host=Sys.getenv("RBOT_TELEGRAM_DBHOST"),
                    port=Sys.getenv("RBOT_TELEGRAM_DBPORT"),
                    username=Sys.getenv("RBOT_TELEGRAM_DBUSERNAME"),
                    password=Sys.getenv("RBOT_TELEGRAM_DBPASSWORD"))

################################################################################

# Adicionar os arquivos de comandos, utilidades e questionarios
arquivos_comandos <- list.files(path=caminho_arquivos_comandos,
                                pattern = "*.r",full.names = TRUE,ignore.case = TRUE)

arquivos_utilidades <- list.files(path=caminho_arquivos_utilidades,
                                  pattern = "*.r",full.names = TRUE,ignore.case = TRUE)

arquivos_questionarios <- list.files(path=caminho_arquivos_questionarios,
                                     pattern = "*.r",full.names = TRUE,ignore.case = TRUE)

sapply(c(arquivos_comandos, arquivos_utilidades, arquivos_questionarios), source, .GlobalEnv)

################################################################################

# Inicializar o updater do telegram
updater <- Updater(Sys.getenv("RBOT_TELEGRAM_TOKEN"))

################################################################################

# Fluxo do comando start
iniciar <- function(bot, update){
  
  dados_usuario <- retorna_dados_usuario(bot, update, db_con)
  iniciar_0(bot, update, db_con, dados_usuario)
  
}

updater <- updater + CommandHandler("start", iniciar)

################################################################################

# Fluxo do comando mudarnome
mudarnome <- function(bot, update){
  
  dados_usuario <- retorna_dados_usuario(bot, update, db_con)
  mudarnome_0(bot, update, db_con, dados_usuario)
}

updater <- updater + CommandHandler("mudarnome", mudarnome)

################################################################################

# Fluxo do comando questionarios
questionarios <- function(bot, update){
  
  dados_usuario <- retorna_dados_usuario(bot, update, db_con)
  questionarios_0(bot, update, db_con, dados_usuario)
  
}

updater <- updater + CommandHandler("questionarios", questionarios)

################################################################################

# Fluxo para callbacks
handler_callbacks <- function(bot, update) {
  
  dados_usuario <- retorna_dados_usuario(bot, update, db_con)
  roteia_mensagem_ou_callback(bot, update, db_con, dados_usuario)
  
}

updater <- updater + CallbackQueryHandler(handler_callbacks)

################################################################################

# Fluxo para mensagens novas
nova_mensagem <- function(bot, update){
  
  dados_usuario <- retorna_dados_usuario(bot, update, db_con)
  roteia_mensagem_ou_callback(bot, update, db_con, dados_usuario)
  
}

updater <- updater + MessageHandler(nova_mensagem)

################################################################################

# Iniciar o bot e, se acontecer um erro, desconectar do banco de dados
updater$start_polling(clean = TRUE, allowed_updates = c("message", "callback_query"))



