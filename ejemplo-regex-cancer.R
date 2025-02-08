library(tidyverse)
library(stopwords)
library(stringdist)

# Función para preprocesar el texto
preprocess_text <- function(text) {
  # Convertir texto a minúsculas
  text <- tolower(text)
  
  # Quitar signos de puntuación
  text <- gsub("[[:punct:]]", "", text)
  
  # Quitar acentos
  text <- iconv(text, to = "ASCII//TRANSLIT")
  
  # Separar el texto en palabras
  words <- unlist(strsplit(text, "\\s+"))
  
  # Cargar stopwords en español
  stopwords_es <- stopwords::stopwords("es")
  
  # Quitar las stopwords
  words <- words[!words %in% stopwords_es]
  
  # Eliminar palabras duplicadas
  words <- unique(words)
  
  # Unir las palabras nuevamente en un texto
  processed_text <- paste(words, collapse = " ")
  
  return(processed_text)
}

# Definir palabras claves relacionadas con cáncer
keywords <- c(
  "mieloma",
  "linfom[a|as]*",
  "\\b(tumor\\s+maligno?)\\b",
  "\\b(lesi.n\\s+maligna?)\\b",
  "tumor",
  "cancer",
  "neoplasia",
  "sarcoma",
  "masa",
  "maligno",
  "adenocarcinoma",
  "carcinoma",
  "paliativ[o|a|as]",
  "quimioterapia",
  "\\bqmt\\b",
  "radioterapia",
  "^(ca|á)$",
  "^tu$",
  "leucemia",
  "mielodispl.[sia|sico]*",
  "lesi.n\\s.neo.+",
  "\\b(ca)\\b",
  "cbc",
  "melanoma",
  "cacu",
  "(cacu)\\s(?!\\(-\\))",
  "si oncologico",
  "metastasic[o|a|as]",
  "metastasis",
  "oncologico",
  "\\stu\\s",
  "lesion sospechosa",
  "\\blesion\\s+(maligna|focal|extensa)\\b",
  "\\blesion(?:es)?\\spulmonar(?:es)?\\b"
)

# Definir expresiones regulares para códigos ICD-10
regex_icd10 <- c(
  "c[0-9]{1,2}.*?",      # Cubre c00-c99
  "d0[0-9].*?",           # Cubre d00-d09
  "d3[7-9].*?",           # Cubre d37-d39
  "d4[0-9].*?"            # Cubre d40-d49
)

# Expresiones regulares para términos benignos
benign_expressions <- c(
  "(benign[o|a]|benign[as|os])",
  "(no neoplasic[o|a])",
  "(no oncologic[o|a])",
  "(no indica oncologico)",
  "(tumores benignos)"
)

# Definir una función para calcular la similitud de Levenshtein
calc_sim_levenshtein <- function(keyword, text) {
  words <- unlist(strsplit(text, "\\s+"))
  scores <- sapply(words, function(word) stringdist::stringdist(tolower(keyword), tolower(word), method = "lv"))
  return(min(scores))
}

# Definir un umbral de similitud para considerar una coincidencia
threshold <- 2

# Función para clasificar el texto
classify_cancer <- function(text) {
  text <- tolower(text)
  
  # Verificar términos benignos
  if (any(str_detect(text, regex(paste(benign_expressions, collapse = "|"), ignore_case = TRUE)))) {
    return(list(positive = FALSE, keywords_found = NA, icd10_found = NA))
  }
  
  # Buscar coincidencias con palabras clave
  matches_keywords <- str_extract_all(text, regex(paste(keywords, collapse = "|"), ignore_case = TRUE))[[1]]
  
  # Buscar coincidencias con códigos ICD-10
  matches_icd10 <- str_extract_all(text, regex_icd10)[[1]]
  
  # Evaluar similitud de Levenshtein para palabras similares
  lev_matches <- sapply(keywords, function(keyword) ifelse(calc_sim_levenshtein(keyword, text) <= threshold, keyword, NA))
  lev_matches <- na.omit(lev_matches)
  
  # Evaluar si hay coincidencias
  if (length(matches_keywords) > 0 || length(matches_icd10) > 0 || length(lev_matches) > 0) {
    return(list(
      positive = TRUE,
      keywords_found = ifelse(length(matches_keywords) > 0, paste(matches_keywords, collapse = ", "), ifelse(length(lev_matches) > 0, paste(lev_matches, collapse = ", "), NA)),
      icd10_found = ifelse(length(matches_icd10) > 0, paste(matches_icd10, collapse = ", "), NA)
    ))
  }
  
  return(list(positive = FALSE, keywords_found = NA, icd10_found = NA))
}



# Solicitar al usuario que ingrese un texto
text <- readline("Por favor, ingresa un texto: ")
classify_cancer(preprocess_text(text))
