library(knitr)
library(kableExtra)
library(pBrackets)
library(bookdown)
library(bookdownplus)
library(plotrix)
library(colorspace)
library(haven)
library(rgl)
library(mvtnorm)
library(pat.book)

options(digits=4,knitr.kable.NA = '',scipen = 8,big.mark=" ")
opts_knit$set(global.par = TRUE,warning = FALSE, message = FALSE, fig.align = "center",fig.pos = "H", out.extra = "",results = 'asis',echo=FALSE)

ls2e <- function(x){
  invisible(list2env(x,envir = globalenv()))
}
# Colors

iblue <- darken(rgb(0.024,0.282,0.478),amount = .4)
mblue <- rgb(0.024,0.282,0.478)
ablue <- rgb(0.729,0.824,0.878)
ared  <- rgb(0.671,0.161,0.18)

# Symbols 

info <- "{0pt}{\\faInfoCircle}{iblue}"
alt  <- "{0pt}{\\faExclamationTriangle}{red!75!black}"

# web vs pdf options

html <- knitr::is_html_output()
cex <- ifelse(html,1,.65)

fig.def <- function(height = 2.4, width = 6.5){
  if (!html) {
    knitr::opts_chunk$set(echo = FALSE,fig.height = height,fig.width = width,fig.align = "center",
                          fig.pos = "H", out.extra = "",warning = FALSE, message = FALSE,results = 'asis')
    cex<-.65
    }
  if ( html) {
    knitr::opts_chunk$set(echo = FALSE,warning = FALSE, message = FALSE,results = 'asis')
    cex<- 1
  }
}
fig.def()
par(lwd=.5,col.main=iblue,mfrow=c(1,1),cex=cex)

