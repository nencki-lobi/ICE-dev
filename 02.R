library('dplyr')
library('tidyr')

## Load data

load(file = "./01/input/dataset.RData")

## Load subjects

load(file = "./01/output/subjects.RData")

## List of questionnaires

qnames = c("ICE-168")

## Load items

nquest = length(qnames)
questionnaires = NULL

for (i in 1:nquest) {
  fname = paste(qnames[i], ".tsv", sep="")
  items = read.table(file.path("./02/input",fname), header = F, sep = "\t", encoding = "UTF-8")
  
  header = c("PL","EN","code") ## FIXIT
  colnames(items) = header[1:ncol(items)]
  
  questionnaires[[i]] = items
}

names(questionnaires) = qnames

## Example use

# questionnaires[["ICE-168"]][,"PL"]
# questionnaires[["ICE-168"]] %>% filter(grepl('ANG', code))
# questionnaires[["ICE-168"]] %>% filter(!grepl('CHECK', code))

## Get questionnaire data

qdata = filter(df, token %in% subjects$token)

## Remove CHECK items

qdata = select(qdata, !contains("CHECK"))

## Define helpers for ICE

items = questionnaires[["ICE-168"]]

code_to_pl = items$PL
names(code_to_pl) = items$code

code_to_en = items$EN
names(code_to_en) = items$code

ICE = select(qdata, contains("BLOCK"))
code_messy = colnames(ICE)
code_splitted = strsplit(code_messy, ".", fixed = TRUE)
code_flattened = as.data.frame(do.call(rbind, code_splitted))
colnames(code_flattened) = c("block","code")

code_to_block = code_flattened$block # block number, in which item was displayed
names(code_to_block) = code_flattened$code

## Rename ICE items

newcolnames = paste("ICE-168-pl", names(code_to_block), sep = ".")
idx = grepl('BLOCK', colnames(qdata))

colnames(qdata)[idx] = newcolnames

## Save output

save(questionnaires, qdata, subjects, code_to_pl, code_to_en, code_to_block, 
     file = "./02/output/dataset.RData")
