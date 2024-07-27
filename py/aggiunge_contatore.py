import re
import os

def replace_exercise_header(file_path, new_file_path):
    # Leggi il contenuto del file
    with open(file_path, 'r', encoding='utf-8') as file:
        file_content = file.readlines()
    
    new_content = []
    for line in file_content:
        if re.match(r'^### Esercizio 1', line):
            new_content.append(line)
            new_content.append("\n```{r}\ncompito <- compito + 1\npunti <- punti_list[[compito]]\n```\n")
        else:
            new_content.append(line)
    
    # Scrivi il nuovo contenuto nel file
    with open(new_file_path, 'w', encoding='utf-8') as file:
        file.writelines(new_content)

# Applica la funzione a ciascun file R Markdown
file_paths = ['2023_processed.Rmd','2024_processed.Rmd']
new_file_paths = ['2023_updated.Rmd', '2024_updated.Rmd']

for file_path, new_file_path in zip(file_paths, new_file_paths):
    replace_exercise_header(file_path, new_file_path)


