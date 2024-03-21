encerra_conversa <- function (bot, update, db_con, dados_usuario) {
  
  resultado <- dbSendStatement(db_con, sprintf("DELETE FROM conversas WHERE id_usuario = %.0f;", dados_usuario['id_usuario']))
  dbClearResult(resultado)
  
}