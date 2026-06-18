{{- define "uptrace.pod" -}}
{{- with .Values.uptrace.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "uptrace.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.containerSecurityContext | nindent 6 }}
    image: "{{ .Values.uptrace.image.repository }}:{{ .Values.uptrace.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.uptrace.image.pullPolicy }}
    args: ["serve"]
    volumeMounts:
      - name: config
        mountPath: /etc/uptrace/config.yml
        subPath: uptrace.yml
    ports:
      - name: http
        containerPort: {{ .Values.uptrace.config.listen.http.addr | splitList ":" | last }}
        protocol: TCP
      - name: grpc
        containerPort: {{ .Values.uptrace.config.listen.grpc.addr | splitList ":" | last }}
        protocol: TCP
    {{ with (tpl .Values.uptrace.config.site.url $) | urlParse }}
    livenessProbe:
      httpGet:
        path: {{ .path }}
        port: http
        scheme: {{ if $.Values.uptrace.config.listen.tls }}HTTPS{{ else }}HTTP{{ end }}
    readinessProbe:
      httpGet:
        path: {{ .path }}
        port: http
        scheme: {{ if $.Values.uptrace.config.listen.tls }}HTTPS{{ else }}HTTP{{ end }}
    {{ end }}
    env:
    {{- if .Values.postgresql.enabled }}
      - name: PG_HOST
        valueFrom:
          secretKeyRef:
            name: uptrace-postgresql-app
            key: host
      - name: PG_USER
        valueFrom:
          secretKeyRef:
            name: uptrace-postgresql-app
            key: username
      - name: PG_PASSWORD
        valueFrom:
          secretKeyRef:
            name: uptrace-postgresql-app
            key: password
      - name: PG_DATABASE
        valueFrom:
          secretKeyRef:
            name: uptrace-postgresql-app
            key: dbname
      {{- end }}
      {{- toYaml .Values.uptrace.env | nindent 6 }}
    envFrom:
      {{- toYaml .Values.uptrace.envFrom | nindent 6 }}
    resources:
      {{- toYaml .Values.uptrace.resources | nindent 6 }}
{{- with .Values.uptrace.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.uptrace.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.uptrace.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
volumes:
  - name: config
    configMap:
      name: {{ include "uptrace.fullname" . }}

{{- end }}