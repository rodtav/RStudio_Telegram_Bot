salva_resposta <- function (bot, update, db_con, dados_usuario, questionario, estado, resposta) {
  
  # Lê timestamp atual e formata
  data_resposta <- format(as.POSIXct(Sys.time(), tz = "America/Sao_Paulo"), "%Y-%m-%d %H:%M:%S %Z")

  # Converte para resposta para manter a estrutura
  resposta <- as.character(resposta)
  
  # Monta linha completa para inserir no csv de respostas
  dados_resposta <- data.frame(id_usuario = c( dados_usuario['id_usuario'] ),
                                questionario = c( questionario ),
                                pergunta = c( estado ),
                                resposta = c( resposta ),
                                data_resposta = c( data_resposta )
                               )

  # Escrever o dataframe atualizado de volta ao arquivo CSV
  write.table(dados_resposta,
            file = caminho_arquivo_respostas,
            sep = ";",
            append = TRUE,
            col.names = FALSE,
            row.names = FALSE)

}