library(ellmer)

# Uso de la API de Groq (https://console.groq.com)

chat <- chat_groq(
  system_prompt = NULL,
  turns = NULL,
  base_url = "https://api.groq.com/openai/v1",
  api_key = "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", # Acá debes colocar tu API Key
  model = "deepseek-r1-distill-llama-70b",
  seed = NULL,
  api_args = list(),
  echo = NULL
)

chat$chat("dime un chiste")


# Ejemplo 1

instruct_json <- "
  You're an expert baker who also loves JSON. I am going to give you a list of
  ingredients and your job is to return nicely structured JSON. Just return the
  JSON and no other commentary.
"

instruct_weight_input <- r"(
  * If an ingredient has both weight and volume, extract only the weight:

    ¾ cup (150g) dark brown sugar
    [
      {"name": "dark brown sugar", "quantity": 150, "unit": "g", "input": "¾ cup (150g) dark brown sugar"}
    ]

  * If an ingredient only lists a volume, extract that.

    2 t ground cinnamon
    ⅓ cup (80ml) neutral oil
    [
      {"name": "ground cinnamon", "quantity": 2, "unit": "teaspoon", "input": "2 t ground cinnamon"},
      {"name": "neutral oil", "quantity": 80, "unit": "ml", "input": "⅓ cup (80ml) neutral oil"}
    ]
)"

recipe <- r"(
  In a large bowl, cream together one cup of softened unsalted butter and a
  quarter cup of white sugar until smooth. Beat in an egg and 1 teaspoon of
  vanilla extract. Gradually stir in 2 cups of all-purpose flour until the
  dough forms. Finally, fold in 1 cup of semisweet chocolate chips. Drop
  spoonfuls of dough onto an ungreased baking sheet and bake at 350°F (175°C)
  for 10-12 minutes, or until the edges are lightly browned. Let the cookies
  cool on the baking sheet for a few minutes before transferring to a wire
  rack to cool completely. Enjoy!
)"

chat$chat(c(instruct_json, instruct_weight_input), recipe)


# Ejemplo 2

instruct_json <- "
  You are an expert system for classifying texts related to cancer. Your task is to read the provided text and determine if it refers to a case related to cancer or not. You must respond in the JSON format I explain to you. Do not provide explanations or other comments. "

instruct_weight_input <- r"(

* Looking further, there's an instruction section. The main task is to read the provided text and determine if it refers to a cancer case. The contextualization part mentions that texts may include medical information, diagnoses, symptoms, treatments, etc., and I should look for terms like 'tumor', 'neoplasia', 'carcinoma', 'sarcoma', etc.

The classification criteria are detailed. First, if the text explicitly mentions a type of cancer, like 'lung cancer', 'leukemia', 'carcinoma', 'tumor', 'cbc' (basocellular cancer), etc., it should be classified as 'YES'. Second, I need to check for procedures or surgeries related to cancer, such as 'Hartmann', 'biopsy', 'intestinal transit reconstruction', 'chemotherapy', 'radiotherapy', etc. Third, if the text describes symptoms or treatments related to cancer without explicitly mentioning 'cancer', I should still classify it as 'YES' if it's likely a cancer case. Lastly, if there's nothing related to cancer, it's 'NO'.

The general rules state not to add extra explanations, just respond with 'YES' or 'NO'. If unsure, default to 'YES'.

Now, looking at the given text, it's all about instructing a system to classify texts related to cancer. It doesn't describe a specific medical case or use terms like 'tumor' or 'carcinoma'. It's more about the guidelines for classification. So, according to the criteria, since it doesn't mention any specific cancer terms or procedures, it should be classified as 'NO'.

     [
  {
    "name": "tumor subescapular derecho dermatologia tegumentos",
    "related_to_cancer": "No",
    "affected_organ": "piel"
  },
  {
    "name": "tumor cabeza pancreas pancreatoduodenectomia cirugia general",
    "related_to_cancer": "Yes",
    "affected_organ": "páncreas"
  },
  {
    "name": "carcinoma in situ piel labio biopsia quir mucosa",
    "related_to_cancer": "Yes",
    "affected_organ": "piel"
  },
  {
    "name": "tumorectomia mamaria no ges mastectomia parcial cuadrante",
    "related_to_cancer": "Yes",
    "affected_organ": "mama"
  },
  {
    "name": "quiste pequeño en base de lengua cirugia maxilofacial",
    "related_to_cancer": "No",
    "affected_organ": "lengua"
  },
  {
    "name": "tumor palpebral estudio ambos ojos biopsia palperal cirugia oftalmologica",
    "related_to_cancer": "Uncertain",
    "affected_organ": "parpado"
  },
  {
    "name": "tumor comportamiento incierto desconocido sitio no especificado na neurocirugia",
    "related_to_cancer": "Uncertain",
    "affected_organ": "desconocido"
  },
  {
    "name": "tumor vertebral t7t8 neurocirugia",
    "related_to_cancer": "Uncertain",
    "affected_organ": "columna vertebral"
  },
  {
    "name": "tumor maligno intestino delgado parte no esSpecificada cirugia digestiva",
    "related_to_cancer": "Yes",
    "affected_organ": "intestino delgado"
  },
  {
    "name": "mieloma multiple requiere hemograma completo y pruebas de funcion renal",
    "related_to_cancer": "Yes",
    "affected_organ": "médula ósea"
  }
    )"

texts <- r"(
tumor subescapular derecho dermatologia tegumentos
tumor cabeza pancreas pancreatoduodenectomia cirugia general
carcinoma in situ piel labio biopsia quir mucosa
tumorectomia mamaria no ges mastectomia parcial cuadrante
quiste pequeño en base de lengua cirugia maxilofacial
tumor palpebral estudio ambos ojos biopsia palperal cirugia oftalmologica
tumor comportamiento incierto desconocido sitio no especificado na neurocirugia
tumor vertebral t7t8 neurocirugia
tumor maligno intestino delgado parte no esSpecificada cirugia digestiva
mieloma multiple requiere hemograma completo y pruebas de funcion renal
extraccion via anal tumor maligno recto cirugia adulto
tumores quistes lesiones pseudoquisticas izquierda musculares tendineas grupo 21 traumatologia
cirugia cabeza cuello d442 tumor glandula paratiroides tiroidectomia total ampliada incluye extirpacion estructuras anatomicas vecinas
c160 tumor maligno cardias hernia inguinal crural umbilical lanea bl
tumor parotida cirugia adulto
inicio de insulina por diabetes mellitus tipo 2 de mal manejo
tumor comportamiento incierto desconocido ovario
linfoma no hodgkin b alto grado
tumor maligno piel cuero cabelludo cuello cirugia cabeza
adenoma benigno prostata cirugia urologia
dolor abdominal difuso con irradiación a la espalda
tumor maligno mama parte no especificada hernia inguinal crural umbilical linea blanca similares recidivada nosimple estrangulada sreseccion intestcu cirugia general adulto
evaluación previa a inicio de quimioetarapia
Mioma uterino
Adenocarcinoma en biopsia gástrica, se deriva para evaluación de cirugía
Tumor de cabeza y cuello, se deriva para cirugía de cabeza y cuello
Sindorme consuntivo asociada a vómitos y náuseas luego de inicio de tramal por dolor oncológico
cbc cara externa de nariz de 2 años de evolución
)"

chat$chat(c(instruct_json, instruct_weight_input), texts)
