


void setup() {
  size(500, 500);
}

void draw() {
  background(0);

  if (frameCount % 5 == 0) {
    listOfSampleElement.add(new SampleElement(
      random(0, width),
      random(0, height),
      random(0, 10),
      random(5, 15)
      ));
  }

  // parcourir chaque objet (créé depuis une class, ici SampleElement)
  for (SampleElement sampleElement : listOfSampleElement) {
   

    //le dessinner
    sampleElement.draw();

    // et l'ajouter, si il est trop "agé", a la liste des éléments a supprimer
    if (sampleElement.lifespan < millis() - sampleElement.timeOfCreation) listOfSampleElementToRemove.add(sampleElement);
  }

  listOfSampleElement.removeAll(listOfSampleElementToRemove);


  println(listOfSampleElement.size());
}
