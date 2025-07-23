for (file_ in c("2021.Rmd","2022.Rmd","2023.Rmd","2024.Rmd")){
  
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
      testo <- testo[!grepl("^\\s*$", testo)] # elimina righe vuote
      
      prova_list[paste0("e", e)] <- paste(testo, collapse="\n")
    }
    
    testi_temp[[p]] <- prova_list
    assign(x = paste0("testi_",file_),testi_temp) 
  }
}

testi <- list(testi_2021.Rmd,testi_2022.Rmd,testi_2023.Rmd,testi_2024.Rmd)
punti_tot <- list(punti_2021,punti_2022,punti_2023,punti_2024)

es1 <- sample(1:length(testi),1)
es1 <- c(es1,sample(1:length(testi[[es1]]),1))
es1_text <- testi[[es1[1]]][[es1[2]]][[1]]

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

es6 <- sample(1:length(testi),1)
es6 <- c(es6,sample(1:length(testi[[es6]]),1))
es6_text <- testi[[es6[1]]][[es6[2]]][[6]]


punti_new <- list(
  punti_tot[[es1[1]]][[es1[2]]]$e1,
  punti_tot[[es2[1]]][[es2[2]]]$e2,
  punti_tot[[es3[1]]][[es3[2]]]$e3,
  punti_tot[[es4[1]]][[es4[2]]]$e4,
  punti_tot[[es5[1]]][[es5[2]]]$e5,
  punti_tot[[es6[1]]][[es6[2]]]$e6
)

cat(es1_text)
cat(es2_text)
cat(es3_text)
cat(es4_text)
cat(es5_text)
if (sum(punti_tot[[es5[1]]][[es5[2]]]$e5)<=14) cat(es6_text)
