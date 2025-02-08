library(tidyverse)
library(tidytext)


reclamos <- readxl::read_excel("data/reclamos.xlsx") |> 
  janitor::clean_names()

# Tokenización y eliminación de stopwords
reclamos_tokens <- reclamos |>
  mutate(doc_id = mercado_analista) |>
  select(doc_id, descripcion_ciudadano) |> 
  unnest_tokens(word, descripcion_ciudadano) |>
  anti_join(get_stopwords("es")) |> 
  count(doc_id, word, name = "count")

# Calculamos IDF y TF-IDF
reclamos_tfidf <- reclamos_tokens |>
  bind_tf_idf(word, doc_id, count)

# Visualización de las palabras más relevantes según TF-IDF
top_terms <- reclamos_tfidf |>
  arrange(desc(tf_idf)) |>
  group_by(doc_id) |>
  slice_max(order_by = tf_idf, n = 5) |>
  ungroup()

# Visualización
ggplot(top_terms, aes(x = reorder(word, tf_idf), y = tf_idf)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(x = "Término",
       y = "TF-IDF",
       title = "Términos más relevantes por TF-IDF",
       subtitle = "Top 5 términos por documento") +
  theme_minimal() +
  facet_wrap(~ doc_id, scales = "free_y")
