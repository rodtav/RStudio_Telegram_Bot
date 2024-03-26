retorna_dados_questionarios <- function(bot, update, db_con, dados_usuario, catalogo_questionarios) {
  
  # Inicializa dicionário vazio (insere chave e remove ela)
  #dados_questionarios <- Dict$new(dummy_key = NULL)$remove("dummy_key")
  
  dados_questionarios <- list()
  
  # Iterar pelas linhas do dataframe
  lapply(1:nrow(catalogo_questionarios), function(i) {
    
    nome_arquivo <- paste(caminho_arquivos_questionarios,"/",catalogo_questionarios$Arquivo[i],sep="")
    
    # Verificar o tipo de arquivo e ler o conteúdo
    if (grepl("\\.xlsx$", dados$Arquivo[i])) {
      
      df <- read_excel(catalogo_questionarios$Arquivo[i])
      
    } else if (grepl("\\.xls$", dados$Arquivo[i])) {
      
      df <- readxl::read_xls(catalogo_questionarios$Arquivo[i])
      
    } else if (grepl("\\.csv$", dados$Arquivo[i])) {
      
      df <- read.csv(catalogo_questionarios$Arquivo[i])
      
    } else {
      
      stop("Formato de arquivo não suportado: ", catalogo_questionarios$Arquivo[i])
      
    }
    
    # Inserir no dicionário usando o Identificador como chave
    dados_questionarios[[as.character(dados$Identificador[i])]] <- df
  })
}