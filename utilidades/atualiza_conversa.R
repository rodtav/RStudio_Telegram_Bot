atualiza_conversa <- function (bot, update, db_con, dados_usuario, novo_estado, nova_pergunta) {
  
  resultado <- dbSendStatement(db_con, sprintf("UPDATE conversas SET estado = %.0f, pergunta = %.0f WHERE id_usuario = %.0f;", novo_estado, nova_pergunta, dados_usuario['id_usuario']))
  dbClearResult(resultado)
  
}