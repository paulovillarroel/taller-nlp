library(tidyverse)
library(rvest)
library(mall)

url <- "https://www.whitehouse.gov/remarks/2025/01/the-inaugural-address/"

# Read the webpage
webpage <- read_html(url)

# Extraer los <p> tags
paragraphs <- webpage |> 
  html_nodes("p") |> 
  html_text() |> 
  str_trim() |> 
  str_replace_all("\n", " ") |> 
  str_replace_all("\\s+", " ")

adress <- as.data.frame(paragraphs[2])

mall::llm_use("ollama", model = "llama3.1:8b")

adress |> 
  llm_summarize(paragraphs[2], max_words = 200)
