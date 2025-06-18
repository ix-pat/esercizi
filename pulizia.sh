#!/bin/bash
echo "Pulizia file ausiliari LaTeX..."
rm -f *.aux *.toc *.lof *.lot *.out *.log *.bbl *.blg
rm -rf *_files/
echo "Fatto. Pronto per la ricompilazione."