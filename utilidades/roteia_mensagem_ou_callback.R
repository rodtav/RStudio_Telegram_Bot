roteia_mensagem_ou_callback <- function(bot, update, db_con, dados_usuario) {
  
  # Checa se existe uma conversa ativa para o usuário
  resultado <- dbGetQuery(db_con, sprintf("SELECT comando,estado FROM conversas WHERE id_usuario = %.0f;", dados_usuario['id_usuario']))
  comando <- resultado[1,"comando"]
  estado <- resultado[1,"estado"]
  
  tem_conversa <- (nrow(resultado) != 0)
  
  if (tem_conversa) {
    
    # Se tiver conversa ativa, roda o próximo comando dela
    do.call(paste(comando, "_", estado, sep=''), list(bot,update,db_con,dados_usuario))
    
  } else {
    
    # Se não tiver conversa ativa, envia mensagem
    bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Você ainda não iniciou nenhum comando!")
    
  }
  
}