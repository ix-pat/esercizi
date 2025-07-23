setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(knitr)
library(colorspace)
library(kableExtra)


source("../punti.R")

#### ESTRAE TESTO ####

anni  <- c(
  "2021",
  "2022",
  "2023",
  "2024",
  "2025"
  )

files <- paste0("../",anni,".Rmd")




  
for (file_ in files){
  
  lines <- readLines(file_)
  idx_prove <- grep("^## Prova", lines)
  idx_prove <- c(idx_prove, length(lines)+1)
  testi_temp <- list()
  
  p <- 1
  for (p in 1:(length(idx_prove)-1)) {
    
    start_prova <- idx_prove[p]
    end_prova   <- idx_prove[p+1] - 1
    
    # righe solo di questa prova
    righe_prova <- lines[(start_prova+1):end_prova]
    
    # trova tutti gli esercizi nella prova
    idx_es <- grep("^### Esercizio", righe_prova)
    
    # metti anche la fine della prova come riga di chiusura
    idx_es <- c(idx_es, length(righe_prova)+1)
    
    # crea lista per questa prova
    prova_list <- list()
    
    for (e in 1:(length(idx_es)-1)) {
      start_e <- idx_es[e] + 1
      end_e   <- idx_es[e+1] - 1
      
      testo <- righe_prova[start_e:end_e]
#      testo <- testo[!grepl("^\\s*$", testo)] # elimina righe vuote
      
      prova_list[paste0("e", e)] <- paste(testo, collapse="\n")
    }
    
    testi_temp[[p]] <- prova_list
    assign(x = paste0("testi_",file_),testi_temp) 
    
  }
}

#### COLLEGA TESTO E PUNTI ####

rm(testi_temp)

testi.temp <- ls()[grep(pattern = "testi_",ls())]
testi <- list()
punti_tot <- list()

for (i in seq_along(testi.temp)){
  text_t <- get(testi.temp[i])
  scor_t <- get(paste0("punti_",anni[i]))
  testi[[i]] <- text_t
  punti_tot[[i]] <- scor_t
}

# testi <- list(testi_2021.Rmd,testi_2022.Rmd,testi_2023.Rmd,testi_2024.Rmd)
# punti_tot <- list(punti_2021,punti_2022,punti_2023,punti_2024)

#### ESTRAE 6 ESERCIZI ####

es1 <- sample(1:length(testi),1)
es1 <- c(es1,sample(1:length(testi[[es1]]),1))
es1_text <- testi[[es1[1]]][[es1[2]]][[1]]
# lines <- unlist(strsplit(es1_text, "\n"))
# toglo il contatore compito
# 
blocco <-  "(?s)```\\{r[^\\n]*\\}\\s*compito <- compito \\+ 1\\s*punti <- punti_list\\[\\[compito\\]\\]\\s*```\\s*"
es1_text <- paste(gsub(blocco, "\n\n", es1_text, perl = TRUE),collapse = "\n")


es2 <- sample(1:length(testi),1)
es2 <- c(es2,sample(1:length(testi[[es2]]),1))
es2_text <- testi[[es2[1]]][[es2[2]]][[2]]

es3 <- sample(1:length(testi),1)
es3 <- c(es3,sample(1:length(testi[[es3]]),1))
es3_text <- testi[[es3[1]]][[es3[2]]][[3]]

es4 <- sample(1:length(testi),1)
es4 <- c(es4,sample(1:length(testi[[es4]]),1))
es4_text <- testi[[es4[1]]][[es4[2]]][[4]]

es5 <- sample(1:length(testi),1)
es5 <- c(es5,sample(1:length(testi[[es5]]),1))
es5_text <- testi[[es5[1]]][[es5[2]]][[5]]

has_e6 <- lapply(
  testi,
  function(anno) {
    sapply(anno, function(compito) "e6" %in% names(compito))
  }
)

es6 <- sample(1:length(testi),1)
quali6 <- has_e6[[es6[1]]]*seq_along(has_e6[[es6[1]]])
quali6 <- quali6[quali6 != 0]
es6 <- c(es6,sample(quali6,1))
es6_text <- testi[[es6[1]]][[es6[2]]][[6]]

if (sum(punti_tot[[es5[1]]][[es5[2]]]$e5)<=14) {
  N_eserc <- 6
  punti_new <- list(
    punti_tot[[es1[1]]][[es1[2]]]$e1,
    punti_tot[[es2[1]]][[es2[2]]]$e2,
    punti_tot[[es3[1]]][[es3[2]]]$e3,
    punti_tot[[es4[1]]][[es4[2]]]$e4,
    punti_tot[[es5[1]]][[es5[2]]]$e5,
    punti_tot[[es6[1]]][[es6[2]]]$e6
  )
} else {
  N_eserc <- 5
  punti_new <- list(
    punti_tot[[es1[1]]][[es1[2]]]$e1,
    punti_tot[[es2[1]]][[es2[2]]]$e2,
    punti_tot[[es3[1]]][[es3[2]]]$e3,
    punti_tot[[es4[1]]][[es4[2]]]$e4,
    punti_tot[[es5[1]]][[es5[2]]]$e5
  )
}
# scrivi ciascun esercizio nella lista punti



#### CREA IL COMPITO ####

preamble <- readLines("preamble.Rmd")

sink("compito.Rmd")

# scrivi il preambolo
cat(preamble, sep = "\n")
cat("\n\n")

# scrivi la lista punti
cat("```{r setup-punti, echo=FALSE}\n")
cat("punti <- list(\n")

# scrivi ciascun esercizio nella lista punti
for (i in 1:N_eserc) {
  esercizio_nome <- paste0("e", i)
  punti_valori <- paste(punti_new[[i]], collapse = ", ")
  cat("   ",esercizio_nome," = c(",punti_valori,")",sep="")
#  cat(sprintf("  %s = c(%s)", esercizio_nome, punti_valori))
  
  # se non è l'ultimo, metti la virgola
  if (i < N_eserc) cat(",\n") else cat("\n")
}

cat(")\n")
cat("```\n\n")

#### scrivi i blocchi degli esercizi ####

for (i in 1:N_eserc) {
  esercizio_nome <- paste0("es", i, "_text")
  testo_esercizio <- get(esercizio_nome)
  testo_esercizio <- gsub(
    "(,\\s*fig\\.(height|width)\\s*=\\s*[^,}]*)",
    "",
    testo_esercizio,
    perl=TRUE
  )
  cat("\n\n### Esercizio",i,"\n\n")
  cat(testo_esercizio)
  cat("\n\n")
}

sink()

#### COMPILA ####

html <- F
rmarkdown::render(
  input = "compito.Rmd",
  output_format = "bookdown::pdf_document2",
  output_file = "compito/compito.pdf",
  envir = globalenv(),
  clean = T
)
html <- T
rmarkdown::render(
  "compito.Rmd",
  output_format = "html_document",
  clean = T, 
  output_file = "compito/compito.html",
  envir = globalenv()
)

# system("mv compito.Rmd compito/")
system("rm compito/compito.tex")
