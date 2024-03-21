mudarnome_0 <- function(bot, update, db_con, dados_usuario){
  
  # Confere se já existe uma conversa interminada. Se existir, uma mensagem é exibida.
  if (tem_conversa_interminada(bot, update, db_con, dados_usuario)) return(NULL)
  
  # Cria uma nova conversa
  nova_conversa(bot, update, db_con, dados_usuario, "mudarnome")
  
  # Chama a primeira função do comando
  estado <- 1
  do.call(paste("mudarnome","_", estado, sep=''), list(bot,update,db_con,dados_usuario))
  
}

mudarnome_1 <- function(bot, update, db_con, dados_usuario){
  
  # Envia mensagem perguntando o nome desejado
  bot$sendMessage(chat_id = dados_usuario['chat_id'],
                  text = sprintf("Por qual nome você quer ser chamado?"))
  
  # Atualiza o estado da conversa
  novo_estado <- 2
  atualiza_conversa(bot,update,db_con,dados_usuario,novo_estado,novo_estado)
}

mudarnome_2 <- function(bot, update, db_con, dados_usuario){
  
  # Lê o nome respondido
  novo_nome <- update$message$text
  
  # Atualiza o nome na base de dados
  resultado <- dbSendStatement(db_con, sprintf("UPDATE usuarios SET nome = '%s' WHERE id_usuario = %.0f;", novo_nome, dados_usuario['id_usuario']))
  dbClearResult(resultado)
  
  # Retorna mensagem de confirmação para o usuário
  bot$sendMessage(chat_id = dados_usuario['chat_id'],
                  text = sprintf("Seu nome foi alterado para %s!", novo_nome))
  
  # Encerra a conversa
  encerra_conversa(bot,update,db_con,dados_usuario)
}

