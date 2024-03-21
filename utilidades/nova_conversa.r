nova_conversa <- function (bot, update, db_con, dados_usuario, comando) {
  
  estado <- 0
  pergunta <- 1
  resultado <- dbSendStatement(db_con, sprintf("INSERT INTO conversas (comando, id_usuario, estado, pergunta) VALUES ('%s', %.0f, %.0f, %.0f);", comando,dados_usuario['id_usuario'],estado,pergunta))
  dbClearResult(resultado)
  
}
