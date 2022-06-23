{{- define "uptrace.config" -}}
{{- .Values.config | toYaml }}
{{- end }}
