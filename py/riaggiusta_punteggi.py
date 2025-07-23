import re
import os

def process_rmarkdown(file_path, new_file_path):
    # Leggi il contenuto del file
    with open(file_path, 'r', encoding='utf-8') as file:
        file_content = file.readlines()
    
    # Inizializza variabili
    task_counter = 0
    exercise_counter = 0
    compiti = []
    punti_list = []
    punti_sublist = []
    new_content = []
    first_subexercise = True

    def punti_p_start():
        return "`r punti_p(start=T)`"
    
    def punti_p_next():
        return "`r punti_p(next=T)`"
    
    def punti_p():
        return "`r punti_p()`"

    for line in file_content:
        if re.match(r'^### Esercizio 1', line):
            if task_counter > 0:
                punti_list.append(punti_sublist)
                compiti.append(punti_list)
                punti_list = []
                punti_sublist = []
            task_counter += 1
            exercise_counter = 1
            first_subexercise = True
            new_content.append(line)
        elif re.match(r'^### Esercizio', line):
            exercise_counter += 1
            if punti_sublist:
                punti_list.append(punti_sublist)
                punti_sublist = []
            first_subexercise = True
            new_content.append(line)
        else:
            match = re.search(r'\(\*\*Punti\s+(\d+)\*\*\)', line)
            if match:
                punti = int(match.group(1))
                punti_sublist.append(punti)
                
                if exercise_counter == 1 and first_subexercise:
                    new_line = re.sub(r'`r item\(\).*?\(\*\*Punti\s+\d+\*\*\)', punti_p_start(), line)
                    first_subexercise = False
                elif exercise_counter > 1 and first_subexercise:
                    new_line = re.sub(r'`r item\(\).*?\(\*\*Punti\s+\d+\*\*\)', punti_p_next(), line)
                    first_subexercise = False
                else:
                    new_line = re.sub(r'\(\*\*Punti\s+\d+\*\*\)', punti_p(), line)
                new_content.append(new_line)
            else:
                new_content.append(line)

    if punti_sublist:
        punti_list.append(punti_sublist)
    if punti_list:
        compiti.append(punti_list)

    # Scrivi il nuovo contenuto nel file
    with open(new_file_path, 'w', encoding='utf-8') as file:
        file.writelines(new_content)
    
    # Estrai il nome base del file senza estensione
    base_name = os.path.splitext(os.path.basename(file_path))[0]
    
    # Salva la lista dei punti in un file separato per ciascun compito
    for i, punti in enumerate(compiti, start=1):
        r_list_content = 'punti <- list(\n'
        r_list_content += ',\n'.join(['c(' + ','.join(map(str, sublist)) + ')' for sublist in punti])
        r_list_content += '\n)'
        
        with open(f'{base_name}_punti_list{i}.R', 'w', encoding='utf-8') as file:
            file.write(r_list_content)

    # Ritorna la lista dei punti
    return compiti

# Applica la funzione a ciascun file R Markdown
file_paths = ['2021.Rmd', '2022.Rmd', '2023.Rmd', '2024.Rmd']
new_file_paths = ['2021_processed.Rmd', '2022_processed.Rmd', '2023_processed.Rmd', '2024_processed.Rmd']

for file_path, new_file_path in zip(file_paths, new_file_paths):
    process_rmarkdown(file_path, new_file_path)

