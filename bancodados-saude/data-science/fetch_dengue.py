""" # codigo criados com erros para depois ser arrumado
import pandas as pd
URL = (
"https://info.dengue.mat.br/api/alertcity"
"?geocode=4316902" # ERRO 1: código IBGE incorreto
"&disease=dengue"
"&format=csv"
"&ew_start=1"
"&ew_end=52"
"&ey_start=2022"
"&ey_end=2023"
)
df = pd.read_csv(URL)
df = df[
[
"data_iniSE",
"casos",
"temp_min", # ERRO 2: nome de campo inexistente
"umid_med", # ERRO 2: nome de campo inexistente
"Rt"
]
].dropna()
df["media_movel"] = df["casos"].rolling(4).mean()
df = df.dropna()
df.to_json(
"../backend/data.json",
orient="records",
date_format="iso"
)
print("Dados salvos:", len(df))
print(df.columns) 
"""

#codigo correto para novo teste
import pandas as pd # type: ignore

URL = (
    "https://info.dengue.mat.br/api/alertcity"
    "?geocode=4316907"
    "&disease=dengue"
    "&format=csv"
    "&ew_start=1"
    "&ew_end=52"
    "&ey_start=2022"
    "&ey_end=2023"
)

df = pd.read_csv(URL)

df = df[["data_iniSE", "casos", "Rt"]]


df = df.dropna(subset=["casos"])

df["media_movel"] = df["casos"].rolling(4).mean()

df = df.dropna(subset=["media_movel"])

df.to_json(
    "../backend/data.json",
    orient="records",
    date_format="iso"
)

print("Dados epidemiológicos salvos:", len(df))
print(df.columns)