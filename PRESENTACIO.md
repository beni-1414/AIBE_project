# GUIÓ PRESENTACIO - 14/05/2024 a les 8:45

- Timeline del que hem fet (fa la funció de index)
- Dataset description: Com es el dataset? Quines vars tenim?
- Plots abans de netejar.
- Data processing amb R: Outliers trobats, etc
- EDA despres de processar: distribucions, vars categoriques...
- Clustering: @Bustos
- **Prediction algorithms normals**:
    * **Lasso**: Permet veure quines son les features mes importants si fessim una regressio lineal. El més alt es esperablement la pressio sistòlica, despres tenim l'edat, el colesterol i per ultim la pressió diastòlica i el BMI. la resta de variables van a zero. Take with a grain of salt pk algunes variables son categoriques i Lasso esta més pensat per coses continues, pero si només s'utilitzen les continues dona una accuracy del 50% que es un mierdolo.
    * **Logistic Regression**: Per provar, dona un 72%, res de l'altre mon, he fet Cross validation per poder estar mes segurs del resultat i es bastant estable.
    * **KNN**: Per provar, dona un 70% d'accuracy, tampoc res de l'altre mon. Hi ha tmb CV per ser mes robust.

- **Wide and deep neural network**:

Aquest tipus de xarxa neuronal es molt utilitzat en classificació binaria quan tens variables continues i categoriques. Les categoriques passen per una capa d'embedding, que aplica One Hot Encoding per tenirles en un format que la NN pugui entendre. Aleshores es concatena amb les variables continues i es crea un primer `wide_output` a partir de una Dense layer (un fully connected de tota la vida). Aquest output captura les relacions linials dins del dataset, i ja queda guardat. A continuació, s'apliquen una serie de Fully Connected layers i s'arriba a un altre Output, el `deep_output`.

En la majoria dels casos, sembla que el `deep_output` va millor pero son valors molt semblants. S'han provat dos tipus de optimizers diferents, s'ha provat de treure la `wide_output` a veure si millorava (i no ho ha fet), s'han provat diversos learning rates.

Totes les proves que s'han fet donen valors al voltant de 72-74% accuracy al validation set, cosa que no es una millora significativa respecte els algoritmes classics.

- **Mixing Clustering into NN**: 

Per intentar millorar els resultats, intento un pipeline que seria agafar els pacients, passarlos pel KMeans per classificarlos en un dels 5 clusters decidits i llavors classificarlos amb una NN personalitzada dins aquell mateix cluster, de manera que pugui ser mes especific (almenys intuitivament). Executant aixo tenim clusters amb un 70% i clusters amb fins a un 78%. Si fem una mitjana ponderada amb la mida de cada cluster acaba sortint el mateix 73%, no passem d'aqui.

- **Conclusions**: