{{/* Common ClickHouse ENV variables and helpers used by Uptrace */}}
{{- define "uptrace.clickhouseEnv" }}
{{- if .Values.clickhouse.enabled -}}
- name: CLICKHOUSE_HOST
  value: {{ template "uptrace.clickhouse.fullname" . }}
- name: CLICKHOUSE_CLUSTER
  value: {{ .Values.clickhouse.cluster | quote }}
- name: CLICKHOUSE_DB
  value: {{ .Values.clickhouse.database | quote }}
- name: CLICKHOUSE_USER
  value: {{ .Values.clickhouse.user | quote }}
- name: CLICKHOUSE_PASSWORD
  value: {{ .Values.clickhouse.password | quote }}
- name: CLICKHOUSE_SECURE
  value: {{ .Values.clickhouse.secure | quote }}
- name: CLICKHOUSE_VERIFY
  value: {{ .Values.clickhouse.verify | quote }}
{{- else -}}
- name: CLICKHOUSE_HOST
  value: {{ required "externalClickhouse.host is required if not clickhouse.enabled" .Values.externalClickhouse.host | quote }}
- name: CLICKHOUSE_CLUSTER
  value: {{ required "externalClickhouse.cluster is required if not clickhouse.enabled" .Values.externalClickhouse.cluster | quote }}
- name: CLICKHOUSE_DATABASE
  value: {{ .Values.externalClickhouse.database | quote }}
- name: CLICKHOUSE_USER
  value: {{ required "externalClickhouse.user is required if not clickhouse.enabled" .Values.externalClickhouse.user | quote }}
{{- if .Values.externalClickhouse.existingSecret }}
- name: CLICKHOUSE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "uptrace.clickhouse.secretName" . }}
      key: {{ include "uptrace.clickhouse.secretPasswordKey" . }}
{{- else }}
- name: CLICKHOUSE_PASSWORD
  value: {{ required "externalClickhouse.password or externalClickhouse.existingSecret is required if using external clickhouse" .Values.externalClickhouse.password | quote }}
{{- end }}
- name: CLICKHOUSE_SECURE
  value: {{ .Values.externalClickhouse.secure | quote }}
- name: CLICKHOUSE_VERIFY
  value: {{ .Values.externalClickhouse.verify | quote }}
{{- end }}
{{- end }}


{*
   ------ CLICKHOUSE ------
*}

{{/*
Return clickhouse fullname
*/}}
{{- define "uptrace.clickhouse.fullname" -}}
{{- if .Values.clickhouse.fullnameOverride -}}
{{- .Values.clickhouse.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" "clickhouse" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Return true if a secret object for ClickHouse should be created
*/}}
{{- define "uptrace.clickhouse.createSecret" -}}
{{- if and (not .Values.clickhouse.enabled) (not .Values.externalClickhouse.existingSecret) .Values.externalClickhouse.password }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse secret name
*/}}
{{- define "uptrace.clickhouse.secretName" -}}
{{- if .Values.externalClickhouse.existingSecret }}
    {{- .Values.externalClickhouse.existingSecret | quote -}}
{{- else -}}
    {{- printf "%s-external" (include "uptrace.clickhouse.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse secret key
*/}}
{{- define "uptrace.clickhouse.secretPasswordKey" -}}
{{- if .Values.externalClickhouse.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in externalClickhouse" .Values.externalClickhouse.existingSecretPasswordKey | quote }}
{{- else -}}
    {{- printf "clickhouse-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse image
*/}}
{{- define "uptrace.clickhouse.image" -}}
"{{ .Values.clickhouse.image.repository }}:{{ .Values.clickhouse.image.tag }}"
{{- end -}}
