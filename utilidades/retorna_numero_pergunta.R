retorna_numero_pergunta <- function(bot, update, db_con, dados_usuario) {
  
  # Consulta na base o numero da pergunta com base no id_usuario
  resultado <- dbGetQuery(db_con, sprintf("SELECT pergunta FROM conversas WHERE id_usuario = %.0f;", dados_usuario['id_usuario']))
  pergunta <- resultado[1,"pergunta"]
  
  return(pergunta)
  
}