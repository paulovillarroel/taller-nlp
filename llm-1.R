library(ellmer)
library(tidyverse)

chat <- chat_ollama(model = "llama3.1:8b")

# Basics

chat$extract_data(
  "My name is Susan and I'm 13 years old",
  type = type_object(
    age = type_number(),
    name = type_string()
  )
)

# Article summarisation

text <- readLines(system.file("examples/third-party-testing.txt", package = "ellmer"))

type_summary <- type_object(
  "Summary of the article.",
  author = type_string("Name of the article author"),
  topics = type_array(
    'Array of topics, e.g. ["tech", "politics"]. Should be as specific as possible, and can overlap.',
    type_string(),
  ),
  summary = type_string("Summary of the article. One or two paragraphs max")
)

data <- chat$extract_data(text, type = type_summary)

cat(data$summary)

str(data)


# Named entity recognition

text <- "
  John works at Google in New York. He met with Sarah, the CEO of
  Acme Inc., last week in San Francisco.
"

type_named_entity <- type_object(
  name = type_string("The extracted entity name."),
  type = type_enum("The entity type", c("person", "location", "organization")),
  context = type_string("The context in which the entity appears in the text.")
)

type_named_entities <- type_array(items = type_named_entity)

chat$extract_data(text, type = type_named_entities)


# Sentiment analysis

text <- "
  The product was okay, but the customer service was terrible. I probably
  won't buy from them again.
"

type_sentiment <- type_object(
  "Extract the sentiment scores of a given text. IMPORTANT: Sentiment scores should sum to 1.",
  positive_score = type_number("Positive sentiment score, ranging from 0.0 to 1.0."),
  negative_score = type_number("Negative sentiment score, ranging from 0.0 to 1.0."),
  neutral_score = type_number("Neutral sentiment score, ranging from 0.0 to 1.0.")
)

str(chat$extract_data(text, type = type_sentiment))


# Text classification

text <- "The new quantum computing breakthrough could revolutionize the tech industry."

type_classification <- type_array(
  "Array of classification results. The scores should sum to 1.",
  type_object(
    name = type_enum(
      "The category name",
      values = c(
        "Politics",
        "Sports",
        "Technology",
        "Entertainment",
        "Business",
        "Other"
      )
    ),
    score = type_number(
      "The classification score for the category, ranging from 0.0 to 1.0."
    )
  )
)

data <- chat$extract_data(text, type = type_classification)
data


# Example

chat <- chat_ollama(model = "llama3.1:8b",
                    system_prompt = "you are a medical expert and specialist in oncology. Your task is to carefully analyze the clinical texts and classify whether they are related or not to any oncological pathology.
                    I don't want any explanation. Just give me the answer in the requested format.")

text <- c("mastectomia radical tumorectomia con vaciamiento ganglionar total")

chat$extract_data(
  text,
  type = type_object(
    cancer = type_enum("Clasify if related to cancer", values = c("Related", "Not related"))
  )
)

# Aplicar la clasificación a cada elemento del vector y devolver un data frame

text <- c("mastectomia radical tumorectomia con vaciamiento ganglionar total",
          "Hipertensión arterial descompensada",
          "Cáncer de pulmón en etapa avanzada",
          "Miastenia gravis de larga data")

result <- map_df(text, ~ tibble(
  text = .x,
  cancer = chat$extract_data(
    .x,
    type = type_object(
      cancer = type_enum("Clasify if related to cancer", values = c("Related", "Not related"))
    )
  )
)) |> 
  mutate(cancer = unlist(cancer))

print(result)


