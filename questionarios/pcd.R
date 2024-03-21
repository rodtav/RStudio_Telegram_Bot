pcd_0 <- function(bot, update, db_con, dados_usuario){
  
  # Cria um InlineKeyboardMarkup com as opções disponíveis
  IKM <- InlineKeyboardMarkup(
    inline_keyboard=list(
      list(InlineKeyboardButton(text="Sim", callback_data=1)),
      list(InlineKeyboardButton(text="Não", callback_data=2)),
      list(InlineKeyboardButton(text="Prefiro não responder", callback_data=3))))
  
  # Envia pergunta
  bot$sendMessage(chat_id = dados_usuario['chat_id'],
                  text = "Você é uma pessoa com deficiência?",
                  reply_markup = IKM)
  
  # Atualiza o estado da conversa
  novo_estado <- 1
  atualiza_conversa(bot, update, db_con, dados_usuario, novo_estado, novo_estado)
}

pcd_1 <- function(bot, update, db_con, dados_usuario){
  
  # Remove as opções do keyboard
  bot$editMessageReplyMarkup(chat_id=dados_usuario['chat_id'],
                             message_id=update$callback_query$message$message_id,
                             reply_markup=NULL)
  
  # Obtém informações sobre o comando e o estado
  comando_estado <- retorna_comando_estado(bot, update, db_con, dados_usuario, sys.call()[[1]])
  questionario <- comando_estado['comando']
  estado <- comando_estado['estado']
  
  # Lê resposta e salva
  resposta <- update$callback_query$data
  salva_resposta(bot, update, db_con, dados_usuario, questionario, estado, resposta)
  
  if (resposta != 1) {
    
    # Se não for PCD, encerra conversa
    encerra_conversa(bot, update, db_con, dados_usuario)
    bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Você finalizou o questionário!")
    
  } else {
    
    # Cria InlineKeyboardMarkup dacom opções da próxima pergunta
    IKM <- InlineKeyboardMarkup(
      inline_keyboard=list(
        list(InlineKeyboardButton(text="Visual", callback_data=1)),
        list(InlineKeyboardButton(text="Auditiva", callback_data=2)),
        list(InlineKeyboardButton(text="Física", callback_data=3)),
        list(InlineKeyboardButton(text="Intelectual", callback_data=4)),
        list(InlineKeyboardButton(text="Transtorno do Espectro Autista", callback_data=5)),
        list(InlineKeyboardButton(text="Múltipla", callback_data=6)),
        list(InlineKeyboardButton(text="Outra", callback_data=7))))
    
    # Faz próxima pergunta
    bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Qual é o seu tipo de deficiência?",
                    reply_markup = IKM)
    
    # Atualiza o estado da conversa
    novo_estado <- 2
    atualiza_conversa(bot, update, db_con, dados_usuario, novo_estado, novo_estado)
    
  }
}

pcd_2 <- function(bot, update, db_con, dados_usuario){
  
  # Remove as opções do keyboard
  bot$editMessageReplyMarkup(chat_id=dados_usuario['chat_id'],
                             message_id=update$callback_query$message$message_id,
                             reply_markup=NULL)
  
  # Obtém informações sobre o comando e o estado
  comando_estado <- retorna_comando_estado(bot, update, db_con, dados_usuario, sys.call()[[1]])
  questionario <- comando_estado['comando']
  estado <- comando_estado['estado']
  
  # Lê resposta e salva
  resposta = update$callback_query$data

  salva_resposta(bot, update, db_con, dados_usuario, questionario, estado, resposta)

  
  if (resposta != 7) {
    
    # Se resposta foi específica, encerra a conversa
    encerra_conversa(bot, update, db_con, dados_usuario)
    bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Você finalizou o questionário!")
    
  } else {
    
    # Se resposta foi 'outra', pergunta qual
    bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Especifique o seu tipo de deficiência?")
    
    # Atualiza o estado da conversa
    novo_estado <- 3
    atualiza_conversa(bot, update, db_con, dados_usuario, novo_estado, novo_estado)
    
  }
}

pcd_3 <- function(bot, update, db_con, dados_usuario){
  
  # Obtém informações sobre o comando e o estado
  comando_estado <- retorna_comando_estado(bot, update, db_con, dados_usuario, sys.call()[[1]])
  questionario <- comando_estado['comando']
  estado <- comando_estado['estado']
  
  # Lê resposta textual e salva
  resposta = update$message$text
  salva_resposta(bot, update, db_con, dados_usuario, questionario, estado, resposta)
  
  # Encerra conversa
  encerra_conversa(bot, update, db_con, dados_usuario)
  bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Você finalizou o questionário!")

}