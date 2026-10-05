{{/*
Expand the name of the chart.
*/}}
{{- define "uptrace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 48 chars (not 63) to leave room for resource-name suffixes
like "-redis", "-migrate", "-validate", and StatefulSet pod ordinals
(e.g. "-redis-0"), which Kubernetes appends and still must fit within the
63-char DNS label limit.
*/}}
{{- define "uptrace.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 48 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 48 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 48 | trimSuffix "-" }}
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

{{/*
The name of the Secret that holds service.secret.
*/}}
{{- define "uptrace.secretName" -}}
{{- printf "%s-secret" (include "uptrace.fullname" .) }}
{{- end }}

{{/*
The env entry that gives service.secret to an Uptrace container. The config
reads it as ${UPTRACE_SECRET}.
*/}}
{{- define "uptrace.secretEnv" -}}
- name: UPTRACE_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "uptrace.secretName" . }}
      key: secret
{{- end }}

{{/*
Fail the render when service.secret holds a value that Uptrace refuses outside
the dev env: the shipped placeholder FIXME or an empty string.
*/}}
{{- define "uptrace.checkSecret" -}}
{{- $service := .Values.uptrace.config.service | default dict }}
{{- if ne (toString $service.env) "dev" }}
{{- if eq (toString .Values.uptrace.secret) "FIXME" }}
{{- fail "uptrace.secret is the placeholder FIXME. Remove it to generate a random secret, or set a random value, e.g. from 'openssl rand -hex 32'." }}
{{- end }}
{{- $secret := toString $service.secret }}
{{- if or (eq $secret "FIXME") (eq (trim $secret) "") (eq $secret "<nil>") }}
{{- fail "uptrace.config.service.secret is FIXME or empty, and Uptrace refuses to start with it. Set it to ${UPTRACE_SECRET} to use the generated secret, or set a random value, e.g. from 'openssl rand -hex 32'." }}
{{- end }}
{{- end }}
{{- end }}
