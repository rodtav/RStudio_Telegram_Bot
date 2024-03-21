socioeconomico_0 <- function(bot, update, db_con, dados_usuario) {

  # Define o identificador
  comando_estado <- retorna_comando_estado(bot, update, db_con, dados_usuario, sys.call()[[1]])
  questionario <- comando_estado['comando']
  arquivo_questionario <- paste(questionario,".csv",sep="")

  # Lê os dados do questionário atual
  dados_questionario <- read.table(file.path(caminho_arquivos_questionarios,arquivo_questionario),
                                     stringsAsFactors = FALSE,
                                     header = TRUE,
                                     sep = ";")
  # Remove linhas sem pergunta
  dados_questionario <- dados_questionario[dados_questionario[, 1] != "", ]
  
  # Retorna pergunta atual
  numero_pergunta <- retorna_numero_pergunta(bot, update, db_con, dados_usuario)
  
  # Obtém o texto da próxima pergunta e a lista de respostas
  texto_pergunta <- dados_questionario[numero_pergunta,1]
  lista_respostas <- dados_questionario[numero_pergunta, -c(1)]
  
  # Remove colunas sem resposta
  lista_respostas <- lista_respostas[, colSums(lista_respostas != "") > 0]
  
  # Lista para armazenar os botões de resposta
  inline_keyboard <- list()
  
  # Itera sobre as linhas do dataframe
  for (i in 1:ncol(lista_respostas)) {
    # Cria um botão para cada resposta
    button <- InlineKeyboardButton(
      text = lista_respostas[1,i],
      callback_data = i
    )
    # Adiciona o botão à lista
    inline_keyboard[[i]] <- list(button)
  }

  # Cria o objeto InlineKeyboardMarkup
  IKM <- InlineKeyboardMarkup(inline_keyboard = inline_keyboard)

  # Envia pergunta
  bot$sendMessage(chat_id = dados_usuario['chat_id'],
                  text = texto_pergunta,
                  reply_markup = IKM)

  # Atualiza o estado da conversa
  novo_estado <- 1
  nova_pergunta <- numero_pergunta
  atualiza_conversa(bot, update, db_con, dados_usuario, novo_estado, nova_pergunta)
  
}

socioeconomico_1 <- function(bot, update, db_con, dados_usuario) {
  
  # Remove as opções do keyboard
  bot$editMessageReplyMarkup(chat_id=dados_usuario['chat_id'],
                             message_id=update$callback_query$message$message_id,
                             reply_markup=NULL)
  
  # Define o identificador
  comando_estado <- retorna_comando_estado(bot, update, db_con, dados_usuario, sys.call()[[1]])
  questionario <- comando_estado['comando']
  arquivo_questionario <- paste(questionario,".csv",sep="")

  # Lê os dados do questionário atual
  dados_questionario <- read.table(file.path(caminho_arquivos_questionarios,arquivo_questionario),
                                   stringsAsFactors = FALSE,
                                   header = TRUE,
                                   sep = ";")
  # Remove linhas sem pergunta
  dados_questionario <- dados_questionario[dados_questionario[, 1] != "", ]
    
  # Retorna pergunta atual
  numero_pergunta <- retorna_numero_pergunta(bot, update, db_con, dados_usuario)
    
  # Lê a resposta e salva
  resposta = update$callback_query$data
  salva_resposta(bot, update, db_con, dados_usuario, questionario, numero_pergunta, resposta) 

  
  # Encerra conversa se estiver na última pergunta
  if (numero_pergunta == nrow(dados_questionario)) {
    
    # Encerra conversa
    encerra_conversa(bot, update, db_con, dados_usuario)
    bot$sendMessage(chat_id = dados_usuario['chat_id'],
                    text = "Você finalizou o questionário!")
    
    # Sai da função
    return()
  }
  
  # Atualiza o estado da conversa
  novo_estado <- 0
  nova_pergunta <- numero_pergunta + 1
  atualiza_conversa(bot, update, db_con, dados_usuario, novo_estado, nova_pergunta)
  
  # Chama a função 0 para fazer uma nova pergunta
  do.call(paste(questionario, "_", novo_estado, sep=''), list(bot,update,db_con,dados_usuario))
}



