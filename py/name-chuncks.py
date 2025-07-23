import os
import re

def rename_chunks_in_rmd_files():
    # Ottieni la directory corrente
    directory = os.getcwd()

    # Lista tutti i file .Rmd nella directory
    rmd_files = [f for f in os.listdir(directory) if f.endswith('.Rmd')]

    for filename in rmd_files:
        filepath = os.path.join(directory, filename)

        # Legge il contenuto del file
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()

        count = 1

        # Funzione per la sostituzione dei chunk senza nome
        def replace_chunk(match):
            nonlocal count
            if match.group(1):
                replacement = f'```{{r {filename[:-4]}-{count},{match.group(1)}}}'
            else:
                replacement = f'```{{r {filename[:-4]}-{count}}}'
            count += 1
            return replacement

        # Sostituisce i chunk senza nome
        new_content = re.sub(r'```{r(,.*?)}', replace_chunk, content)
        new_content = re.sub(r'```{r(,)?}', replace_chunk, new_content)

        # Salva il file modificato con un nuovo nome per il controllo
        new_filename = filename.replace('.Rmd', '.Rmd')
        new_filepath = os.path.join(directory, new_filename)

        with open(new_filepath, 'w', encoding='utf-8') as new_file:
            new_file.write(new_content)

# Usa la funzione senza argomenti, utilizza la directory corrente
rename_chunks_in_rmd_files()
