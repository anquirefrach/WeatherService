var helloWorldProxy;

// Initializes global and proxy default variables.
function pageLoad() {
    // Instantiate the service proxy.
    helloWorldProxy = new Samples.Aspnet.HelloWorld();

    // Set the default call back functions.
    helloWorldProxy.set_defaultSucceededCallback(SucceededCallback);
    helloWorldProxy.set_defaultFailedCallback(FailedCallback);
}

// Processes the button click and calls
// the service Greetings method.  
function OnClickGreetings() {
    var greetings = helloWorldProxy.Greetings();
}

function OnClickWeather(longitude, latitude, mainWeather, minMaxTemp, sunriseSunset, pressure, humidity, wind) {
    var greetings = helloWorldProxy.Weather(longitude, latitude, mainWeather, minMaxTemp, sunriseSunset, pressure, humidity, wind);
}


// Callback function that
// processes the service return value.
function SucceededCallback(result) {
    //var RsltElem = document.getElementById("Results");

    //RsltElem.innerHTML = result;
   //document.getElementById('popup-content').innerHTML = '';

    document.getElementById('popup-content').innerHTML = result;

}

// Callback function invoked when a call to 
// the  service methods fails.
function FailedCallback(error, userContext, methodName) {
    if (error !== null) {
        //var RsltElem = document.getElementById("Results");
        var RsltElem = document.getElementById("popup-content");

        //RsltElem.innerHTML = "An error occurred: " +
        //    error.get_message();
        RsltElem.innerHTML = "An error occurred: " +
    error.get_message();

    }
}

if (typeof (Sys) !== "undefined") Sys.Application.notifyScriptLoaded();
