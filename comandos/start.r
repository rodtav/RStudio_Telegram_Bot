iniciar_0 <- function(bot, update, db_con, dados_usuario) {
  
  # Leitura inicial de informações
  primeiro_nome <- update$message$from$first_name
  sobrenome <- update$message$from$last_name
  
  # Junta o primeiro nome com o sobrenome e retira espaços em branco de ambos os lados
  nome_completo <- trimws(paste(primeiro_nome, sobrenome), "both")
  
  # Checa se o usuario é novo
  resultado <- dbGetQuery(db_con, sprintf("SELECT * FROM usuarios WHERE id_telegram = %.0f;", dados_usuario["id_telegram"]))
  usuario_novo <- (nrow(resultado) == 0)
  
  # Insere o usuário novo na tabela usuarios ou atualiza o nome do usuario existente
  if (usuario_novo) {
    resultado <- dbSendStatement(db_con, sprintf("INSERT INTO usuarios (nome, id_telegram) VALUES ('%s', %.0f);", nome_completo, dados_usuario["id_telegram"]))
  } else {
    resultado <- dbSendStatement(db_con, sprintf("UPDATE usuarios SET nome = '%s' WHERE id_telegram = %.0f;", nome_completo, dados_usuario["id_telegram"]))
  }
  dbClearResult(resultado)
  
  # Recupera o id_usuario
  resultado <- dbGetQuery(db_con, sprintf("SELECT id_usuario FROM usuarios WHERE id_telegram = %.0f;", dados_usuario["id_telegram"]))
  id_usuario <- resultado[1,"id_usuario"]
  
  # Remove quaisquer conversas existentes
  resultado <- dbSendStatement(db_con, sprintf("DELETE FROM conversas WHERE id_usuario = %.0f;", id_usuario))
  dbClearResult(resultado)
  
  # Envia mensagem inicial
  bot$sendMessage(chat_id = dados_usuario["chat_id"],
                  text = sprintf("Olá %s, sou um bot feito em R para ajudar a responder questionários.",
                                 nome_completo))
}