# library('RPostgreSQL')
library('dplyr')
library('tidyr')

## Connect to database

# pg = dbDriver("PostgreSQL")
# 
# con = dbConnect(pg, user="grieg", password="",
#                 host="localhost", port=5432, dbname="grieg")

## Load data

# query = "SELECT
# s.sid, s.code, s.ts,
# q.name, a.ord, a.val
# FROM subject s
# JOIN quest q ON q.sid = s.sid
# JOIN answer a ON a.qid = q.qid
# WHERE s.stid = 9 AND s.qidv_idx > 5
# ORDER BY s.sid, q.name, a.ord"
# 
# df = dbGetQuery(con, query)
# save(df, file = "./02/input/dataset.RData")

load(file = "./02/input/dataset.RData")

## Load subjects

load(file = "./01/output/subjects.RData")

## List of questionnaires

qnames = c("ICE-32", "MHC-SF")

# NOTE: The remaining questionnaires ("demo-0") have no corresponding 
# TSV file and are therefore not listed in the `qnames` variable.

## Load items

nquest = length(qnames)
questionnaires = NULL

for (i in 1:nquest) {
  fname = paste(qnames[i], ".tsv", sep="")
  items = read.table(file.path("./02/input",fname), header = F, sep = "\t", encoding = "UTF-8")
  
  header = c("PL","EN","NO","code")
  colnames(items) = header[1:ncol(items)]
  
  questionnaires[[i]] = items
}

names(questionnaires) = qnames

## Example use

# questionnaires[["ICE-32"]][,"PL"]
# questionnaires[["ICE-32"]] %>% filter(grepl('ANG', code))
# questionnaires[["ICE-32"]] %>% filter(!grepl('CHECK', code))

## Get data for a single questionnaire

# qname = paste("MHC-SF", "-pl", sep="")
# qdata = filter(df, name == qname & sid %in% subjects$sid)
# 
# qdata = select(qdata, sid, code, ts, ord, val) %>%
#   pivot_wider(id_cols = c("sid", "code", "ts"), names_from = "ord", values_from = "val")

## Get data for all questionnaires but demographics

# qdata = filter(df, name != "demo-0-pl" & sid %in% subjects$sid)
# 
# qdata = select(qdata, sid, code, ts, name, ord, val) %>%
#   pivot_wider(id_cols = c("sid", "code", "ts"), 
#               names_from = c("name", "ord"), 
#               names_sep = ".",
#               values_from = "val")

## Get data for all questionnaires

qdata = filter(df, sid %in% subjects$sid)

qdata = select(qdata, sid, code, ts, name, ord, val) %>%
  pivot_wider(id_cols = c("sid", "code", "ts"),
              names_from = c("name", "ord"),
              names_sep = ".",
              values_from = "val")

qdata = subjects %>%
  inner_join(qdata, by = c("sid", "code", "ts")) %>%
  select(-rid)

## Example use

# select(qdata, contains(c("sid","code","ICE-32")))
# select(qdata, contains(c("sid","code","MHC-SF")))

## Rename ICE items

newcolnames = paste("ICE-32-pl", questionnaires[["ICE-32"]]$code, sep = ".")
idx = grepl('ICE-32', colnames(qdata))

colnames(qdata)[idx] = newcolnames

## Remove CHECK items (both items and data)

questionnaires[["ICE-32"]] = questionnaires[["ICE-32"]] %>% filter(!grepl('CHECK', code))
qdata = qdata %>% select(!contains("CHECK"))

## Define helpers for ICE

items = questionnaires[["ICE-32"]]

code_to_pl = items$PL
names(code_to_pl) = items$code

code_to_en = items$EN
names(code_to_en) = items$code

code_to_no = items$NO
names(code_to_no) = items$code

## Save output

save(questionnaires, qdata, subjects, code_to_pl, code_to_en, code_to_no, 
     file = "./02/output/dataset.RData")
