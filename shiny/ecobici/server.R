shinyServer(function(input, output,session){

    #----------------
    #Histograma
    #-------------------
    output$distPlot = renderPlot({

        x <- as.numeric(df$Edad_Usuario)
        suppressMessages(hist(x, col = 'grey', border = 'cyan',main = "Edad de los Usuarios"))
        })
    #----------------
    #Plot Generi
    #------------------- 
     output$conteo_genero = renderPlot({
       
        c <- qplot(factor(df$Genero_Usuario), data = df, geom='bar',fill=factor(df$Genero_Usuario))
        c + labs(title = "Genero de Usuarios",x = "Genero",y = "Cantidad")
        },height = 400)


})

