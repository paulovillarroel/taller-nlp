# Cargar librerías
library(tidyverse)
library(tidytext)

# Crear un tibble con notas clínicas
notas_clinicas <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  texto = c(
    "El paciente presenta fiebre y tos persistente.",
    "Dolor abdominal y náuseas después de comer.",
    "El paciente refiere dolor en el pecho y dificultad para respirar.",
    "Se observa erupción cutánea y picazón en la piel.",
    "Paciente con síntomas de mareo y pérdida de equilibrio.",
    "El paciente tiene hipertensión arterial y sensación de fatiga.",
    "Se queja de dolor en las articulaciones y rigidez matutina.",
    "Paciente con síntomas de diarrea y vómitos desde hace dos días.",
    "El paciente presenta dolor de cabeza intenso y pérdida de visión periférica.",
    "Se reporta dolor en la espalda baja y limitación para moverse."
  )
)

# Tokenización en palabras
tokens_palabras <- notas_clinicas |> 
  unnest_tokens(word, texto)  # Tokeniza el texto columna en palabras

print(tokens_palabras)

# Usar stop_words para eliminar palabras comunes (stop words)
tokens_palabras_sin_stop <- tokens_palabras |> 
  anti_join(get_stopwords("es")) # Elimina las palabras comunes en español

print(tokens_palabras_sin_stop)

# Contar palabras
tokens_palabras_sin_stop |> 
  count(word, sort = TRUE)

# Graficar las palabras más comunes
tokens_palabras_sin_stop |> 
  count(word, sort = TRUE) |> 
  filter(n > 1) |> 
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip()

# Tokenización en bigramas
bigramas <- notas_clinicas |> 
  unnest_tokens(bigrama, texto, token = "ngrams", n = 2)

# Separar los bigramas en dos columnas
bigramas_separados <- bigramas |> 
  separate(bigrama, into = c("palabra1", "palabra2"), sep = " ")

# Obtener stopwords en español
stopwords_es <- get_stopwords(language = "es")

# Filtrar bigramas eliminando stopwords en ambas palabras
bigramas_filtrados <- bigramas_separados |> 
  filter(!palabra1 %in% stopwords_es$word, 
         !palabra2 %in% stopwords_es$word) |> 
  unite(bigrama, palabra1, palabra2, sep = " ")  # Recomponer los bigramas

# Mostrar resultado
print(bigramas_filtrados)

bigramas_filtrados|> 
  count(bigrama, sort = TRUE) |> 
  filter(n > 1) |> 
  ggplot(aes(x = reorder(bigrama, n), y = n)) +
  geom_col() +
  coord_flip()
