import os
import re

# Percorso della directory contenente i file .Rmd
directory_path = '/home/pat/OneDrive/Stat/esercizi/'

# Espressione regolare per identificare i titoli di secondo livello in Markdown
pattern = r'^(## .+?)$'

# Compila l'espressione regolare per migliorare le prestazioni
compiled_pattern = re.compile(pattern, re.MULTILINE)

# Cicla attraverso tutti i file nella directory specificata
for filename in os.listdir(directory_path):
    if filename.endswith(".Rmd"):
        file_path = os.path.join(directory_path, filename)
        
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Sostituisce ogni corrispondenza del pattern con il div richiesto con una classe invece di un ID
        new_content = compiled_pattern.sub(r'<div class="button-container"></div>\n\n\1', content)
        
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(new_content)

print("Sostituzione completata con div di classe per tutti i titoli di secondo livello.")
