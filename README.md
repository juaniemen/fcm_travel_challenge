# 📌 Ruby Challenge FCM Travel

## 📖 Intro
Se pide implementar un sistema el cual parsee, ordene y agrupe las distintas reservas que llegan al sistema por parte de un usuario "afincado" en una localización específica. Para completarlo se ha creado un conjunto de modelos que responden a las características de información de las "entidades", un conjunto de parsers que apoyados en los modelos van a transformar la información en estas clases Ruby manejando la información en el contexto de la aplicación y un "modulo" trips que se encarga de ordenar y agrupar estos segmentos.

En la definición de la arquitectura de la aplicación se ha tenido en cuenta la escalabilidad (*es por ello que es bastante completo a pesar de que se puede realizar todo en un script*).

Se ha formulado como un proyecto simple en cuanto a dependencias, es puro Ruby 3.2.5
Tampoco se espera que un solo usuario genere datos de más de el orden de unos megas por lo que técnicas como splittear el fichero, ejecutarlo por partes, y aplicar concurrencia, se han descartado por no sobredimensionar el problema.

### 📌 Asunciones
En algún momento se ha tenido que asumir ciertas características para poder completarlo:
- Como se comenta en la especificación, el link entre un transporte y otro viene dado por una franja de tiempo de no más de 24h.
- Así mismo se ha establecido que el link entre un transporte y el alojamiento (se ha generalizado hotel), sea de no más de 12 horas, aunque esto se podría configurar. *En trip.rb se especifica mediante una constante por lo que se podría reformular rápido*
- Se entiende que la fecha de entrada y la de salida de hotel no puede ser la misma. Esta asunción facilita el ordenado, al no haber hora de entrada y salida hace posible que conceptualmente sea secuencial.
- Tanto las *locations* como los *timestamps* no pueden ser nulos
- Se asume que no hay solapamiento de segmentos. A pesar de no ser diseñado como un grafo, por simplificar sin añadir librerías externas, es posible que se pueda formular como este aunque ya habría que pensar en restricciones, outputs, y demás.
- Se asume que una trip empieza con un transporte desde BASED, no con un hotel.
- Se asume que no se puede viajar desde una location a la misma

## 🚀 Diseño

Se separan claramente tres unidades conceptuales:

- Los modelos (carpeta *models*). Donde se define la información con la que se va a trabajar. A parte de esto, estos modelos vienen marcados por la ParseableInterface, esta interfaz-contrato le va a obligar a los modelos a definir un **IDENTIFICADOR**, una **REGEX**, un método de instancia output y un método de clase attributes.
  El **IDENTIFICADOR** mapea lo que está en la linea que parseamos con la clase modelo, el **REGEX** es la definición de la linea que parseamos, el output nos sirve para definir el output y attributes para transformar los matches del **REGEX** a atributos Ruby y poder crear el objeto.
  
  Realmente, estos models no se contemplan como modelos de Rails, apoyan a la función que se nos pide, no se ven como entidades conceptuales base de la aplicación, si fuera así sería mejor separar estás funcionalidades para que se adecuen más a Single Responsability de SOLID.

- Los parsers (carpeta *parsers*). Apoyan al "modulo" trips para resolver el problema, en estos se gestionan la obtención de los datos y el manejo de los errores de esta obtención. También se comprueba la validez del fichero.

-  Servicio de Trips (carpeta *trips*). En esta se generan las trips a raíz de las instancias de segmentos que vienen del parsing. Para simplificar un poco el manejo de estos se ha creado un wrapper que aplana los atributos creando una interfaz común.


### El algoritmo

En una etapa inicial se tienen en cuenta los segmentos que tienen como source la base y se itera sobre ellos. Por cada uno de ellos se intenta montar una trip, como esta iteracion es secuencial, los segmentos de una trip se descartan para la formación de la siguiente por lo que hace que cada vez se trabaje con menos datos.

La busqueda para un trip desde un segmento base es algo similar a lo que podría ser una búqueda en anchura/profundidad, con la principal diferencia de que en la cola de pendientes (*queue en el código*) solo va a haber un solo nodo, pues no se permiten solapamientos de segmentos para una misma trip. Un nodo no va a tener más de un nodo adyacente hacia abajo.


## 🧪 Pruebas

Se han realizado pruebas básicas con Minitest de todo el proceso, no son prueba que cubran todo ni estructuradas como en un proyecto real. Para cubrir todas las clases y hacer una posible BDD mejor hacerlas con Rspec, clase a clase, dedicandoles un tiempo prudente.

Para ejecutar los tests:
```
ruby tests/test_files.rb
```

## Ejecución

Una de las premisas cuando inicié la prueba era mantener el proyecto lo más simple posible (*teniendo en cuenta que pudiera crecer, claro*) es por ello que he decidido no utilizar dependencias externas más allá de Ruby 3.2.5. Por ello no hay Gemfile y no hay que ejecutarlo con bundle exec.

Para ejecutarlo, con vuestro ejemplo:
```
BASED=SVQ ruby main.rb input.txt
```

Para ejecutarlo, con el archivo de test:
```
BASED=SVQ ruby main.rb tests/files/input_large.txt
```


**Proyecto creado con:

Ruby: 3.2.5
**

## 📩 Contacto
Si tienes alguna pregunta, puedes contactarme en juaniemen@hotmail.com
