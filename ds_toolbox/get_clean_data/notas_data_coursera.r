download.file()
if(!file.exists("data")){dir.create("data")}
download.file(fileURL, "./data/cameras.csv", method = "curl")

dateDownloaded <- date()
