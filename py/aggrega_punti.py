import re
import os
from collections import defaultdict

def combine_punti_files(directory):
    combined_punti = defaultdict(lambda: defaultdict(list))

    for filename in os.listdir(directory):
        if re.match(r'\d{4}_punti_list\d+\.R', filename):
            year = re.search(r'\d{4}', filename).group()
            compito_number = int(re.search(r'punti_list(\d+)', filename).group(1))
            file_path = os.path.join(directory, filename)
            
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                # Estrae il contenuto della lista
                list_content = re.findall(r'c\((.*?)\)', content, re.DOTALL)
                combined_punti[year][compito_number].extend(list_content)
    
    # Salva le liste combinate in file separati per ciascun anno
    for year, compiti in combined_punti.items():
        r_list_content = f"a1 <- 14\na2 <- 3\na3 <- 2\na4 <- 3\n\npunti_{year} <- list(\n"
        for compito_number in sorted(compiti):
            esercizi = compiti[compito_number]
            esercizi_content = []
            for i, es in enumerate(esercizi):
                points = list(map(int, es.split(',')))
                if i == 3:  # All e4 exercises
                    es_with_vars = ','.join(['a4' for _ in points])
                    name = 'e4'
                elif i == 4:  # e5 exercises
                    if len(points) == 1:
                        es_with_vars = 'a1'
                    elif len(points) == 2:
                        es_with_vars = 'a4, a1 - a4'
                    else:
                        es_with_vars = ','.join([f'a1' if point == 14 else f'a2' if point == 3 else f'a3' for point in points])
                    name = 'e5'
                else:
                    es_with_vars = ','.join([f'a1' if point == 14 else f'a2' if point == 3 else f'a3' for point in points])
                    name = f'e{i+1}'
                esercizi_content.append(f'{name} = c({es_with_vars})')
            r_list_content += f'list(\n{",\n".join(esercizi_content)}\n),\n'
        r_list_content = r_list_content.rstrip(',\n') + '\n)'
        
        with open(os.path.join(directory, f'punti_{year}.R'), 'w', encoding='utf-8') as file:
            file.write(r_list_content)

# Specifica la directory contenente i file R
directory = './'

# Elabora tutti i file nella directory
combine_punti_files(directory)
