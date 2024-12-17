#!/bin/sh

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Read Text",
  "description":"Read the text file.",
  "toolName":"textPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/TextPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"text/plain"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Html",
  "description":"View the html file.",
  "toolName":"htmlPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/HtmlPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"text/html"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Audio",
  "description":"Listen to an audio file.",
  "toolName":"audioPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/AudioPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"audio/mp3"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Audio",
  "description":"Listen to an audio file.",
  "toolName":"audioPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/AudioPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"audio/mpeg"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Audio",
  "description":"Listen to an audio file.",
  "toolName":"audioPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/AudioPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"audio/wav"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Audio",
  "description":"Listen to an audio file.",
  "toolName":"audioPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/AudioPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"audio/mp4"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Audio",
  "description":"Listen to an audio file.",
  "toolName":"audioPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/AudioPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"audio/x-m4a"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Audio",
  "description":"Listen to an audio file.",
  "toolName":"audioPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/AudioPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"audio/ogg"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Image",
  "description":"Preview an image file.",
  "toolName":"imagePreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/ImagePreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"image/gif"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Image",
  "description":"Preview an image file.",
  "toolName":"imagePreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/ImagePreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"image/jpeg"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Image",
  "description":"Preview an image file.",
  "toolName":"imagePreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/ImagePreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"image/png"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Read Document",
  "description":"Read a pdf document.",
  "toolName":"pdfPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/PDFPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"application/pdf"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Video",
  "description":"Watch a video file.",
  "toolName":"videoPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/VideoPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"video/mp4"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Video",
  "description":"Watch a video file.",
  "toolName":"videoPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/VideoPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"video/ogg"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"Play Video",
  "description":"Watch a video file.",
  "toolName":"videoPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/VideoPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"video/quicktime"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Data",
  "description":"View the spreadsheet data.",
  "toolName":"spreadsheetPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/SpreadsheetPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"text/comma-separated-values"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Data",
  "description":"View the spreadsheet data.",
  "toolName":"spreadsheetPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/SpreadsheetPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"text/tab-separated-values"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Data",
  "description":"View the spreadsheet data.",
  "toolName":"spreadsheetPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/SpreadsheetPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"text/csv"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Data",
  "description":"View the spreadsheet data.",
  "toolName":"spreadsheetPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/SpreadsheetPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"text/tsv"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Stata File",
  "description":"View the Stata file as text.",
  "toolName":"stataPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/TextPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"application/x-stata-syntax"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View R file",
  "description":"View the R file as text.",
  "toolName":"rPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/TextPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"type/x-r-syntax"
}'

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d \
'{
  "displayName":"View Annotations",
  "description":"View the annotation entries in a file.",
  "toolName":"annotationPreviewer",
  "scope":"file",
  "types":["preview"],
  "toolUrl":"https://gdcc.github.io/dataverse-previewers/previewers/v1.2/HypothesisPreview.html",
  "toolParameters": {
      "queryParameters":[
        {"fileid":"{fileId}"},
        {"siteUrl":"{siteUrl}"},
        {"key":"{apiToken}"},
        {"datasetid":"{datasetId}"},
        {"datasetversion":"{datasetVersion}"},
        {"locale":"{localeCode}"}
      ]
    },
  "contentType":"application/x-json-hypothesis"
}'
