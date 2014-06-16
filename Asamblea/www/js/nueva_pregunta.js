    var pictureSource;   // picture source
    var destinationType; // sets the format of returned value 

    // Wait for Cordova to connect with the device
    //
    document.addEventListener("deviceready",onDeviceReady,false);

    // Cordova is ready to be used!
    //

    function prueba(){
         var token = localStorage.getItem("token");
         if(token==''){
              toast('Sesión no iniciada');
                      setTimeout(function (){
                        window.location='preguntele_lista.html';
                           //$(location).attr('href','../pages/log_in_sesion_iniciada.html'); 
                       }, 2000);
                      return false;

         }
    }

    function onDeviceReady() {
        pictureSource=navigator.camera.PictureSourceType;
        destinationType=navigator.camera.DestinationType;
    }

    // Called when a photo is successfully retrieved
    //
    function onPhotoDataSuccess(imageData) {
      // Uncomment to view the base64 encoded image data
      // console.log(imageData);

      // Get image handle
      //
      var smallImage = document.getElementById('smallImage');

      // Unhide image elements
      //
      smallImage.style.display = 'block';

      // Show the captured photo
      // The inline CSS rules are used to resize the image
      //
      smallImage.src = "data:image/jpeg;base64," + imageData;



    }

    // Called when a photo is successfully retrieved
    //
    function onPhotoURISuccess(imageURI) {
      // Uncomment to view the image file URI 
      // console.log(imageURI);

      // Get image handle
      //

      var largeImage = document.getElementById('largeImage');

      // Unhide image elements
      //
      largeImage.style.display = 'block';

      // Show the captured photo
      // The inline CSS rules are used to resize the image
      //
      largeImage.src = imageURI;

      uploadPhoto(imageURI);


    }

    // A button will call this function
    //
    function capturePhoto() {
      // Take picture using device camera and retrieve image as base64-encoded string
      navigator.camera.getPicture(onPhotoDataSuccess, onFail, { quality: 50,
        destinationType: destinationType.DATA_URL });
    }

    // A button will call this function
    //
    function capturePhotoEdit() {

      // Take picture using device camera, allow edit, and retrieve image as base64-encoded string  
       if (prueba() == false){
          return;
      }
       navigator.camera.getPicture(onPhotoURISuccess, onFail, { quality: 50, 
       destinationType: destinationType.FILE_URI });
       setTimeout(function (){
                           onPhotoURISuccess('imageURI'); 
                       }, 1000);  
    }

    // A button will call this function
    //
    function getPhoto(source) {
      // Retrieve image file location from specified 
      if (prueba() == false){
          return;
      }
      navigator.camera.getPicture(onPhotoURISuccess, onFail, { quality: 50, 
        destinationType: destinationType.FILE_URI,
        sourceType: source });
      setTimeout(function (){
                           onPhotoURISuccess('imageURI'); 
                       }, 1000);  
    }

    // Called if something bad happens.
    // 
    function onFail(message) {
      alert('Failed because: ' + message);
    }





    function uploadPhoto(imageURI) {
    var options = new FileUploadOptions();
    options.fileKey="file";
    options.fileName=imageURI.substr(imageURI.lastIndexOf('/')+1)+'.png';
    options.mimeType="text/plain";

    var params = new Object();

    options.params = params;

    var ft = new FileTransfer();  
    var direccion = "http://sismo.net16.net/asamblea/imagen.php?variable1=" + options.fileName ;
    var url_subir = 'http://sismo.net16.net/asamblea/images/' + options.fileName ;
    localStorage.setItem("url_imagen", url_subir);

    ft.upload(imageURI, encodeURI(direccion), win, fail, options);
    }

    function win(r) {
        console.log("Code = " + r.responseCode);
        console.log("Response = " + r.response);
        console.log("Sent = " + r.bytesSent);
    }

    function fail(error) {
        alert("An error has occurred: Code = " + error.code);
        console.log("upload error source " + error.source);
        console.log("upload error target " + error.target);
    }

    function enviar_pregunta(){

        if (prueba() == false){
          return;
       }

        var question = $('#pregunta').val();
        var url_foto = localStorage.getItem("url_imagen");
        var token = localStorage.getItem("token");
        var correo = localStorage.getItem("email_dipu");

        if (token != ''){

             var string = 'http://tec-asamblea.herokuapp.com/api/asamblea/nueva_pregunta?pregunta=' + question + '&email_diputado=' + correo  +'&url_foto= ' +  url_foto  +'&token=' + token;

             $.getJSON(string, function(data) {

                    var texto = data.respuesta;
                  
                    if (texto=='No se agrego la pregunta'){
                      toast('Error al crear pregunta');             
                    }

                    else{
                      toast('Pregunta agregada');
                      setTimeout(function (){
                           $(location).attr('href','preguntele_lista.html'); 
                       }, 2500);  
                  
                    }
                  
              });
        }

        else {
              toast('Error: sesión no iniciada');

        }
    }



function toast(message) {
    var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all"><h3>' + message + '</h3></div>');

    $toast.css({
        display: 'block', 
        background: '#fff',
        opacity: 0.90, 
        position: 'fixed',
        padding: '7px',
        'text-align': 'center',
        width: '270px',
        left: ($(window).width() - 284) / 2,
        top: $(window).height() / 2 - 20
    });

    var removeToast = function(){
        $(this).remove();
    };

    $toast.click(removeToast);

    $toast.appendTo($.mobile.pageContainer).delay(2000);
    $toast.fadeOut(400, removeToast);
}