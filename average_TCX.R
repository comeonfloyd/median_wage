setwd("C:/Users/Alexander.Persidskiy/Desktop/DF/wagetype")

library(readxl)

X012022 <- read_excel("012022.xlsx", skip = 5)
X022022 <- read_excel("022022.xlsx", skip = 5)
X032022 <- read_excel("032022.xlsx", skip = 5)
X042022 <- read_excel("042022.xlsx", skip = 5)
X052022 <- read_excel("052022.xlsx", skip = 5)
CFO_TN <- read_excel("CFO_TN_01_05.xlsx")

tulip <- c('Табельный номер',
           '0001 Оплата оклад/тариф',
           '0008 Оклад розница',
           '2M12 Премия рез.фин.-хоз.деят.',
           'начислено')

cut_off2 <- function(x){
  x %>% 
    select(., c(tulip))
}

X012022 <- cut_off2(X012022)
X022022 <- cut_off2(X022022)
X032022 <- cut_off2(X032022)
X042022 <- cut_off2(X042022)
X052022 <- cut_off2(X052022)

X012022 <- merge(X012022, 
                 subset(CFO_TN, CFO_TN$`Месяц Год ID` == 202201), 
                 by.x = 'Табельный номер', 
                 by.y = 'Табельный Номер', 
                 all.x = TRUE)

X022022 <- merge(X022022, 
                 subset(CFO_TN, CFO_TN$`Месяц Год ID` == 202202), 
                 by.x = 'Табельный номер', 
                 by.y = 'Табельный Номер', 
                 all.x = TRUE)

X032022 <- merge(X032022, 
                 subset(CFO_TN, CFO_TN$`Месяц Год ID` == 202203), 
                 by.x = 'Табельный номер', 
                 by.y = 'Табельный Номер', 
                 all.x = TRUE)

X042022 <- merge(X042022, 
                 subset(CFO_TN, CFO_TN$`Месяц Год ID` == 202204), 
                 by.x = 'Табельный номер', 
                 by.y = 'Табельный Номер', 
                 all.x = TRUE)

X052022 <- merge(X052022, 
                 subset(CFO_TN, CFO_TN$`Месяц Год ID` == 202205), 
                 by.x = 'Табельный номер', 
                 by.y = 'Табельный Номер', 
                 all.x = TRUE)

library(plyr)
all_df <- rbind.fill(X012022,
                     X022022,
                     X032022,
                     X042022,
                     X052022)

df_agg <- aggregate(cbind(`0001 Оплата оклад/тариф`,
                          `0008 Оклад розница`,
                          `2M12 Премия рез.фин.-хоз.деят.`,
                          `начислено`)~ `ЦФО Регион Наименование` 
                    + `Должность Полное Наименование` + 
                      `ШД Полное Наименование` +
                      `ЦФО ID` + 
                      `ОргЕд Наименование`, 
                    all_df, 
                    median)

write.csv(df_agg, file = 'average_log_median.csv')
