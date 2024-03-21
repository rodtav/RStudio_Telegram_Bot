retorna_comando_estado <- function(bot, update, db_con, dados_usuario, info_funcao) {
  
  # Encontrar a posição do último "_"
  ultimo_underscore <- max(gregexpr("_", info_funcao)[[1]])
  
  # Extrair as partes
  comando <- substring(info_funcao, 1, ultimo_underscore - 1)
  estado <- as.integer(substring(info_funcao, ultimo_underscore + 1))
 
  # Monta um Dict com as informações
  comando_estado <- Dict$new(
    comando = comando,
    estado = estado
  )
  
  return(comando_estado)
  
}