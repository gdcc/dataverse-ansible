#!/bin/sh

curl http://localhost:8080/api/admin/externalTools > /tmp/externalTools.json

upload_if_necessary() {
	JSON=$1
	TOOL_URL_LINE=`echo "$JSON" | grep toolUrl | sed -e 's/^[[:space:]]*//'`
	CONTENT_TYPE_LINE=`echo "$JSON" | grep contentType | sed -e 's/^[[:space:]]*//'`
	grep -q "$TOOL_URL_LINE" /tmp/externalTools.json && \
		grep -q "$CONTENT_TYPE_LINE" /tmp/externalTools.json && \
		echo "skipping $TOOL_URL_LINE $CONTENT_TYPE_LINE"
		return
	curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/externalTools -d "$JSON"
}

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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

upload_if_necessary \
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
