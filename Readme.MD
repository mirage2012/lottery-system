# Lottery System

## This repository contains:

1)  A simple web server in Go that should mock central lottery machine. 
2)  Dockerfile for this web server.
3)  An exemple YAML file that uses this container image. In actual practice helmchart would be used. 
4)  A sample Jenkins file that contains steps for continuous integration and continuous delivery.

A seperate Gitlab actions file is also sent that takes care of continuous deployment using helm and helmfile. 

### The sample web server has following endpoints:

&nbsp;&nbsp;&nbsp;  i) Health endpoint. GET https://{hostname}/health

   &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (1) This endpoint returns json {"status":"ok"} if the system is up and
running.

&nbsp;&nbsp;ii) Lottery endpoint. POST https://{hostname}/lottery

&nbsp;&nbsp;&nbsp; (1) Payload should have a lottery number and store ID.

&nbsp;&nbsp;&nbsp; (2) This endpoint returns json {"status":"ok"}