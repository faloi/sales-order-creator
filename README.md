sales-order-creator
===================

Easily create SalesOrder on Parsimotion

## Prerrequisitos

* [NodeJS](http://nodejs.org/)
* [Compass](http://compass-style.org/)
* [Yeoman](http://yeoman.io/) - su instalación incluye [Grunt](http://gruntjs.com/) y [Bower](http://bower.io/)
* [Karma](http://karma-runner.github.io)

```
npm install -g yo
npm install
bower install
#instalar ruby
gem install compass
```

## Initial setup

Para manejar las dependencias que tienen que ver con cuestiones de SCM se utiliza **npm**, mientras que para las dependencias de la aplicación en sí utilizamos **bower**. Luego de clonar el repositorio por primera vez, correr el siguiente comando para instalar todas las dependencias:

    npm install && bower install

Entre las dependencias instaladas se encuentra [LiveReload](http://livereload.com/), un servidor que monitorea los cambios en HTML / JS / CSS y recarga la página. Para levantar el server hay que ejecutar la task **server** de la siguiente manera:

    grunt server
    
Esto levanta un server en el puerto _9000_ que se va a actualizar cada vez que editemos y guardemos un archivo fuente.

Por ultimo, para correr los tests utilizaremos [Karma](http://karma-runner.github.io/), un test runner que continuamente monitorea los sources y los tests y corre toda la suite cada vez que haya algún cambio. Para correrlo basta con ejecutar en una consola:
    
    karma start

## Frameworks y tecnologías principales

* [CoffeeScript](http://coffeescript.org/) - An attempt to expose the good parts of JavaScript in a simple way
