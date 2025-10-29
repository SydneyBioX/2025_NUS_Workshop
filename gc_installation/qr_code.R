library(qrcode)

# your Google Sheets URL
url <- "https://docs.google.com/spreadsheets/d/1ftRyOc_FuU5iMd9xG6Y3iYOoto9kA1mM04bMto1VnCU/edit?gid=0#gid=0"

# generate QR object
qr <- qr_code(url)   # see {qrcode} package doc for arguments such as ecl (error‐correction level) :contentReference[oaicite:0]{index=0}

# plot it (in R graphical device)
plot(qr, asp = 1)

