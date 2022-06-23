{{- define "uptrace.zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.zookeeper.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "uptrace.fullname" .) "zookeeper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Set zookeeper host
*/}}
{{- define "uptrace.zookeeper.host" -}}
{{- include "uptrace.zookeeper.fullname" . -}}
{{- end -}}

{{/*
Set zookeeper port
*/}}
{{- define "uptrace.zookeeper.port" -}}
    2181
{{- end -}}
