require(shiny);
require(caret);
require(e1071);
require(ggplot2);
data(iris);

# Divide the "iris" data set into a training set and a testing set
trainingIndices <- createDataPartition(y=iris$Species, p=0.7, list=FALSE);
training <- iris[trainingIndices,]
testing <- iris[-trainingIndices,]

# Train a model to predict the species based on petal size
model <- train(Species ~ Petal.Width + Petal.Length, method="rpart", data=training)

# Apply the model to the testing set and see how accurate our prediction is
# when used on observations outside of the set used to train the model
testingPredictions <- predict(model, newdata=testing)
conf.mtx <- confusionMatrix(testingPredictions, testing$Species)
accuracy <- conf.mtx$overall["Accuracy"]

shinyServer(
    function(input, output) {
        output$petalWidthText <- renderText({ 
            paste("Petal Width: ", input$petal.width, " cm")
        });

        output$petalLengthText <- renderText({ 
            paste("Petal Length: ", input$petal.length, " cm")
        });
                
        output$accuracyText <- renderText({
           paste("This tool has an out-of-sample accuracy rate of ", round(accuracy * 100, 2), "%.") 
        });

        # Put the input values into the model and predict the species
        output$speciesText <- renderText({
            inputValues <- data.frame(Petal.Width = input$petal.width, Petal.Length = input$petal.length)
            species <- as.character(predict(model, inputValues))
            paste("<h2 style=\"padding-top: 24pt; padding-bottom: 24pt;\">Predicted Species: <span style=\"color: #c00000;\">", species, "</span></h2>")
        })
        
        # Make a plot of the data set and add the user's values as a separate point
        output$irisPlot <- renderPlot({
            inputValues <- data.frame(Petal.Width = input$petal.width, Petal.Length = input$petal.length, Species = "Your Iris")
            ggplot(iris, aes(x=Petal.Width, y=Petal.Length)) +
                geom_point(aes(fill=Species), colour="black", pch=21, size=10) +
                geom_point(data=inputValues, aes(fill=Species), pch=21, size=10) +
                xlab("Petal Width") +
                ylab("Petal Length")
        });
    }
);