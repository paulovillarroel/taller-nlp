library(mall)
library(tidyverse)

mall::llm_use("ollama", model = "llama3.1:8b")

text <- tibble(
  texto = 
    c(
      "tumor subescapular derecho dermatologia tegumentos",
      "tumor cabeza pancreas pancreatoduodenectomia cirugia general",
      "carcinoma in situ piel labio biopsia quir mucosa",
      "tumorectomia mamaria no ges mastectomia parcial cuadrante",
      "quiste pequeño en base de lengua cirugia maxilofacial",
      "tumor palpebral estudio ambos ojos biopsia palperal cirugia oftalmologica",
      "tumor comportamiento incierto desconocido sitio no especificado na neurocirugia",
      "tumor vertebral t7t8 neurocirugia",
      "tumor maligno intestino delgado parte no esSpecificada cirugia digestiva",
      "mieloma multiple requiere hemograma completo y pruebas de funcion renal",
      "extraccion via anal tumor maligno recto cirugia adulto",
      "tumores quistes lesiones pseudoquisticas izquierda musculares tendineas grupo 21 traumatologia",
      "cirugia cabeza cuello d442 tumor glandula paratiroides tiroidectomia total ampliada incluye extirpacion estructuras anatomicas vecinas",
      "c160 tumor maligno cardias hernia inguinal crural umbilical lanea bl",
      "tumor parotida cirugia adulto",
      "inicio de insulina por diabetes mellitus tipo 2 de mal manejo",
      "tumor comportamiento incierto desconocido ovario",
      "linfoma no hodgkin b alto grado",
      "tumor maligno piel cuero cabelludo cuello cirugia cabeza",
      "adenoma benigno prostata cirugia urologia",
      "dolor abdominal difuso con irradiación a la espalda",
      "tumor maligno mama parte no especificada hernia inguinal crural umbilical linea blanca similares recidivada nosimple estrangulada sreseccion intestcu cirugia general adulto",
      "evaluación previa a inicio de quimioetarapia."
    )
)

prompt <- paste(
  "Eres un sistema experto en clasificar textos relacionados con cáncer.\n\n",
  
  "INSTRUCCIÓN PRINCIPAL:\n",
  "Tu tarea es leer el texto proporcionado y determinar si se refiere a un caso de cáncer o no.\n\n",
  
  "CONTEXTUALIZACIÓN:\n",
  "Los textos pueden contener información médica, diagnósticos, síntomas, tratamientos, etc.\n",
  "Debes considerar la presencia de términos como 'tumor', 'neoplasia', 'carcinoma', 'sarcoma', etc.\n",
  
  "CRITERIOS DE CLASIFICACIÓN:\n",
  "1. Si el texto menciona explícitamente un tipo de cáncer (por ejemplo, 'cáncer de pulmón', 'leucemia', 'carcinoma', 'masa', 'cbc (cáncer basocelular', 'tumor', etc.), debes clasificarlo como 'SÍ'.\n",
  "2. También analiza si el texto indica algún procedimiento o cirugía relacionada a cáncer como 'Hartmann', 'toma de biopsia', 'recosntrucción de tránsito intestinal', 'quimioterapia', 'radioterapia', etc.\n",
  "3. Si el texto describe síntomas o tratamientos que están relacionados con el cáncer, pero no menciona explícitamente el término 'cáncer', debes clasificarlo como 'SI' si es probable que se trate de un caso de cáncer.\n",
  "4. Si el texto no menciona nada relacionado con el cáncer, debes clasificarlo como 'NO'.\n\n",
  
  "REGLAS GENERALES:\n",
  "1. No debes agregar explicaciones adicionales a tu respuesta.\n",
  "2. Debes responder solo con 'SI' o 'NO'.\n\n",
  "3. Si tienes dudas o no estás seguro, debes clasificar como 'SI' por defecto.\n\n",
  
  "TEXTO A CLASIFICAR: %s\n",
  "RESPUESTA: "
)

texts_classified <- text |>
  llm_custom(texto, prompt)

# Zero-shot
texts_organs <- text |> 
  llm_extract(texto, "human organ")
