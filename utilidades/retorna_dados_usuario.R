retorna_dados_usuario <- function(bot, update, db_con) {
  
  # Ler id_telegram e chat_id seja de message ou de callback
  id_telegram <- coalesce(update$message$from$id, update$callback_query$from$id)
  chat_id <- coalesce(update$message$chat_id, update$callback_query$message$chat$id)
  
  # Consulta na base o id_usuario com base no id_telegram
  resultado <- dbGetQuery(db_con, sprintf("SELECT id_usuario FROM usuarios WHERE id_telegram = %.0f;", id_telegram))
  id_usuario <- resultado[1,"id_usuario"]
  
  # Monta um dicionario com os dados do usuario
  dados_usuario <- Dict$new(
    id_telegram = id_telegram,
    id_usuario = id_usuario,
    chat_id = chat_id
  )
  
  return(dados_usuario)
  
}