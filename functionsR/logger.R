require(stringr)
#revision de existencia directorio

logfile_init<-function(filename="log_scriptx"){
	if(!"report_logs"%in%dir()){dir.create("report_logs")}

	logfile<<-paste0("report_logs/",paste0(filename,"_",format(Sys.time(), '%Y-%m-%d'),sep=""),".csv",sep="")
	if(!file.exists(logfile)){
		file.create(logfile)
		}else{
			unlink(logfile)
			file.create(logfile)
		}
	#escritura headers
	headers<-c("timestamp, status, label, script, message, elapsed_time")
	write(headers,file=logfile,append=TRUE)
	fileflag<<-"../data_orchest/temp_flag.txt"
	unlink(fileflag)
	file.create(fileflag)
	write("0",file=fileflag,append=FALSE)
}


dslogger <- function(fn_str,lab,script){ 
	#lab es el nombre del paso a realizar por la función
	#fn_str es el texto que ejecuta la función 
	#script es el nombre del script que 
	#ejemplos fn_str<-'source("load_data.r")', fn_str<-'log("str")'

	#fileflag<-paste(script,"temp_flag.txt",sep="_")	
	tab<-read.table(fileflag)[1]
	if(!is.null(tab)){
		if(!tab==0){
			stop(paste("Paso anterior no completado REVISAR paso",lab))
			exit()
		}
	}
	flog.info(paste("Inicia",lab))
	tic<-Sys.time()
	try_str<-try(eval(parse(text=fn_str)), silent=TRUE)
	toc<-Sys.time()
	elap<-toc-tic
	if(class(try_str)=="try-error"){
		stat<-'Fail'
		flog.info(stat)
		message<-paste("\"",gsub(",","",str_replace_all(try_str[1], "\n", " ")),"\"",sep="")
		line<-paste(Sys.time(),stat,lab, script, message,elap,sep=",")
		write("1",file=fileflag,append=FALSE)
	}else{
		stat<-'Success'
		flog.info(stat)
		message<-'Complete'
		line<-paste(Sys.time(),stat,lab,script,message,elap,sep=",")
		write("0",file=fileflag,append=FALSE)
		write(geterrmessage(),file=fileflag,append=TRUE)
	}
	write(line,file=logfile,append=TRUE)
}

# Modo de uso 
# logfile_init("scriptX")

# fn_str<-'source("load_data.r")'
# lab<-'carga datos'

# fn_str2<-'log("r")'
# lab2<-'logaritmo eval'

# fn_str3<-'10*10'
# lab3<-'mult eval'


# dslogger(fn_str, lab)
# dslogger(fn_str2, lab2)
# dslogger(fn_str3, lab3)
