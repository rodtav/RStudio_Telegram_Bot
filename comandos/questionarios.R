questionarios_0 <- function(bot, update, db_con, dados_usuario){

  # Confere se já existe uma conversa interminada. Se existir, uma mensagem é exibida e o comando não é executado.
  if (tem_conversa_interminada(bot, update, db_con, dados_usuario)) return(NULL)

  # Cria uma nova conversa
  nova_conversa(bot, update, db_con, dados_usuario, "questionarios")
  
  # Chama a primeira função do comando
  estado <- 1
  do.call(paste("questionarios","_", estado, sep=''), list(bot,update,db_con,dados_usuario))

}

questionarios_1 <- function(bot, update, db_con, dados_usuario){
  
  # Lê o catálogo de questionários
  catalogo_questionarios <- read.csv(caminho_arquivo_catalogo_questionarios,
                                     stringsAsFactors = FALSE,
                                     header = TRUE,
                                     sep = ";")
  
  # Lista para armazenar os botões
  inline_keyboard <- list()
  
  # Itera sobre as linhas do dataframe
  for (i in 1:nrow(catalogo_questionarios)) {
    # Cria um botão para cada questionário
    button <- InlineKeyboardButton(
      text = catalogo_questionarios$Nome[i],
      callback_data = catalogo_questionarios$Identificador[i]
    )
    # Adiciona o botão à lista
    inline_keyboard[[i]] <- list(button)
  }
  
  # Cria o objeto InlineKeyboardMarkup
  IKM <- InlineKeyboardMarkup(inline_keyboard = inline_keyboard)
  
  bot$sendMessage(chat_id = dados_usuario['chat_id'],
                  text = "Selecione um questionário:",
                  reply_markup = IKM)

  # Atualiza o estado da conversa
  novo_estado <- 2
  atualiza_conversa(bot,update,db_con,dados_usuario,novo_estado,novo_estado)
  
}

questionarios_2 <- function(bot, update, db_con, dados_usuario){
  
  # Remove as opções do keyboard
  bot$editMessageReplyMarkup(chat_id=dados_usuario['chat_id'],
                             message_id=update$callback_query$message$message_id,
                             reply_markup=NULL)
  
  # Lê o questionário selecionado
  questionario_selecionado = update$callback_query$data
  
  # Encerra a conversa
  encerra_conversa(bot, update, db_con, dados_usuario)
  
  # Cria novo questionário
  nova_conversa(bot,update,db_con, dados_usuario, questionario_selecionado)
  
  # Chama a primeira função do comando
  estado <- 0
  do.call(paste(questionario_selecionado,"_", estado, sep=''), list(bot,update,db_con,dados_usuario))
}

