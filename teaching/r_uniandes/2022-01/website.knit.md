---
pagetitle: Taller de R, ECON-1302
---

<!--- Inicio Emcabezado --->
<html>
<head>
<meta charset="utf-8" />
<meta name="generator" content="pandoc" />
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<title>Eduard F. Martínez-González</title>
<script src="site_libs/jquery-1.11.3/jquery.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link href="site_libs/bootstrap-3.3.5/css/cerulean.min.css" rel="stylesheet" />
<script src="site_libs/bootstrap-3.3.5/js/bootstrap.min.js"></script>
<script src="site_libs/bootstrap-3.3.5/shim/html5shiv.min.js"></script>
<script src="site_libs/bootstrap-3.3.5/shim/respond.min.js"></script>
<script src="site_libs/navigation-1.1/tabsets.js"></script>
<script src="site_libs/accessible-code-block-0.0.1/empty-anchor.js"></script>
<link href="site_libs/font-awesome-5.1.0/css/all.css" rel="stylesheet" />
<link href="site_libs/font-awesome-5.1.0/css/v4-shims.css" rel="stylesheet" />
</head>
<body>
<div class="container-fluid main-container">
<div class="navbar navbar-inverse  navbar-fixed-top" role="navigation">
<div class="container">
<div class="navbar-header">
<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
<span class="icon-bar"></span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
</button>

<a class="navbar-brand" href="https://eduard-martinez.github.io/index.html">Eduard F. Martínez-González</a>
</div> <div id="navbar" class="navbar-collapse collapse">
<ul class="nav navbar-nav"> </ul> <ul class="nav navbar-nav navbar-right">

<li><a href="https://eduard-martinez.github.io/index.html"><span class="fa fa-home"></span>Home</a></li>

<li><a href="https://eduard-martinez.github.io/research.html">Research</a></li>

<li><a href="https://eduard-martinez.github.io/cv/C_Eduard_F_Martinez_G.pdf">CV</a></li>

<li><a href="https://eduard-martinez.github.io/teaching.html">Teaching</a></li>

<li><a href="https://eduard-martinez.github.io/blog.html">Blog</a></li>

<li><a href="https://eduard-martinez.github.io/databases.html">Databases</a></li>

</div><!--/.nav-collapse -->
</div><!--/.container -->
</div><!--/.navbar -->
<div class="fluid-row" id="header">
<!--- Fin Emcabezado --->


<!--------------------------------- El codigo inicia aca --------------------------------->

<br> </br>

<!------------- Panel de la izquierda ------------->
<div class="col-sm-9">



<!--- Tirulo --->
<h1 style="color:black;">Taller de R, ECON-1302 </h1>

### Acerca de este curso

`<svg aria-hidden="true" role="img" viewBox="0 0 576 512" style="height:1em;width:1.12em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M542.22 32.05c-54.8 3.11-163.72 14.43-230.96 55.59-4.64 2.84-7.27 7.89-7.27 13.17v363.87c0 11.55 12.63 18.85 23.28 13.49 69.18-34.82 169.23-44.32 218.7-46.92 16.89-.89 30.02-14.43 30.02-30.66V62.75c.01-17.71-15.35-31.74-33.77-30.7zM264.73 87.64C197.5 46.48 88.58 35.17 33.78 32.05 15.36 31.01 0 45.04 0 62.75V400.6c0 16.24 13.13 29.78 30.02 30.66 49.49 2.6 149.59 12.11 218.77 46.95 10.62 5.35 23.21-1.94 23.21-13.46V100.63c0-5.29-2.62-10.14-7.27-12.99z"/></svg>`{=html} [Syllabus](https://eduard-martinez.github.io/teaching/r_uniandes/2022-01/syllabus.pdf)

`<svg aria-hidden="true" role="img" viewBox="0 0 496 512" style="height:1em;width:0.97em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3.3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5.3-6.2 2.3zm44.2-1.7c-2.9.7-4.9 2.6-4.6 4.9.3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3.7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3.3 2.9 2.3 3.9 1.6 1 3.6.7 4.3-.7.7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3.7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3.7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z"/></svg>`{=html} **Repositorio del curso** [clik aquí](https://github.com/taller-R/taller_r_202201)

`<svg aria-hidden="true" role="img" viewBox="0 0 448 512" style="height:1em;width:0.88em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M0 464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V192H0v272zm320-196c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zm0 128c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zM192 268c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zm0 128c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zM64 268c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12H76c-6.6 0-12-5.4-12-12v-40zm0 128c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12H76c-6.6 0-12-5.4-12-12v-40zM400 64h-48V16c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v48H160V16c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v48H48C21.5 64 0 85.5 0 112v48h448v-48c0-26.5-21.5-48-48-48z"/></svg>`{=html} **Clases:** Lunes 17:00 – 18:15, Salón B-404

`<svg aria-hidden="true" role="img" viewBox="0 0 512 512" style="height:1em;width:1em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M256,8C119,8,8,119,8,256S119,504,256,504,504,393,504,256,393,8,256,8Zm92.49,313h0l-20,25a16,16,0,0,1-22.49,2.5h0l-67-49.72a40,40,0,0,1-15-31.23V112a16,16,0,0,1,16-16h32a16,16,0,0,1,16,16V256l58,42.5A16,16,0,0,1,348.49,321Z"/></svg>`{=html} **Horario de atención:** Lunes 10:00 – 11:00, Oficina W-722

### Instalar softwares y registrarse

**[1] Descargar [R](https://cran.r-project.org/)**

**[2.] Descargar [RStudio](https://www.rstudio.com/products/rstudio/download/preview/)**

RStudio es un entorno de desarrollo integrado (IDE) para el lenguaje de programación R. Esta IDE brinda una interfaz más amigable con el usuario facilitando el aprendizaje.

**[3.] Descargar [Git](https://git-scm.com/downloads)**

Git es un sistema de control de versiones sobre el que está soportada la plataforma de [GitHub](https://github.com) (una plataforma de desarrollo colaborativo).
  
**[4.] Instalar R, RStudio y Git**

Puede ir a este [enlace](https://lectures-blog.gitlab.io/R-initial-setup/#/antes-de-iniciar-el-curso) y seguir las instrucciones de instalación para el sistemas operativo de su equipo.

**[5.] Crear una cuenta en [GitHub](https://github.com)**

Puede registrarse como estudiante/educador para obtener [beneficios](https://education.github.com/benefits) adicionales.

### Lectures Slides

* **[Lecture 1](https://lectures-r.gitlab.io/202201/lecture-1)** 

* **[Lecture 2](https://lectures-r.gitlab.io/202201/lecture-2)** 

* **[Lecture 3](https://lectures-r.gitlab.io/202201/lecture-3)** - **[task](https://lectures-r.gitlab.io/task_202202/task-clase-03/)**

* **[Lecture 4](https://lectures-r.gitlab.io/202201/lecture-4)** - **[task](https://lectures-r.gitlab.io/task_202202/task-clase-04/)**


</div>

<!------------- Panel de la derecha ------------->
<div class="col-sm-3">

#### Eduard F. Martínez-González
 
<!-- Correo -->
<p style="color:black;font-size:12px;"><img alt="Qries" src="images/correo.png" width=20" height="20"> ef.martinezg@uniandes.edu.co </img></p>

<!-- Correo -->
<p style="color:black;font-size:12px;"><img alt="Qries" src="images/correo.png" width=20" height="20"> edfemagonza@gmail.com </img></p>

<!-- Tel -->
<p style="color:black;font-size:12px;"><img alt="Qries" src="images/tel.png" width=20" height="20"> (+571) 3394949 Ext: 2430</img></p>

<!-- Twitter -->
 <a href="https://twitter.com/emartigo" style="color:black;font-size:12px;"> <img alt="Qries" src="images/twitter.jpg" width=20" height="20">  @emartigo</a> 

<!-- GitHub -->
<a href="https://github.com/eduard-martinez" style="color:black;font-size:12px;"> <img alt="Qries" src="images/github.png" width=20" height="20">  eduard-martinez</a>

</div>
<!------------- Panel de la derecha ------------->





<!--------------------------------- El codigo finaliza aca --------------------------------->





</div>
<script>
// add bootstrap table styles to pandoc tables
function bootstrapStylePandocTables() {
$('tr.header').parent('thead').parent('table').addClass('table table-condensed');
}
$(document).ready(function () {
bootstrapStylePandocTables();
});
</script>
<!-- tabsets -->
<script>
$(document).ready(function () {
window.buildTabsets("TOC");
});
$(document).ready(function () {
$('.tabset-dropdown > .nav-tabs > li').click(function () {
$(this).parent().toggleClass('nav-tabs-open')
});
});
</script>
<!-- code folding -->
<!-- dynamically load mathjax for compatibility with self-contained -->
<script>
(function () {
var script = document.createElement("script");
script.type = "text/javascript";
script.src  = "http://example.com/MathJax.js";
document.getElementsByTagName("head")[0].appendChild(script);
})();
</script>
</body>
</html>
