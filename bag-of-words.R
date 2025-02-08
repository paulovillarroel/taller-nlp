# Primero instalamos y cargamos los paquetes necesarios
install.packages("tm")
library(tm)

# Creamos un corpus de ejemplo con algunas oraciones
textos <- c(
  "La inteligencia artificial está revolucionando el desarrollo de software moderno",
  "Los programadores necesitan aprender Python y JavaScript para el desarrollo web",
  "La inteligencia artificial y el machine learning requieren grandes datos para entrenar",
  "El desarrollo web moderno combina JavaScript con frameworks populares",
  "Los grandes datos y la computación en la nube transforman la programación moderna"
)

# Creamos un corpus
corpus <- Corpus(VectorSource(textos))

# Preprocesamiento básico
corpus <- tm_map(corpus, content_transformer(tolower))  # Convertir a minúsculas
corpus <- tm_map(corpus, removePunctuation)            # Eliminar puntuación
corpus <- tm_map(corpus, removeNumbers)                # Eliminar números
corpus <- tm_map(corpus, removeWords, stopwords("spanish")) # Eliminar palabras vacías

# Crear la matriz documento-término (bag of words)
dtm <- DocumentTermMatrix(corpus)

# Convertir a matriz para visualizar mejor
matriz <- as.matrix(dtm)

# Ver el resultado
print(matriz)

# Suma por columnas para ver frecuencia total de cada palabra
frecuencias <- colSums(matriz)
sort(frecuencias, decreasing = TRUE)

# Calcular similitud coseno entre documentos
install.packages("lsa")

similitud <- lsa::cosine(t(matriz))
print(similitud)
