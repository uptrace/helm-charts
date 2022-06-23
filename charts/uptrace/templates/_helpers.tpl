{{/*
Expand the name of the chart.
*/}}
{{- define "uptrace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "uptrace.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "uptrace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "uptrace.labels" -}}
helm.sh/chart: {{ include "uptrace.chart" . }}
{{ include "uptrace.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "uptrace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "uptrace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "uptrace.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "uptrace.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Common initContainers-wait-for-service-dependencies definition */}}
{{- define "uptrace.initContainers" }}
- name: wait-for-service-dependencies
  image: {{ .Values.busybox.image }}
  env:
    {{- include "uptrace.clickhouseEnv" . | nindent 4 }}
  command:
    - /bin/sh
    - -c
    - >
        {{ if .Values.clickhouse.enabled }}
        until (
            wget -qO- \
                "http://$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD@{{ include "uptrace.clickhouse.fullname" . }}.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local:8123" \
                --post-data "SELECT count() FROM clusterAllReplicas('{{ .Values.clickhouse.cluster }}', system, one)"
        );
        do
            echo "waiting for ClickHouse cluster to become available"; sleep 1;
        done
        {{ end }}
{{- end }}
