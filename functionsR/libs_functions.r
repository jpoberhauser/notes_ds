library(tidyr)
library(dplyr)
library(RPostgreSQL)
library(yaml)
library(futile.logger)
# suppressMessages(source("../../opi_lib/r/load.r",chdir=TRUE))
# suppressMessages(source("../../opi_lib/r/libraries.r",chdir=TRUE))
normalizarNombres <- function(nombres_de_columnas) {
    # Quitamos trailing spaces y cambiamos espacios multiples por uno solo.
    nombres_de_columnas <- gsub("^ *|(?<= ) | *$", "", nombres_de_columnas, perl=T)
    # Cambiamos espacios y puntos por _
    nombres_de_columnas <- gsub('\\ |\\.', '_', nombres_de_columnas)
    # Cambiamos casos como camelCase por camel_case
    nombres_de_columnas <- gsub("([a-z])([A-Z])", "\\1_\\L\\2", nombres_de_columnas, perl = TRUE)
    # Quitamos ñ's
    nombres_de_columnas <- gsub('ñ','n',nombres_de_columnas)
    # Quitamos acentos
    nombres_de_columnas <- iconv(nombres_de_columnas, to='ASCII//TRANSLIT')
    # Quitamos mayusculas
    tolower(nombres_de_columnas)
}


psql_df<-function(sql,file_parametros="../parametros.yaml", print=TRUE){
    x <- yaml.load_file(file_parametros)
    # Creamos el driver
    driver <- dbDriver("PostgreSQL")
    # Creamos la conexión a la base de datos
    #flog.info("Conectando a la base de datos")
    #Para usar en la maquina local o la maquina virtual
    if(is.null(x$port)){
    #Virtual
        con <- dbConnect(driver, user=x$username, dbname=x$db, password=x$password,host=x$host)
    } else
{    #Local
        con <- dbConnect(driver, user=x$username, dbname=x$db, password=x$password,host=x$host, port=x$port)
    }
    if(print){flog.info("Conectado a %s:%s -- %s", x$host, x$username, substring(sql,0,25))}
    #flog.info("Ejecutando el query")
    # Creamos el query
    rs <- dbSendQuery(con, sql)

    #flog.info("Obteniendo los datos")
    # Obtenemos los datos
    df <- fetch(rs, -1)
    # Liberamos el ResultSet
    #flog.info("Limpiando el result set")
    dbClearResult(rs)
    dbDisconnect(con)
    #saveRDS(object=df, file=df.file)
    df
}

df2sql<-function(data.frame, df.table.name,cols) {
  if(file.exists("./parametros.yaml")) {
    x <- yaml.load_file("../parametros.yaml")
  } else {
    x <- yaml.load_file("../parametros.yaml")
  }

  # Normalizamos nombres
  cols <- normalizarNombres(cols)
  names(data.frame) <- normalizarNombres(names(data.frame))

  # Creamos el driver
  driver <- dbDriver("PostgreSQL")

  # Creamos la conexión a la base de datos
  flog.info("Conectando a la base de datos")

 if(is.null(x$port)){
    #Virtual
        con <- dbConnect(driver, user=x$username, dbname=x$db, password=x$password,host=x$host)
    } else
{    #Local
        con <- dbConnect(driver, user=x$username, dbname=x$db, password=x$password,host=x$host, port=x$port)
    }

  flog.info("Conectado a %s, como %s", x$host, x$username)

  tryCatch( {
    flog.info("Ejecutando la escritura de tabla %s en el esquema %s", df.table.name[2],df.table.name[1])
    # Escribimos la tabla
    dbWriteTable(con,df.table.name,data.frame,overwrite=TRUE,col.names=cols,row.names=FALSE)
    flog.info("Escribiendo los datos")
    dbSendQuery(con, paste0("alter table ", df.table.name[1], ".",df.table.name[2], " owner to data_scientist"))
  }, finally=dbDisconnect(con)# Nos desconectamos de la BD
  )
  flog.info("Escritura finalizada")
  #on.exit({
  #  flog.info("Liberando el driver")
  #  dbUnloadDriver(driver)
  #})
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Load Metadata y Fmetadata
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
load_metadata <- function(generic_table_name,ag_geografica,schema){
  pre_q<-c("SELECT v.id as variable_id,v.varnom_tabla as nombre_variable, v.descripcion_detallada as descripcion_larga_variable, 
  v.tipo_variable_id,
  v.aparece_en_eql,
  h.nombre as tipo_variable,
  d.descripcion as descripcion_variable,v.descripcion_id as descripcion_id,
  v.unidad_id as unidad_id,u.nombre as unidad,
  z.id as transformacion_id, z.nombre as transformacion,
  c.id as concepto_id,c.nombre as concepto_variable,
  i.acronimo as generador_variable,
  v.archivo_id as archivo_id,t.nombre as nombre_archivo,
  v.geometria_id as geometria_id,g.nombre as geometria
  from metadata.variables v
  join metadata.archivos t on v.archivo_id = t.id
  join metadata.generadores i on v.generador_id = i.id
  join metadata.descripciones d on v.descripcion_id = d.id
  join metadata.conceptos c on d.concepto_id = c.id
  join metadata.geometrias g on v.geometria_id = g.id
  join metadata.unidades u on v.unidad_id = u.id
  join metadata.tipos_variable h on v.tipo_variable_id = h.id
  join metadata.transformaciones z on v.transformacion_id = z.id where t.nombre = ")

  pre_q <- gsub("metadata",schema,pre_q)

  post_q <- paste(pre_q, table_str,";",sep="")
  mdf<<-psql_df(post_q,"../parametros_datos.yaml")
}

load_metafuente <- function(generic_table_name,ag_geografica,schema){
  pre_qf <- c("SELECT g.id as generador_id, g.nombre as nombre_generador,
  g.acronimo as acronimo_generador,
  f.id as fuente_id, f.nombre as nombre_fuente, f.descripcion as descripcion_fuente,
  f.acronimo as acronimo_fuente,
  f.periodicidad_id, p.nombre as periodicidad,
  t.nombre as nombre_archivo, t.id as archivo_id, 
  t.span_temp as span_temporal,
  t.ag_temp_id as ag_temp_id, z.nombre as agregacion_temporal,
  t.url as url_data,
  t.ag_geo_id as ag_geo_id, d.nombre as agregacion_espacial
  from metadata.fuentes f
  join metadata.generadores g on f.generador_id = g.id
  join metadata.periodicidades p on f.periodicidad_id = p.id
  join metadata.archivos t on f.id = t.fuente_id
  join metadata.ags_temp z on t.ag_temp_id = z.id
  join metadata.ags_geo d on t.ag_geo_id = d.id
  where t.nombre = ")

  pre_qf <- gsub("metadata",schema,pre_qf)

  post_q <- paste(pre_qf, table_str,";",sep="")
  fmdf<<-psql_df(post_q,"../parametros_datos.yaml")
}


load_data <- function(table){
  pre_qdf <- c("SELECT * FROM ")
  post_q <- paste(pre_qdf, table,";",sep="")
  datos<<-psql_df(post_q,"../parametros_datos.yaml")
  # return(df)
}

load_metadata_ontologia_staging<- function(generic_table_name,ag_geografica,schema){
  pre_q<-c("SELECT 0 as tipo_variable_id,0 as tipo_variable_nombre, v.id as variable_id,v.varnom_tabla as nombre_variable, v.detailed_description as description_larga_variable, 
  v.appears_in_eql,
  d.description as description_variable,v.description_id as description_id,
  v.unit_id as unit_id,u.nombre as unidad,
  z.id as transformation_id, z.nombre as transformacion,
  c.id as concepto_id,c.name as concepto_variable,
  i.acronym as generador_variable,
  v.tabla_id as tabla_id,t.name as nombre_archivo,
  v.geometry_id as geometry_id,g.nombre as geometria
  from metadata.variables v
  join metadata.tablas t on v.tabla_id = t.id
  join metadata.generadores i on v.generador_id = i.id
  join metadata.descriptions d on v.description_id = d.id
  join metadata.concepts c on d.concept_id = c.id
  join metadata.geometrias g on v.geometry_id = g.id
  join metadata.unidades u on v.unit_id = u.id
  join metadata.transformaciones z on v.transformation_id = z.id where t.name = ")

  pre_q <- gsub("metadata",schema,pre_q)

  post_q <- paste(pre_q, table_str,";",sep=)
  mdf<<-psql_df(post_q,"../parametros_datos.yaml")
}


load_metafuente_ontologia_staging <- function(generic_table_name,ag_geografica,schema){
  pre_qf <- c("SELECT g.id as generador_id, g.name as nombre_generador,
  g.acronym as acronimo_generador,
  f.id as fuente_id, f.name as nombre_fuente, f.description as descripcion_fuente,
  f.acronym as acronimo_fuente,
  f.periodicidad_id, p.name as periodicidad,
  t.name as nombre_archivo, t.id as archivo_id, 
  t.span_temp as span_temporal,
  t.agg_temp_id as ag_temp_id, z.nombre as agregacion_temporal,
  t.url as url_data,
  t.agg_geo_id as ag_geo_id, d.nombre as agregacion_espacial
  from metadata.fuentes f
  join metadata.generadores g on f.generador_id = g.id
  join metadata.periodicidades p on f.periodicidad_id = p.id
  join metadata.tablas t on f.id = t.fuente_id
  join metadata.ags_temp z on t.agg_temp_id = z.id
  join metadata.ags_geo d on t.agg_geo_id = d.id
  where t.name = ")

  pre_qf <- gsub("metadata",schema,pre_qf)

  post_q <- paste(pre_qf, table_str,";",sep="")
  fmdf<<-psql_df(post_q,"../parametros_datos.yaml")
}
