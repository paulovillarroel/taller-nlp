library(udpipe)
library(tidyverse)

# Docs https://bnosac.github.io/udpipe/en/

data(brussels_reviews)

comments <- subset(brussels_reviews, language %in% "es")

ud_model <- udpipe_download_model(language = "spanish")
ud_model <- udpipe_load_model(ud_model$file_model)

x <- udpipe_annotate(ud_model, x = comments$feedback, doc_id = comments$id)
x <- as.data.frame(x)

stats <- txt_freq(x$upos)

# https://universaldependencies.org/u/pos/index.html


ggplot(stats, aes(x = reorder(key, freq), y = freq)) +
  geom_col(fill = "cadetblue") +
  labs(
    title = "UPOS (Universal Parts of Speech)\n frequency of occurrence",
    x = "UPOS",
    y = "Freq"
  ) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 8))

# NOUN
stats <- subset(x, upos %in% c("NOUN"))
stats <- txt_freq(stats$token)

ggplot(head(stats, 20), aes(x = reorder(key, freq), y = freq)) +
  geom_col(fill = "cadetblue") +
  labs(
    title = "Most occurring nouns",
    x = "Noun",
    y = "Freq"
  ) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ADJ
stats <- subset(x, upos %in% c("ADJ"))
stats <- txt_freq(stats$token)

ggplot(head(stats, 20), aes(x = reorder(key, freq), y = freq)) +
  geom_col(fill = "cadetblue") +
  labs(
    title = "Most occurring adjectives",
    x = "Noun",
    y = "Freq"
  ) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
