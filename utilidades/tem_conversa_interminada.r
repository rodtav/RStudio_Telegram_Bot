tem_conversa_interminada <- function(bot, update, db_con, dados_usuario) {
  
  # Checa se já existe conversa interminada
  resultado <- dbGetQuery(db_con, sprintf("SELECT * FROM conversas WHERE id_usuario = %.0f;", dados_usuario['id_usuario']))
  comando_iniciado <- resultado[1,"comando"]
  
  tem_conversa_interminada <- (nrow(resultado) != 0)
  
  if (tem_conversa_interminada) {
    
    # Se existir, envia mensagem
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = sprintf("Você não pode usar este comando agora, porque você ainda não terminou um diálogo do comando %s!", comando_iniciado))
                    
  }
  return(tem_conversa_interminada)
}